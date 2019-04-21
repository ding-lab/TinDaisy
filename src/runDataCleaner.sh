#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

# **TODO** continue implementation here
# also implement lookup of WorkflowID from runlog 

read -r -d '' USAGE <<'EOF'
Utility for logging, reporting, and cleaning Cromwell run data

Usage:
  bash datatidy.sh [options] [ CASE1 [CASE2 ...]]

Required:
-l ROOTD: datalog root directory.  Data log is then "$ROOTD/DataLog.dat" 

Optional options
-h: print usage information
-d: dry run: print commands but do not run
-1: stop after one case processed.
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-m NOTE: A note added to data log file for each case
-x TASK: Execute given task.  Values: 'query' (default), 'original', 'inputs', 'compress', 'prune', 'final', 'wipe'
-w: output additional detail for query task
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 

Datatidy performs the following task:
* `query` - Evaluate and print for each run data directory (values in brackets printed with -w)
    - case, workflowId, tidyLevel, path [, datasize, date, note]
* `original` - Marks jobs as "original" in run log
* Delete and/or compress run data.  In all cases except wipe, CWL outputs will be retained in original path
    * `inputs` - `inputs` subdirectories in all steps deleted.  This is assumed to occur for all tidy levels below
    * `compress` - All data compressed 
    * `prune` - Delete selected intermediate data, retaining compressed logs and key intermediate results
    * `final` - Keep only final outputs of each run
    * `wipe` - Delete everything

All tasks other than `query` define changes to TidyLevel and are marked as such in the run log.
The `original` task appends a line with tidy level `original` for all runs
    which have status (as obtained from `cq`) of `Succeeded` or `Failed`.
Destructive tasks require that all cases have the same status as reported by `cq`; this is to prevent 
    wildcard queries from inadvertantly deleting data.
If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.
If CASE is a WorkflowID, use that instead of CASE name

This script relies on `cq` to get WorkflowID, status and timestamps associated with each case

EOF

source cromwell_utils.sh

SCRIPT=$(basename $0)
SCRIPT_PATH=$(dirname $0)

CROMWELL_QUERY="cq"
CASES_FN="./dat/cases.dat"
NOTE=""
TASK="query"

while getopts ":hd1k:l:m:c:x:w" opt; do
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
      ROOTD="$OPTARG"
      ;;
    m)
      NOTE="$OPTARG"
      ;;
    c) 
      CROMWELL_QUERY="$OPTARG"
      ;;
    x)
      TASK="$OPTARG"
      ;;
    w) 
      QUERY_DETAIL=1
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

mkdir -p $ROOTD
test_exit_status

DATALOG="$ROOTD/DataLog.dat"

if [ ! -f $DATALOG ]; then
    >&2 echo Creating new runlog $DATALOG
    # Write header
    printf "Case\tWorkflowID\tStatus\tStartTime\tEndTime\tNote\n" > $DATALOG
    test_exit_status
fi

# Proposed architecture:
# if TASK = query: do query stuff
# elif TASK = original: do original stuff
# elif TASK = inputs ... wipe
#    for c in case:
#      push WID
#      push STATUS
#    Evaluate all status see if same
#    for W in WID:
#      clean W

for RID in $CASES; do
    # RID (run ID) may be either CASE or WorkflowID
    >&2 echo Processing $RID

    # https://stackoverflow.com/questions/2488715/idioms-for-returning-multiple-values-in-shell-scripting
    read CASE WID < <( getCaseWID $CASE )
    test_exit_status

    if [ $TASK == 'query' ]; then

# for cleaning tasks, need to build up query and then make sure there are no errors
# and status is uniform

    elif [ $TASK == 'original' ]; then

    elif [ $TASK == 'inputs' ]; then

    elif [ $TASK == 'compress' ]; then

    elif [ $TASK == 'prune' ]; then

    elif [ $TASK == 'final' ]; then

    elif [ $TASK == 'wipe' ]; then

    else
        >&2 echo ERROR: Unknown task $TASK
        >&2 echo "$USAGE"
        exit 1
    fi




    # CQL has all columns except for the note
    CQL=$( $CROMWELL_QUERY -q runlog $CASE ) 
    test_exit_status

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

>&2 echo Written to $DATALOG
