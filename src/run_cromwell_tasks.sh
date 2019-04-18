#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Launch Cromwell workflow tasks for multiple cases

Usage:
  bash run_cwl_tasks.sh [options] [ CASE1 [CASE2 ...]]

Required options:
-c CWL: CWL file which defines workflow
-C CROMWELL_CONFIG: Cromwell config file. Required.

Optional options
-h: print usage information
-d: dry run: print commands but do not run
-1 : stop after one case processed.
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-y YAMLD: directory with YAML input files (named CASE.yaml).  Default "."
-l LOGD: directory where runtime output (CASE.out, CASE.err, CASE.log ) written.  Default "./logs"
-J N: run N tasks in parallel.  If 0, disable parallel mode. Default 0
-e: write STDERR output of workflow to terminal rather than LOGD/CASE.err
-D DB_ARGS: arguments for connecting to Cromwell DB.  Default as specified in Cromwell configuration page below.  If value is "none",
   will not save to database
-R CROMWELL_JAR: Cromwell JAR file.  Default: /opt/cromwell.jar
-j JAVA: path to java.  Default: /usr/bin/java

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.

STDERR and STDOUT of workflow runs, as well as tmp dir and log of parallel, written to LOGD
YAML files for a given CASE are assumed to be $YAMLD/$CASE.yaml

Cromwell configuration, including database connection, is described 
    https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell

EOF

# Background on `parallel` and details about blocking / semaphores here:
#    O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
#    ;login: The USENIX Magazine, February 2011:42-47.
# [ https://www.usenix.org/system/files/login/articles/105438-Tange.pdf ]

source cromwell_utils.sh

SCRIPT=$(basename $0)
SCRIPT_PATH=$(dirname $0)

NJOBS=0
YAMLD="."
LOGD="./logs"
# Cromwell default DB Args 
DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
CROMWELL_JAR="/opt/cromwell.jar"
JAVA="/usr/bin/java"
CASES_FN="dat/cases.dat"

while getopts ":c:y:hd1J:l:eC:D:R:j:k:" opt; do
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
    y) 
      YAMLD="$OPTARG"
      ;;
    l) 
      LOGD="$OPTARG"
      ;;
    c) 
      CWL=$OPTARG
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
    echo "$USAGE"
    exit 1
fi
confirm $CWL

if [ -z $CROMWELL_CONFIG ]; then
    >&2 echo $SCRIPT: ERROR: Cromwell config file not defined \(-C\)
    echo "$USAGE"
    exit 1
fi
confirm $CROMWELL_CONFIG 

mkdir -p $LOGD
test_exit_status

# Used for `parallel` job groups 
NOW=$(date)
MYID=$(date +%Y%m%d%H%M%S)

# this allows us to get case names in one of three ways:
# 1: cq CASE1 CASE2 ...
# 2: cat cases.dat | cq -
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

if [ $NJOBS == 0 ] ; then
    >&2 echo Running single case at a time \(single mode\)
else
    >&2 echo Job submission with $NJOBS cases in parallel
fi

for CASE in $CASES; do
    >&2 echo Processing case $CASE

    STDOUT_FN="$LOGD/$CASE.out"
    STDERR_FN="$LOGD/$CASE.err"

    CMD=$(get_cromwell_cmd $CWL $CASE $CROMWELL_CONFIG $STDOUT_FN $STDERR_FN)
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


