#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

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
-F EXPECTED_STATUS: Define expected status of runs 
-w: output additional detail for query task
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 

Datatidy performs the following task:
* `query` - Evaluate and print for each run data directory (values in brackets printed with -w)
    - case, workflowId, tidyLevel, path [, datasize, date, note]
* `original` - Registers run data, marking it as "original" in data log
* Delete and/or compress run data.  In all cases except wipe, CWL outputs will be retained in original path
    * `inputs` - `inputs` subdirectories in all steps deleted.  This is assumed to occur for all tidy levels below
    * `compress` - All data compressed 
    * `prune` - Delete selected intermediate data, retaining compressed logs and key intermediate results
    * `final` - Keep only final outputs of each run
    * `wipe` - Delete everything

All tasks other than `query` define changes to TidyLevel and are marked as such in the data log.
The `original` task appends a line with tidy level `original` for all runs.  If EXPECTED_STATUS is not defined,
    process all runs which have have status (as obtained from `cq`) of `Succeeded` or `Failed` and silently
    ignore others.
If EXPECTED_STATUS is defined, require that status of all cases is the same as EXPECTED_STATUS.  This is checked
    for all runs before any data deletion occurs.
Destructive tasks require that EXPECTED_STATUS be defined.  This will help avoid inadvertantly deleting data.

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

while getopts ":hd1k:l:m:c:x:wF:" opt; do
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
    F) 
      EXPECTED_STATUS="$OPTARG"
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

DATALOG="$ROOTD/datalog.dat"

if [ ! -f $DATALOG ]; then
    >&2 echo Creating new data log $DATALOG
    # Write header
    printf "Case\tWorkflowID\tDate\tTidyLevel\tNote\n" > $DATALOG
    test_exit_status
fi

# Given a WorkflowID, return the most recent entry from datalog
# The entire data log line is returned:
#   Case WorkflowID Date TidyLevel Note
# If workflowID is not found, return "Unknown"
function parseDataLog {
    WID=$1
    DATALOG=$2
    confirm $DATALOG

    # Search runlog from bottom, return column 1 of first matching line
    DL=$( tac $DATALOG | grep -m 1 -F "$WID"  )
    test_exit_status
    if [ -z $DL ]; then
        DL="Unregistered"
    fi
    echo "$DL"
}

# Given a run ID (case or WorkflowID), print
# to stdout the following fields: case, workflowId, tidyLevel, path 
# If QUERY_DETAIL, also evaluate and print: datasize, date, note
function do_query {
    RID=$1
    # get case and WorkflowID, based on runlog parser in cromwell_utils.sh
    read MYCASE MYWID < <( getCaseWID $RID )
    # get additional details from datalog
    #   Case WorkflowID Date TidyLevel Note
    DL=$(parseDataLog $MYWID $DATALOG)
    test_exit_status
    # DL = Unregistered
    if [ "$DL" == "Unregistered" ]; then
        printf "$MYCASE\t$MYWID\tUnregistered\n"
        return
    fi
    DL_DATE=$( echo "$DL" | cut -f 3 )
    TIDYLEVEL=$( echo "$DL" | cut -f 4 )
    NOTE=$( echo "$DL" | cut -f 5 )

    # There are two ways to get DATAD, aka the workflowRoot directory:
    # * ROOTD/WID should work in situations where workflow directory is same for every run
    # * `cq -q workflowRoot` is safer, since not making any assumptions about whether run output is 
    #   uniform.  This is slower and requires Cromwell server, but is the method we'll use
    DATAD=$( $CROMWELL_QUERY -V -q workflowRoot $MYWID )
    test_exit_status

    if [ "$QUERY_DETAIL" ]; then
        DATASIZE=$(du -sh "$DATAD" | cut -f 1)
        test_exit_status
        print "$MYCASE\t$MYWID\t$TIDYLEVEL\t$DATAD\t$SIZE\t$DL_DATE\t$NOTE\n" 
    else
        print "$MYCASE\t$MYWID\t$TIDYLEVEL\t$DATAD\n" 
    fi
}

# Write entry to datalog file 
function register_original {
    RID=$1
    # get case and WorkflowID, based on runlog parser in cromwell_utils.sh
    read MYCASE MYWID < <( getCaseWID $RID )

}

# Docket is a list of Workflow ID and Status pairs of proposed 
# 
function get_docket {


}

# for cleaning tasks, need to build up query and then make sure there are no errors
# and status is uniform

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


#https://stackoverflow.com/questions/21157435/bash-string-compare-to-multiple-correct-values

case "$TASK" in
  "query")
    for RID in $CASES; do
        do_query $RID 
    done
    ;;
  "original")
    for RID in $CASES; do
        register_original $RID 
    done
    ;;
  "inputs"|"compress"|"prune"|"final"|"wipe")
    do_your_else_case
    ;;
  *)
    >&2 echo ERROR: Unknown task $TASK
    >&2 echo "$USAGE"
    exit 1
    ;;
esac



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


>&2 echo Written to $DATALOG
