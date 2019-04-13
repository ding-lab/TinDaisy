#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'

Launch Rabix or Cromwell workflow tasks for multiple cases

Usage:
  bash run_cwl_tasks.sh [options] CASE [CASE2 ...]

Required options:
-c CWL: CWL file which defines workflow

Optional options
-h: print usage information
-d: dry run: print commands but do not run
-1 : stop after one case processed.
-r RUND: principal output base directory.  Required for Rabix run
-y YAMLD: directory with YAML input files (named CASE.yaml).  Default "."
-l LOGD: directory where runtime output (CASE.out, CASE.err, CASE.log ) written.  Default "./logs"
-J N: run N tasks in parallel.  If 0, disable parallel mode. Default 0
-e: write STDERR output of workflow to terminal rather than LOGD/CASE.err
-C CROMWELL_CONFIG: Cromwell config file.  If specified, we are submitting to Cromwell, otherwise to Rabix
-D DB_ARGS: arguments for connecting to Cromwell DB.  Default as specified in Cromwell configuration page below.  If value is "none",
   will not save to database
-R CROMWELL_JAR: Cromwell JAR file.  Default: /opt/cromwell.jar
-j JAVA: path to java.  Default: /usr/bin/java

RUND contains data generated during CWL execution.  This is relevant only for Rabix, since in Cromwell it is defined in CROMWELL_CONFIG file
STDERR and STDOUT of rabix, as well as tmp dir and log of parallel, written to LOGD

Cromwell configuration is described https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell
We will incorporate saving to database as described there too

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
# Cromwell default DB Args 
DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
CROMWELL_JAR="/opt/cromwell.jar"
JAVA="/usr/bin/java"

while getopts ":c:r:y:hd1J:l:eC:D:R:j:" opt; do
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
      RUND="$OPTARG"
      ;;
    J) 
      NJOBS="$OPTARG"
      ;;
    e) 
      STDERR_OUT=1
      ;;
    C) 
      CROMWELL_CONFIG="$OPTARG"
      ;;
    D) 
      DB_ARGS="$OPTARG"
      ;;
    R) 
      CROMWELL_JAR="$OPTARG"
      ;;
    j) 
      JAVA="$OPTARG"
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
    RUND="$3"
    STDOUT_FN="$4"
    STDERR_FN="$5"

    YAML="$YAMLD/$CASE.yaml"  
    confirm "$YAML"  # this must exist
    
    # if -e is not set, write STDERR to file, otherwise no redirect (i.e., send to terminal)
    if [ -z "$STDERR_OUT" ]; then
        STDERR_REDIRECT="2> $STDERR_FN"
    fi
    
    CMD="rabix --basedir $RUND $CWL $YAML > $STDOUT_FN $STDERR_REDIRECT"

    echo "$CMD"
}

function get_cromwell_cmd {
    CWL="$1"
    CASE="$2"
    CROMWELL_CONFIG="$3"
    STDOUT_FN="$4"
    STDERR_FN="$5"

    YAML="$YAMLD/$CASE.yaml"  
    confirm "$YAML"  # this must exist
    confirm "$JAVA"
    
    # if -e is not set, write STDERR to file, otherwise no redirect (i.e., send to terminal)
    if [ -z "$STDERR_OUT" ]; then
        STDERR_REDIRECT="2> $STDERR_FN"
    fi
    
    CMD="$JAVA -Dconfig.file=$CROMWELL_CONFIG $DB_ARGS -jar $CROMWELL_JAR run -t cwl -i $YAML $CWL > $STDOUT_FN $STDERR_REDIRECT"

    echo "$CMD"
}

if [ -z $CWL ]; then
    >&2 echo $SCRIPT: ERROR: CWL file not defined \(-c\)
    exit 1
fi
confirm $CWL

# If CROMWELL_CONFIG is specified, this is a Cromwell run, and this file must exist
# If not specified, this is a Rabix run, and RUND must exist
if [ -z $CROMWELL_CONFIG ]; then
    RUN_RABIX=1

    if [ -z $RUND ]; then
        >&2 echo $SCRIPT: ERROR: Output directory not defined \(-o\)
        exit 1
    fi
    >&2 echo Creating output directory $RUND
    mkdir -p $RUND
    test_exit_status
else
    RUN_RABIX=0
    confirm $CROMWELL_CONFIG
fi

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

    if [ $RUN_RABIX == 1 ]; then
        CMD=$(get_rabix_cmd $CWL $CASE $RUND $STDOUT_FN $STDERR_FN)
        test_exit_status
    else
        CMD=$(get_cromwell_cmd $CWL $CASE $CROMWELL_CONFIG $STDOUT_FN $STDERR_FN)
        test_exit_status
    fi

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


