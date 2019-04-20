# Run Demo project 

source config/project_config.sh

# How to pass NOTE to runlog?  
NOTE="NA"

CROMWELL_QUERY="$TD_ROOT/src/cq"

bash $TD_ROOT/src/summarize_cromwell_runs.sh -c $CROMWELL_QUERY $@
bash $TD_ROOT/src/runLogger.sh -c $CROMWELL_QUERY -s $SUMMARY -m $NOTE $@

# Add dataCleaner.sh

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

