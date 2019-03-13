# Run Demo project 

source project_config.sh

bash $SSV_ROOT/src/run_rabix_tasks.sh $@ -y $YAMLD -r $RABIXD -c $CWL - < $CASES

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

