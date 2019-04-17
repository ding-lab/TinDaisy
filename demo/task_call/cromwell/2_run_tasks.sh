source /opt/lsf9/conf/lsf.conf
source config/project_config.sh

CONFIG="config/cromwell-config-db.dat"
CWL="$TD_ROOT/cwl/workflows/tindaisy.cwl"

# -J N - specify number of jobs to run at once
ARGS="-J 4"
bash $TD_ROOT/src/run_cwl_tasks.sh $@ $ARGS -y $YAMLD -c $CWL -C $CONFIG - < $CASES_LIST

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi


