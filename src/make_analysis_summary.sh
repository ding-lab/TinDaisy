#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Usage: make_analysis.sh [options] CASE [ CASE2 ... ]
  Create analysis summary file reporting results for all cases

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
-C: This is a Cromwell run.  analysis_summary will have cromwell workflow ID as last column
-c CROMWELL_QUERY: explicit path to cromwell_query.sh.  Default "cromwell_query.sh" 

Analysis summary file is defined here: https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit

If CASE is - then read CASEs from STDIN
For Rabix runs, process run output in LOGD/CASE.out to obtain path to TinDaisy output data
For Cromwell runs, we rely on database calls performed by cromwell_query.sh to obtain output data.
Reads analysis pre-summary file (created during YAML file generation) and adds TinDaisy output data 
    as second column to generate an analysis summary file
If SUMMARY_OUT file is defined and exists, exit with an error.  This behavior can be modifed with -f and -a flags.
    Defining both -f and -a is an error

Note that this script requires `jq` to be installed: https://stedolan.github.io/jq/download/

EOF

SCRIPT=$(basename $0)

LOGD="./logs"
CROMWELL_QUERY="cromwell_query.sh"
while getopts ":hs:p:1l:wCc:fa" opt; do
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
    C) 
      IS_CROMWELL=1
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

# this allows us to get CASEs in one of two ways:
# 1: start_step.sh ... CASE1 CASE2 CASE3
# 2: cat CASES.dat | start_step.sh ... -
if [ $1 == "-" ]; then
    CASES=$(cat - )
else
    CASES="$@"
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

if [ -z $PRE_SUMMARY ]; then
    >&2 echo $SCRIPT: ERROR: analysis pre-summary file must be defined \(-p\)
    exit 1
fi
confirm $PRE_SUMMARY

# Write analysis summary header.  If SUMMARY_OUT not defined, write to STDOUT
if [ -z $IS_CROMWELL ]; then
    HEADER=$(printf "# case\tdisease\tresult_path\tresult_format\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\n") 
else
    HEADER=$(printf "# case\tdisease\tresult_path\tresult_format\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\tcromwell_wid\n") 
fi

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
    # analysis pre-summary
    PS_DATA=$(get_case_pre_summary $CASE $PRE_SUMMARY)
    test_exit_status
    PS_DATA_TAIL=$(echo "$PS_DATA" | cut -f 3-6) 
    DIS=$(echo "$PS_DATA" | cut -f 2) 

    if [ -z $IS_CROMWELL ]; then
        # analysis results data (output of rabix run).  Assume written in YAML format to stdout log file
        RES_DATA="$LOGD/$CASE.out"
        confirm $RES_DATA
        # extract result path from YAML-format result file using `jq` utility, and confirm that it exists
        OUTPUT_PATH=$(cat $RES_DATA | jq -r '.output.path')
        test_exit_status
    else
        OUTPUT_PATH=` $CROMWELL_QUERY -V -q output $CASE `
        test_exit_status
        WID=` $CROMWELL_QUERY -V -q wid $CASE `
        test_exit_status
        PS_DATA_TAIL=$(printf "$PS_DATA_TAIL\t$WID")
    fi
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

