#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Print out per-case run statistics.Specific to cromwell

Usage:
  cromwell_query.sh [options] [ CASE1 [CASE2 ...] ]

Options:
-h: Print this help message
-1: Stop after one
-c CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-q QUERY: type of query, one of 'status', 'logs', 'workflowRoot', 'timing'.  Default is `status`
-s STEP: define step of interest for use with 'logs' query

Simplest usage:
    cromwell_query.sh
will return status for all cases

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.
If CASE is a UUID, treat it as the workflow ID, and don't parse any output files

Evaluates the following information for each case
* The workflow ID of the cromwell job
* Various queries from https://genome-cromwell.gsc.wustl.edu/  Supported queries:
    * status - Status of run
    * logs - List of stderr/stdout for each run.  All steps shown unless -s STEP is defined
    * workflowRoot - Path to root of cromwell output
    * timing - URL to visualize timing and progress of workflow

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
while getopts ":h1c:q:s:" opt; do
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
    s) 
      STEP="$OPTARG"
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
    if [ -z $STEP ]; then
        FILTER=".calls"
    else
        FILTER=".calls.${STEP}[0]"
    fi
    S=$( echo "$R" | jq -r "$FILTER" )
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
# 1: cromwell_query.sh CASE1 CASE2 ...
# 2: cat cases.dat | cromwell_query.sh -
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

    # Evaluate if CASE is actually a UUID.  If so, assume it is the WID and proceed
    # From https://stackoverflow.com/questions/38416602/check-if-string-is-uuid
    if [[ $CASE =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        WID=$CASE
        CASE="Unknown"
    else
        LOG="logs/$CASE.out"
        if [ -f $LOG ]; then
            WID=$( getWID $LOG )
            test_exit_status
        else
            WID="Unknown"
            STATUS="Unknown"
        fi
    fi

    if [[ $WID != "Unknown" ]]; then
        if [ "$QUERY" == 'logs' ]; then
            STATUS=$(get_logs $WID)
            STATUS=$(printf "\n$STATUS")
        elif [ "$QUERY" == 'status' ]; then
            STATUS=$(get_status $WID)
        elif [ "$QUERY" == 'workflowRoot' ]; then
            STATUS=$(get_workflowRoot $WID)
        elif [ "$QUERY" == 'timing' ]; then
            # URL as provided by tmooney on slack 
            STATUS="https://genome-cromwell.gsc.wustl.edu/api/workflows/v1/$WID/timing"
        else 
            >&2 echo ERROR: Unknown query $QUERY
            >&2 echo "$USAGE"
            exit 1
        fi
    fi

    printf "$CASE\t$WID\t$STATUS\n" 

    if [ $JUST_ONCE ]; then
        >&2 echo Stopping after one
        break
    fi

done 




