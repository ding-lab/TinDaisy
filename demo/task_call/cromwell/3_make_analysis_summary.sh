# Run Demo project 

source config/project_config.sh

CROMWELL_QUERY="$TD_ROOT/src/cromwell_query.sh"

bash $TD_ROOT/src/make_analysis_summary.sh $@ -c $CROMWELL_QUERY -C -p $PRE_SUMMARY -s $SUMMARY - < $CASES_LIST

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

