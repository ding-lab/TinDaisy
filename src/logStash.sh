#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Archive Cromwell logs

Usage:
  bash logStash.sh [options] [ CASE1 [CASE2 ...]]

Required options:

Optional options
-h: print usage information
-d: dry run: print commands but do not run
-1: stop after one case processed.
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-l LOGD: directory where runtime output (CASE.out, CASE.err, CASE.log ) written.  Default "./logs"
-T STASHD: root directory of archived logs.  Default "./logs"
-L RUNLOG: Run log path.  Default: "./logs/runlog.dat"
-y YAMLD: directory with YAML input files (named CASE.yaml).  Default "./yaml"
-F: Force stashing even if run not in runlog.dat
-f: Force stashing even if run status is not Succeeded
-c CROMWELL_QUERY: explicit path to cromwell query utility `cq`.  Default "cq" 

Move run output and YAML files to a directory named after WorkflowID

If files do not exist print a warning but proceed, so that running this utility twice does not yield
an error

If this WorkflowID does not exist in runlog file exit with an error, since not having this entry will make it hard
to map CASE to WorkflowID in future.  Override this error with -F

By default, runs which do not have status Succeeded will yield a warning and will not be moved; this
can be overwritten with -f.

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.

This script relies on `cq` to get WorkflowID and status associated with each case
EOF

source cromwell_utils.sh

SCRIPT=$(basename $0)
SCRIPT_PATH=$(dirname $0)

CROMWELL_QUERY="cq"
LOGD="./logs"
STASHD="./logs"
RUNLOG="./logs/runlog.dat"
YAMLD="./yaml"
CASES_FN="dat/cases.dat"

while getopts ":hd1k:l:T:fFc:L:" opt; do
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
    T) 
      STASHD="$OPTARG"
      ;;
    f)
      FORCE_STATUS=1    # force stashing regardless of status
      ;;
    F)
      FORCE_RUNLOG=1    # force stashing regardless of runlog
      ;;
    c) 
      CROMWELL_QUERY="$OPTARG"
      ;;
    L) 
      RUNLOG="$OPTARG"
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

# Core algorithm. For each case:
#  * Test if CASE.err, CASE.out, and CASE.yaml files exist.  If any do not, print warning and continue to next case
#  * Obtain WorkflowID of case based on CASE.out.
#  * Obtain Status of WorkflowID based on call to `cq`
#    * if Status is not "Succeeded" print warning and continue to next case, unless FORCE_STATUS=1
#  * Check if STASHD/WorkflowID directory exists.  If it does, exit with an error
#  * Check if runlog has entry with WorkflowID.  If it does not, exit with an error, unless FORCE_RUNLOG=1
#  * Move LOGD/CASE.* and YAMLD/CASE.yaml to STASHD/WorkflowID
confirm $RUNLOG

for CASE in $CASES; do
    [[ $CASE = \#* ]] && continue
    >&2 echo \*\* Processing case $CASE

    # TODO: use runlog.dat to see if this case has already been staged
    OUTFN="$LOGD/$CASE.out"
    ERRFN="$LOGD/$CASE.err"
    YAMLFN="$YAMLD/$CASE.yaml"
    if [ ! -f $OUTFN ] || [ ! -f $ERRFN ] || [ ! -f $YAMLFN ]; then
        >&2 echo WARNING: One or more log/yaml files does not exist.  Skipping this case
        >&2 echo $OUTFN  $ERRFN  $YAMLFN
        continue
    fi

    WID=$( $CROMWELL_QUERY -V -q wid $CASE ) 
    test_exit_status

    # WID may be unknown for various reasons, like error conditions.  Stashing requires that this
    # value be known; if it is not, print a complaint and go on
    if [ $WID == "Unknown" ]; then
        >&2 echo Warning: WorkflowID for $CASE is $WID.  Not stashing these logs, continuing
        continue
    fi

    STATUS=$( $CROMWELL_QUERY -V -q status $CASE ) 
    test_exit_status
    if [ $STATUS != "Succeeded" ]; then
        if [ "$FORCE_STATUS" ]; then
            >&2 echo NOTE: $CASE status is $STATUS.  Proceeding with stashing
        else
            >&2 echo WARNING: $CASE status is $STATUS.  Skipping this case
            continue
        fi
    fi

    if ! grep -F -q $WID $RUNLOG ; then
        if [ -z $FORCE_RUNLOG ]; then
            >&2 echo ERROR: Case $CASE \( $WID \) not found in $RUNLOG
            >&2 echo Register run with \`runLogger.sh\` or override with -F.  Exiting
            exit 1
        else 
            >&2 echo Warning: Case $CASE \( $WID \) not found in $RUNLOG.  Continuing
        fi
    fi

    OUTD="$STASHD/$WID"
    if [ -d $OUTD ]; then
        >&2 echo WARNING: Stash directory exists: $OUTD
        >&2 echo Skipping this case
        continue
    fi

    CMD="mkdir -p $OUTD"
    run_cmd "$CMD" "$DRYRUN"

    CMD="mv $LOGD/$CASE.* $YAMLD/$CASE.yaml $OUTD"
    run_cmd "$CMD" "$DRYRUN"

    if [ $JUSTONE ]; then
        break
    fi

done

