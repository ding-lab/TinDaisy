#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Usage: summarize_cromwell_runs.sh [options] [ CASE1 [ CASE2 ... ]]
  Create analysis summary file reporting results for cromwell runs

Options:
-h: print usage information
-p PRE_SUMMARY: analysis pre-summary file.  Must exist, default is ./dat/analysis_pre-summary.dat
-s SUMMARY_OUT: output analysis results file.  If not defined, written to STDOUT
-a SUMMARY_POLICY: 'throw' (default), 'append', 'overwrite', 'stdout'
-1: Quit after evaluating one case
-l LOGD: directory where runtime output written.  Default "./logs"
-w: Issue warning instead of error if output file does not exist
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat

Read an "analysis pre-summary" file (created during YAML file generation), add result data to generate an analysis summary file
Analysis summary file is defined here: https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.
We rely on cromwell database calls performed by `cq` to obtain output data.
SUMMARY_POLICY allows summary output file to be directed to STDOUT, or defines what to do if existing file SUMMARY_OUT is 
    encountered.  Values 'throw', 'append', and 'overwrite' will generate an error, append to the existing file,
    or overwrite it, respectively.

Note that this script requires `jq` to be installed: https://stedolan.github.io/jq/download/

EOF

source cromwell_utils.sh

SCRIPT=$(basename $0)

# Defaults
LOGD="./logs"
CROMWELL_QUERY="cq"
SUMMARY_POLICY="throw"
PRE_SUMMARY="./dat/analysis_pre-summary.dat"
SUMMARY_OUT="./dat/analysis_summary.dat"
CASES_FN="dat/cases.dat"

while getopts ":hs:p:1l:wc:a:k:" opt; do
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
    a) 
      SUMMARY_POLICY="$OPTARG"
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

# Write analysis summary header
HEADER=$(printf "# case\tdisease\tresult_path\tresult_format\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\tcromwell_wid\n") 

if [ $SUMMARY_POLICY == "stdout" ]; then
    echo "$HEADER"
else
    SD=$(dirname $SUMMARY_OUT)
    if [ ! -d $SD ]; then
        >&2 echo Making output directory for analysis summary: $SD
        mkdir -p $SD
        test_exit_status
    fi

    # If SUMMARY_OUT exists, evaluate whether to append or overwrite
    if [ -f $SUMMARY_OUT ]; then
        if [ "$SUMMARY_POLICY" == "overwrite" ]; then 
            echo "$HEADER" > $SUMMARY_OUT
        elif [ "$SUMMARY_POLICY" == "append" ]; then
            :   # don't do anything; later on we'll append
        elif [ "$SUMMARY_POLICY" == "throw" ]; then # this is an error
            >&2 echo ERROR: $SUMMARY_OUT exists 
            >&2 echo Move / delete this file, append with -a, or overwrite with -f
            exit 1
        else
            >&2 echo ERROR: Unknown SUMMARY_POLICY: $SUMMARY_POLICY
            >&2 echo "$USAGE"
            exit 1
        fi
        test_exit_status
    else
        echo "$HEADER" > $SUMMARY_OUT
    fi 
fi


FILE_FORMAT="VCF"
for CASE in $CASES
do
    [[ $CASE = \#* ]] && continue
    >&2 echo Processing $CASE
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

    if [ $SUMMARY_POLICY == "stdout" ]; then
        echo "$DATA" 
    else
        echo "$DATA" >> $SUMMARY_OUT
    fi

    if [ $JUSTONE ]; then
        >&2 echo Quitting after one
        break
    fi
done

if [ ! -z $SUMMARY_OUT ]; then
    >&2 echo Analysis summary written to $SUMMARY_OUT
fi

