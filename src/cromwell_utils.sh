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

    if [ "$DRYRUN" == "d" ]; then
        >&2 echo Dryrun: $CMD
    else
        >&2 echo Running: $CMD
        eval $CMD
        test_exit_status
    fi
}

# Get Workflow ID by parsing log file for specific entry
# If WorkflowID not found, return value "Unassigned".  Such values should not be queried
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

# obtain WorkflowID based on parsing log file named logs/CASE.out
# TODO: Add functionality here to parse runlogs
# Return value "Unknown" or "Unassigned" if log file does not exist or does not contain WorkflowID, resp.
function getWID {
    CASE=$1
    # Evaluate if CASE is actually a WID.  If so, assume it is the WID and proceed
    # From https://stackoverflow.com/questions/38416602/check-if-string-is-uuid
    if [[ $CASE =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        WID=$CASE
        CASE="Unknown"  # try harder to get CASE when WID specified
    else
        LOG="logs/$CASE.out"
        if [ -f $LOG ]; then
            WID=$( getLogWID $LOG )
            test_exit_status
        else
            WID="Unknown"
        fi
    fi
    echo $WID
}
