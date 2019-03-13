#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'

Launch Rabix workflow tasks for multiple cases

Usage:
  bash run_rabix_tasks.sh [options] CASE [CASE2 ...]

Required options:
-c CWL: CWL file which defines workflow
-r RABIXD: RABIX output base directory

Optional options
-y YAMLD: directory with YAML input files (named CASE.yaml).  Default "."
-l LOGD: directory where runtime output (CASE.out, CASE.err, CASE.log ) written.  Default "./logs"
-h: print usage information
-d: dry run: print commands but do not run
-1 : stop after one case processed.
-J N: run N tasks in parallel.  If 0, disable parallel mode. Default 0
-e: write STDERR output of Rabix to terminal rather than LOGD/CASE.err

RABIXD contains data generated during CWL execution
STDERR and STDOUT of rabix, as well as tmp dir and log of parallel, written to LOGD

EOF

# Background on `parallel` and details about blocking / semaphores here:
#    O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
#    ;login: The USENIX Magazine, February 2011:42-47.
# [ https://www.usenix.org/system/files/login/articles/105438-Tange.pdf ]

SCRIPT=$(basename $0)
SCRIPT_PATH=$(dirname $0)

NJOBS=0
YAMLD="."
LOGD="./logs"

while getopts ":y:c:r:hd1J:l:e" opt; do
  case $opt in
    h) 
      echo "$USAGE"
      exit 0
      ;;
    d)  # -d is a stack of parameters, each script popping one off until get to -d
      DRYRUN="d$DRYRUN"
      ;;
    1) 
      JUSTONE=1
      ;;
    y) 
      YAMLD="$OPTARG"
      ;;
    l) 
      LOGD="$OPTARG"
      ;;
    c) 
      CWL=$OPTARG
      ;;
    r) 
      RABIXD="$OPTARG"
      ;;
    J) 
      NJOBS="$OPTARG"
      ;;
    e) 
      STDERR_OUT=1
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

# Evaluate given command CMD either as dry run or for real
function run_cmd {
    CMD=$1

    if [ "$DRYRUN" == "d" ]; then
        >&2 echo Dryrun: $CMD
    else
        >&2 echo Running: $CMD
        eval $CMD
        test_exit_status
    fi
}

# test if file exists and is not empty, exit with error otherwise
function confirm {
    FN=$1
    if [ ! -s $FN ]; then
        >&2 echo ERROR: $FN does not exist or is empty
        exit 1
    fi
}

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

function get_rabix_cmd {
    CWL="$1"
    CASE="$2"
    RABIXD="$3"
    STDOUT_FN="$4"
    STDERR_FN="$5"

    YAML="$YAMLD/$CASE.yaml"  
    confirm "$YAML"  # this must exist
    
    # if -e is not set, write STDERR to file, otherwise no redirect (i.e., send to terminal)
    if [ -z "$STDERR_OUT" ]; then
        STDERR_REDIRECT="2> $STDERR_FN"
    fi
    
    CMD="rabix --basedir $RABIXD $CWL $YAML > $STDOUT_FN $STDERR_REDIRECT"

    echo "$CMD"
}

if [ -z $CWL ]; then
    >&2 echo $SCRIPT: ERROR: CWL file not defined \(-c\)
    exit 1
fi
confirm $CWL

if [ -z $RABIXD ]; then
    >&2 echo $SCRIPT: ERROR: RABIX output directory not defined \(-o\)
    exit 1
fi
>&2 echo Creating output directory $RABIXD
mkdir -p $RABIXD
test_exit_status

mkdir -p $LOGD
test_exit_status

# Used for `parallel` job groups 
NOW=$(date)
MYID=$(date +%Y%m%d%H%M%S)

# this allows us to get CASEs in one of two ways:
# 1: process_cases.sh ... CASE1 CASE2 CASE3
# 2: cat CASES.dat | process_cases.sh ... -
if [ "$1" == "-" ]; then
    CASES=$(cat - )
else
    CASES="$@"
fi

if [ -z "$CASES" ]; then
    >&2 echo ERROR: no case names specified
    exit 1
fi

if [ $NJOBS == 0 ] ; then
    >&2 echo Running single case at a time \(single mode\)
else
    >&2 echo Job submission with $NJOBS cases in parallel
fi

for CASE in $CASES; do
    >&2 echo Processing case $CASE

    STDOUT_FN="$LOGD/$CASE.out"
    STDERR_FN="$LOGD/$CASE.err"

    CMD=$(get_rabix_cmd $CWL $CASE $RABIXD $STDOUT_FN $STDERR_FN)
    test_exit_status

    if [ $NJOBS != 0 ]; then
        JOBLOG="$LOGD/$CASE.log"
        CMD=$(echo "$CMD" | sed 's/"/\\"/g' )   # This will escape the quotes in $CMD 
        CMD="parallel --semaphore -j$NJOBS --id $MYID --joblog $JOBLOG --tmpdir $LOGD \"$CMD\" "
    fi

    run_cmd "$CMD"
    >&2 echo Written to $STDOUT_FN

    if [ $JUSTONE ]; then
        break
    fi

done

if [ $NJOBS != 0 ]; then
    # this will wait until all jobs completed
    CMD="parallel --semaphore --wait --id $MYID"
    run_cmd "$CMD"
fi


