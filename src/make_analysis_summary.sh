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
-s SUMMARY: output analysis results file.  If not defined, written to STDOUT
-1: Quit after evaluating one case
-l LOGD: directory where runtime output written.  Default "./logs"
-w: Issue warning instead of error if output file does not exist

If CASE is - then read CASEs from STDIN
Processes rabix run output in LOGD/CASE.out to obtain path to SomaticSV output data
Reads analysis pre-summary file (created during YAML file generation) and adds SomaticSV output data 
    as second column to generate an analysis summary file

Note that this script requires `jq` to be installed: https://stedolan.github.io/jq/download/

EOF

SCRIPT=$(basename $0)

LOGD="./logs"
while getopts ":hs:p:1l:w" opt; do
  case $opt in
    h)  # Required
      echo "$USAGE"
      exit 0
      ;;
    s)  
      SUMMARY="$OPTARG"
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
    >&2 echo Usage: make_docker_map.sh \[options\] CASE \[CASE2 ...\]
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

    LINE_A=$(awk -v c=$CASE 'BEGIN{FS="\t";OFS="\t"}{if ($1 == c) print}' $PRE_SUMMARY)

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

# Write analysis summary header.  If SUMMARY not defined, write to STDOUT
HEADER=$(printf "# case\tdata\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\n") 
if [ ! -z $SUMMARY ]; then
    SD=$(dirname $SUMMARY)
    if [ ! -d $SD ]; then
        >&2 echo Making output directory for analysis summary: $SD
        mkdir -p $SD
        test_exit_status
    fi
    echo "$HEADER" > $SUMMARY
    test_exit_status
else
    echo "$HEADER"
fi

for CASE in $CASES
do
    # analysis pre-summary
    PS_DATA=$(get_case_pre_summary $CASE $PRE_SUMMARY)
    test_exit_status

    # analysis results data (output of rabix run).  Assume written in YAML format to stdout log file
    RES_DATA="$LOGD/$CASE.out"
    confirm $RES_DATA

    # extract result path from YAML-format result file using `jq` utility, and confirm that it exists
    OUTPUT_PATH=$(cat $RES_DATA | jq -r '.output.path')
    test_exit_status
    confirm $OUTPUT_PATH $ONLYWARN
    
    PS_DATA_TAIL=$(echo "$PS_DATA" | cut -f 2-5) # 
    DATA=$(printf "$CASE\t$OUTPUT_PATH\t$PS_DATA_TAIL\n")

    if [ ! -z $SUMMARY ]; then
        echo "$DATA" >> $SUMMARY
    else
        echo "$DATA" 
    fi

    if [ $JUSTONE ]; then
        >&2 echo Quitting after one
        exit 0
    fi
done

if [ ! -z $SUMMARY ]; then
    >&2 echo Analysis summary written to $SUMMARY
fi

