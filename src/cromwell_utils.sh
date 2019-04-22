# Various utilities common to cromwell runs
# No database calls here


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
        test_exit_status
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

# get case from WorkflowID based on parsing of logs/runlog.dat
# Only runs which have been registered will be findable
# If not found or runlog does not exit, return "Unknown"
function getRunLogCase {
    WID=$1
    RUNLOG="./logs/runlog.dat"
    if [ ! -f $RUNLOG ]; then
        echo "Unknown"
        return 
    fi

    # Search runlog from bottom, return column 1 of first matching line
    RLCASE=$( tac $RUNLOG | grep -m 1 -F "$WID" | cut -f 1 )
    test_exit_status
    if [ -z $RLCASE ]; then
        RLCASE="Unknown"
    fi
    echo "$RLCASE"
}

# get WorkflowID from Case based on parsing of logs/runlog.dat
# Only runs which have been registered will be findable
# If not found or runlog does not exit, return "Unknown"
function getRunLogWID {
    CASE=$1
    RUNLOG="./logs/runlog.dat"
    if [ ! -f $RUNLOG ]; then
        echo "Unknown"
        return 
    fi

    # Search runlog from bottom, return column 2 of first matching case
    # using awk to match just the case field
    RLWID=$( tac $RUNLOG | awk -v c=$CASE '{if ($1 == c) print $2}' )
    test_exit_status
    if [ -z $RLWID ]; then
        RLWID="Unknown"
    fi
    echo "$RLWID"
}

# obtain both Case and WorkflowID based on one of these values. RUNID passed can be either CASE or WorkflowID
#   If it is a WorkflowID, get case by evaluating runlog
#   If it is a case, get WorkflowID by
#   1. parsing log file named logs/CASE.out
#       Value "Unknown" or "Unassigned" is returned if log file does not exist or does not contain WorkflowID, resp.
#   2. or, if log file does not exist, by parsing logs/runlog.dat
function getCaseWID {
    RUNID=$1
    # Evaluate if RUNID is a WorkflowID.  
    # From https://stackoverflow.com/questions/38416602/check-if-string-is-uuid
    if [[ $RUNID =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        WID=$RUNID
        CASE=$( getRunLogCase $WID )
    else
        CASE=$RUNID
        LOG="logs/$CASE.out"
        if [ -f $LOG ]; then
            WID=$( getLogWID $LOG )
            test_exit_status
        else
            WID=$( getRunLogWID $CASE )
        fi
    fi
    echo "$CASE" "$WID"

#    # To read:
#    # https://stackoverflow.com/questions/2488715/idioms-for-returning-multiple-values-in-shell-scripting
#    read CASE WID < <( getCaseWID $CASE )
}
