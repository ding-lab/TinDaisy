#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Usage: make_analysis.sh [options] [ CASE1 [ CASE2 ... ]]
  Create analysis summary file reporting results for cromwell runs

Required arguments:
-p: analysis pre-summary file.  Required, must exist

Options:
-h: print usage information
-s SUMMARY_OUT: output analysis results file.  If not defined, written to STDOUT
-a: If SUMMARY_OUT is defined and that file exists, append to it
-f: If SUMMARY_OUT is defined and that file exists, overwrite it
-1: Quit after evaluating one case
-l LOGD: directory where runtime output written.  Default "./logs"
-w: Issue warning instead of error if output file does not exist
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat

Analysis summary file is defined here: https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.
We rely on database calls performed by `cq` to obtain output data.
Reads analysis pre-summary file (created during YAML file generation) and adds result data
    to generate an analysis summary file
If SUMMARY_OUT file is defined and exists, exit with an error.  This behavior can be modifed with -f and -a flags.
    Defining both -f and -a is an error

Note that this script requires `jq` to be installed: https://stedolan.github.io/jq/download/

EOF

SCRIPT=$(basename $0)

# Defaults
LOGD="./logs"
CROMWELL_QUERY="cq"
CASES_FN="dat/cases.dat"

while getopts ":hs:p:1l:wc:fak:" opt; do
  case $opt in
    h)  # Required
      echo "$USAGE"
      exit 0
      ;;
    s)  
      SUMMARY_OUT="$OPTARG"
      ;;
    p)  
      PRE_SUMMARY="$OPTARG"
      ;;
    1)  
      JUSTONE=1
      ;;
    l) 
      LOGD="$OPTARG"
      ;;
    w) 
      ONLYWARN=1
      ;;
    f) 
      SUMMARY_OVERWRITE=1
      ;;
    a) 
      SUMMARY_APPEND=1
      ;;
    c) 
      CROMWELL_QUERY="$OPTARG"
      ;;
    k) 
      CASES_FN="$OPTARG"
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      >&2 echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      >&2 echo "$USAGE"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ "$#" -lt 1 ]; then
    >&2 echo ERROR: Wrong number of arguments
    >&2 echo "$USAGE"
    exit 1
fi

if [ "$SUMMARY_OVERWRITE" ] && [ "$SUMMARY_APPEND" ]; then
    >&2 echo ERROR: Cannot define both -f and -a
    >&2 echo "$USAGE"
    exit 1
fi

function confirm {
    FN=$1
    WARN=$2
    if [ ! -s $FN ]; then
        if [ -z $WARN ]; then
            >&2 echo ERROR: $FN does not exist or is empty
            exit 1
        else
            >&2 echo WARNING: $FN does not exist or is empty.  Continuing
        fi
    fi
}

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo $SCRIPT: Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

# searches analysis pre-summary file for given case
# Requires that case names are unique
function get_case_pre_summary {
    CASE=$1
    PRE_SUMMARY=$2

    LINE_A=$(awk -v c=$CASE 'BEGIN{FS="\t";OFS="\t"}{if ($1 == c) print $0 }' $PRE_SUMMARY)

    if [ -z "$LINE_A" ]; then
        >&2 echo ERROR: Case $CASE not found in $PRE_SUMMARY
        exit 1
    elif [ $(echo "$LINE_A" | wc -l) != "1" ]; then
        >&2 echo ERROR: Case $CASE has multiple matches in $PRE_SUMMARY
        exit 1
    fi

    echo "$LINE_A"
}

# this allows us to get case names in one of three ways:
# 1: cq CASE1 CASE2 ...
# 2: cat cases.dat | cq -
# 3: read from CASES_FN file
# Note that if no cases defined, assume CASE='-'
if [ "$#" == 0 ]; then
    confirm $CASES_FN
    CASES=$(cat $CASES_FN)
elif [ "$1" == "-" ] ; then
    CASES=$(cat - )
else
    CASES="$@"
fi

if [ -z $PRE_SUMMARY ]; then
    >&2 echo $SCRIPT: ERROR: analysis pre-summary file must be defined \(-p\)
    exit 1
fi
confirm $PRE_SUMMARY

# Write analysis summary header.  If SUMMARY_OUT not defined, write to STDOUT
HEADER=$(printf "# case\tdisease\tresult_path\tresult_format\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\tcromwell_wid\n") 

if [ ! -z $SUMMARY_OUT ]; then
    SD=$(dirname $SUMMARY_OUT)
    if [ ! -d $SD ]; then
        >&2 echo Making output directory for analysis summary: $SD
        mkdir -p $SD
        test_exit_status
    fi
    # If SUMMARY_OUT exists, evaluate whether to append or overwrite
    if [ -f $SUMMARY_OUT ]; then
        if [ "$SUMMARY_OVERWRITE" ]; then
            echo "$HEADER" > $SUMMARY_OUT
        elif [ "$SUMMARY_APPEND" ]; then
            :   # don't do anything; later on we'll append
        else    # this is an error
            >&2 echo ERROR: $SUMMARY_OUT exists 
            >&2 echo Move / delete this file, append with -a, or overwrite with -f
            exit 1
        fi
    fi 
    test_exit_status
else
    echo "$HEADER"
fi


FILE_FORMAT="VCF"
for CASE in $CASES
do
    [[ $CASE = \#* ]] && continue
    # analysis pre-summary
    PS_DATA=$(get_case_pre_summary $CASE $PRE_SUMMARY)
    test_exit_status
    PS_DATA_TAIL=$(echo "$PS_DATA" | cut -f 3-6) 
    DIS=$(echo "$PS_DATA" | cut -f 2) 

    OUTPUT_PATH=` $CROMWELL_QUERY -V -q output $CASE `
    test_exit_status
    WID=` $CROMWELL_QUERY -V -q wid $CASE `
    test_exit_status
    PS_DATA_TAIL=$(printf "$PS_DATA_TAIL\t$WID")
    DATA=$(printf "$CASE\t$DIS\t$OUTPUT_PATH\t$FILE_FORMAT\t$PS_DATA_TAIL\n")

    confirm $OUTPUT_PATH $ONLYWARN
    

    if [ ! -z $SUMMARY_OUT ]; then
        echo "$DATA" >> $SUMMARY_OUT
    else
        echo "$DATA" 
    fi

    if [ $JUSTONE ]; then
        >&2 echo Quitting after one
        exit 0
    fi
done

if [ ! -z $SUMMARY_OUT ]; then
    >&2 echo Analysis summary written to $SUMMARY_OUT
fi

