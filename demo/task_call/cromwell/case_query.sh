#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Print out per-case run statistics.Specific to cromwell

Usage:
  cases_status.sh [options] [ CASE1 [CASE2 ...] ]

Options:
-h: Print this help message
-1: Stop after one
-c CASES_FN: file with list of all cases, used when CASE1 not defined. Default: dat/cases.dat
-q QUERY: type of query, one of 'status', 'logs', 'workflowRoot'.  Default is `status`

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file,
which has one case name per line

Evaluates the following information for each case
* The workflow ID of the cromwell job
* Status as queried from https://genome-cromwell.gsc.wustl.edu/
  Alternatively, may obtain log details from same source

Workflow ID associated with given cromwell output file is obtaining by grepping for output line like,
[2019-04-14 15:54:01,69] [info] SingleWorkflowRunnerActor: Workflow submitted d6c83416-af3f-46f3-a892-ff1e9074fe74

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
CASES_FN="dat/cases.dat"
QUERY="status"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":h1c:q:" opt; do
  case $opt in
    h)
      echo "$USAGE"
      exit 0
      ;;
    1) # Stop after 1
      JUST_ONCE=1
      ;;
    c) 
      CASES_FN="$OPTARG"
      ;;
    q) 
      QUERY="$OPTARG"
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

function get_logs {
    WID=$1
    R=$( curl -s -X GET "https://genome-cromwell.gsc.wustl.edu/api/workflows/v1/$WID/logs" -H "accept: application/json" )
    test_exit_status
    # from /Users/mwyczalk/Projects/Rabix/somatic_sv_workflow/src/make_analysis_summary.sh
    # extract result path from YAML-format result file using `jq` utility, and confirm that it exists
    S=$( echo "$R" | jq -r '.calls' )
    test_exit_status
    echo "$S"
}

function get_workflowRoot {
    WID=$1
    R=$( curl -s -X GET "https://genome-cromwell.gsc.wustl.edu/api/workflows/v1/$WID/metadata" -H "accept: application/json" )
    test_exit_status
    S=$( echo "$R" | jq -r '.workflowRoot' )
    test_exit_status
    echo "$S"
}



# this allows us to get case names in one of three ways:
# 1: cases_status.sh CASE1 CASE2 ...
# 2: cat cases.dat | cases_status.sh -
# 3: read from CASES file
# Note that if no cases defined, assume CASE='-'
if [ "$#" == 0 ]; then
    confirm $CASES_FN
    CASES=$(cat $CASES_FN)
elif [ "$1" == "-" ] ; then
    CASES=$(cat - )
else
    CASES="$@"
fi

# loop over all cases, obtain WID and database status
# If log file does not exist, assume that the run has not started
for CASE in $CASES; do

    # Skip comments
    [[ $CASE = \#* ]] && continue

    LOG="logs/$CASE.out"
    if [ -f $LOG ]; then
        WID=$( getWID $LOG )
        test_exit_status

        if [ "$QUERY" == 'logs' ]; then
            STATUS=$(get_logs $WID)
            STATUS=$(printf "\n$STATUS")
        elif [ "$QUERY" == 'status' ]; then
            STATUS=$(get_status $WID)
        elif [ "$QUERY" == 'workflowRoot' ]; then
            STATUS=$(get_workflowRoot $WID)
        else 
            >&2 echo ERROR: Unknown query $QUERY
            >&2 echo "$USAGE"
            exit 1
        fi
    else
        WID="Unknown"
        STATUS="Unknown"
    fi

    printf "$CASE\t$WID\t$STATUS\n" 

    if [ $JUST_ONCE ]; then
        >&2 echo Stopping after one
        break
    fi

done 




