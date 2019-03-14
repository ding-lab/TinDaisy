# Run Demo project 

source project_config.sh

bash $TD_ROOT/src/make_analysis_summary.sh $@ -p $PRE_SUMMARY -s $SUMMARY - < $CASES_LIST

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

