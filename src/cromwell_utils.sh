# Various utilities common to cromwell runs
# No database calls here
# TODO: explain file formats and logic of how WorkflowID is looked up
# TODO: RUNLOG should not be hard coded, allow to be specified either with argument or environment / global variable

# obtain both Case and WorkflowID based on one of these values. RUNID passed can be either CASE or WorkflowID
# A) if RUNID is a WorkflowID, get Case by evaluating RUNLOG (e.g., logs/runlog.dat)
# B) If RUNID Is a Case, get Workflow ID as follows
#   1) If logs/CASE.out exists, parse it to get WorkflowID
#      * if logs/CASE.out does not contain WorkflowID, WorkflowID is "Unassigned"
#   2) if logs/CASE.out does not exist, obtain WorkflowID from RUNLOG
#       * if RUNLOG does not exist, error


function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    SCRIPT=$1
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

# Evaluate given command CMD either as dry run or for real
function run_cmd {
    CMD=$1
    DRYRUN=$2
    QUIET=$3

    if [ -z $QUIET ]; then
        QUIET=0
    fi

    if [ "$DRYRUN" == "d" ]; then
        if [ "$QUIET" == 0 ]; then
            >&2 echo Dryrun: $CMD
        fi
    else
        if [ "$QUIET" == 0 ]; then
            >&2 echo Running: $CMD
        fi
        eval $CMD
        test_exit_status 
    fi
}

# Get Workflow ID by parsing log file (logs/CASE.dat) for specific entry
# If WorkflowID not found, return value "Unassigned"
function getLogWID {
    LOG=$1
    SSTR="SingleWorkflowRunnerActor: Workflow submitted"  # this is what we're looking for
    if grep -Fq "$SSTR" $LOG ; then   # String found
        W=$(grep "$SSTR" $LOG | sed 's/\x1b\[[0-9;]*m//g' | sed -n -e 's/^.*submitted //p')
        test_exit_status "getLogWID"
    else    # LOG does not have Workflow ID - may happen in early processing or in error states
        W="Unassigned"
    fi
    echo $W
}

# Recall, runlog file has the following columns
#    * `CASE`
#    * `WorkflowID`
#    * `Status`
#    * `StartTime`
#    * `EndTime`
#    * `Note` 

# get case from WorkflowID based on parsing of RUNLOG
# Only runs which have been registered will be findable
# If not found or runlog does not exit, return "Unknown"
function getRunLogCase {
    WID=$1
    RUNLOG=$2
    # We require RUNLOG to exist.  It should be created elsewhere for new runs
    if [ ! -f $RUNLOG ]; then
        >&2 echo "getRunLogCase ERROR: Runlog file $RUNLOG does not exist"
        exit 1
    fi

    # Search runlog from bottom, return column 1 of first matching line
    RLCASE=$( tac $RUNLOG | grep -m 1 -F "$WID" | cut -f 1 )
    test_exit_status "getRunLogCase"
    if [ -z $RLCASE ]; then
        RLCASE="Unknown"
    fi
    echo "$RLCASE"
}

# get WorkflowID from Case based on parsing of RUNLOG
# Only runs which have been registered will be findable
# If not found or runlog does not exit, return "Unknown"
function getRunLogWID {
    CASE=$1
    RUNLOG=$2
    # We require RUNLOG to exist.  It should be created elsewhere for new runs
    if [ ! -f $RUNLOG ]; then
        >&2 echo "getRunLogWID ERROR: Runlog file $RUNLOG does not exist"
        exit 1
    fi

    # Search runlog from bottom, return column 2 of first matching case
    # using awk to match just the case field
    RLWID=$( tac $RUNLOG | awk -v c=$CASE '{if ($1 == c) print $2}' )
    test_exit_status "getRunLogWID"
    if [ -z "$RLWID" ]; then
        RLWID="Unknown"
    fi
    echo "$RLWID"
}

# Usage: isStashed CASE RUNLOG
# Return 1 if logs/CASE.out does not exist and there is a logs/WorkflowID directory
# Return 0 otherwise
# CASE may also be a WorkflowID
function isStashed {
    RID=$1
    RUNLOG=$2   
    if [ -z $RUNLOG ]; then 
        >&2 echo isStashed ERROR: RUNLOG must be passed
        exit 1
    fi
    
    LOG="logs/$RID.out"
    if [ -e $LOG ]; then
        echo 0
        return
    fi
    read MYCASE MYWID < <( getCaseWID $RID $RUNLOG )
    if [ -d "logs/$MYWID" ]; then
        echo 1
        return 
    fi
    echo 0
}

# obtain both Case and WorkflowID given on one of these. RUNID passed can be either CASE or WorkflowID
# A) if RUNID is a WorkflowID, get Case by evaluating RUNLOG (e.g., logs/runlog.dat)
# B) If RUNID is a Case, get Workflow ID as follows
#   1) If logs/CASE.out exists, parse it to get WorkflowID
#      * if logs/CASE.out does not contain WorkflowID, WorkflowID is "Unassigned"
#   2) if logs/CASE.out does not exist, obtain WorkflowID from RUNLOG
#       * if RUNLOG does not exist, that is an error
# Both values Case and WorkflowID are returned.  Usage:
#    read MYCASE MYWID < <( getCaseWID $CASE $RUNLOG )
# 
function getCaseWID {
    RUNID=$1
    RUNLOG=$2   
    if [ -z $RUNLOG ]; then 
        >&2 echo getCaseWID ERROR: RUNLOG must be passed
        exit 1
    fi

    # Evaluate if RUNID is a WorkflowID.  
    # From https://stackoverflow.com/questions/38416602/check-if-string-is-uuid
    if [[ $RUNID =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        WID=$RUNID
        CASE=$( getRunLogCase $WID $RUNLOG )
    else
        CASE=$RUNID
        LOG="logs/$CASE.out"
        if [ -f $LOG ]; then
            WID=$( getLogWID $LOG )
            test_exit_status "getCaseWID"
        else
            WID=$( getRunLogWID $CASE $RUNLOG )
        fi
    fi

#   https://stackoverflow.com/questions/2488715/idioms-for-returning-multiple-values-in-shell-scripting
    echo "$CASE" "$WID"
}
