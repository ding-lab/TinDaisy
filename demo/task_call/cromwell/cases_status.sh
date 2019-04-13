#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Print out per-case run statistics 
Specific to cromwell

Usage:
  cases_status.sh [options] CASE [CASE1 CASE2 ...]

Options:
-h: Print this help message
-1: Stop after one

If CASE is - then read CASE from STDIN

Evaluates the following information for each case
* The workflow ID of the cromwell job
* Status as queried from https://genome-cromwell.gsc.wustl.edu/

Extract and print Workflow ID associated with given cromwell output file
Note that this script requires `jq` to be installed: https://stedolan.github.io/jq/download/
EOF

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo $SCRIPT Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

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

# Defaults
CASES="dat/cases.dat"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":h1c:" opt; do
  case $opt in
    h)
      echo "$USAGE"
      exit 0
      ;;
    1) # Stop after 1
      JUST_ONCE=1
      ;;
    c) # Stop after 1
      CASES="$OPTARG"
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG"
      echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument."
      echo "$USAGE"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

function getWID {
    LOG=$1
    W=$(grep "SingleWorkflowRunnerActor: Workflow submitted" $LOG | sed 's/\x1b\[[0-9;]*m//g' | sed -n -e 's/^.*submitted //p')
    test_exit_status
    echo $W
}

function get_status {
    WID=$1
    R=$( curl -s -X GET "https://genome-cromwell.gsc.wustl.edu/api/workflows/v1/$WID/status" -H "accept: application/json" )
    test_exit_status
    # from /Users/mwyczalk/Projects/Rabix/somatic_sv_workflow/src/make_analysis_summary.sh
    # extract result path from YAML-format result file using `jq` utility, and confirm that it exists
    S=$( echo $R | jq -r '.status' )
    test_exit_status
    echo $S
}

# this allows us to get case names in one of two ways:
# 1: cases_status.sh CASE1 CASE2 ...
# 2: cat cases.dat | cases_status.sh -
if [ "$1" == "-" ]; then
    CASES=$(cat - )
else
    CASES="$@"
fi

# loop over all cases, obtain WID and database status
for CASE in $CASES; do

    # Skip comments
    [[ $CASE = \#* ]] && continue

    LOG="logs/$CASE.out"
    confirm $LOG

    WID=$( getWID $LOG )
    test_exit_status

    STATUS=$(get_status $WID)

    printf "$CASE\t$WID\t$STATUS\n" 

    if [ $JUST_ONCE ]; then
        >&2 echo Stopping after one
        break
    fi

done 




