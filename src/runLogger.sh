#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Utility for logging Cromwell runs

Usage:
  bash runLogger.sh [options] [ CASE1 [CASE2 ...]]

Required options:

Optional options
-h: print usage information
-d: dry run: print commands but do not run
-1: stop after one case processed.
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-l LOGD: directory where runtime output (CASE.out, CASE.err, CASE.log ) written.  Default "./logs"
-L LOG_OUT: Output log path.  Default: "./logs/runlog.dat"
-f: Force logging even if run status is not Succeeded / Failed
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 


If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.


This script relies on `cq` to get WorkflowID, status and timestamps associated with each case

EOF

source cromwell_utils.sh

SCRIPT=$(basename $0)
SCRIPT_PATH=$(dirname $0)

CROMWELL_QUERY="cq"
LOGD="./logs"
LOG_OUT="./logs/runlog.dat"
CASES_FN="dat/cases.dat"
NOTE=""

while getopts ":hd1k:l:L:m:c:f" opt; do
  case $opt in
    h) 
      echo "$USAGE"
      exit 0
      ;;
    d)  # echo work command instead of evaluating it
      DRYRUN="d"
      ;;
    1) 
      JUSTONE=1
      ;;
    k) 
      CASES_FN="$OPTARG"
      ;;
    l) 
      LOGD="$OPTARG"
      ;;
    L) 
      LOG_OUT="$OPTARG"
      ;;
    m)
      NOTE="$OPTARG"
      ;;
    f)
      FORCE_STATUS=1        
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

mkdir -p $LOGD
test_exit_status

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

if [ ! -f $LOG_OUT ]; then
    >&2 echo Creating new runlog $LOG_OUT
    # Write header
    printf "# Case\tWorkflowID\tStatus\tStartTime\tEndTime\tNote\n" > $LOG_OUT
    test_exit_status
fi

for CASE in $CASES; do
    >&2 echo Processing case $CASE

    STATUS=$( $CROMWELL_QUERY -V -q status $CASE )
    # Normally, write only entries with status Succeeded or Failed.  If -f flag (FORCE_STATUS) is set, write for all entries regardless of status
    if [ "$STATUS" != "Succeeded" ] && [ "$STATUS" != "Failed" ]; then
        if [ ! "$FORCE_STATUS" ]; then
                >&2 echo Skipping because of status
                continue
        fi
    fi

    # CQL has all columns except for the note
    CQL=$( $CROMWELL_QUERY -q runlog $CASE ) 
    test_exit_status
    WID=$( echo "$CQL" | cut -f 2 )
    if [ $WID == "Unknown" ] || [ $WID == "Unassigned" ]; then
        continue
    fi

    RL=$( printf "$CQL\t$NOTE\n" )

    if [ "$DRYRUN" ]; then
        >&2 echo Dryrun: runlog = "$RL"
    else
        echo "$RL" >> $LOG_OUT
    fi

    if [ $JUSTONE ]; then
        break
    fi

done

>&2 echo Written to $LOG_OUT
