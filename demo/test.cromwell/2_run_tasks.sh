
# How rabix runs

# source project_config.sh
# # -J N - specify number of jobs to run at once
# bash $TD_ROOT/src/run_rabix_tasks.sh $@ -y $YAMLD -r $RABIXD -c $CWL - < $CASES_LIST


source /opt/lsf9/conf/lsf.conf
source project_config.sh


CONFIG="config.dat"
CWL="$TD_ROOT/cwl/workflows/tindaisy.cwl"

YAML="yaml/C3L-00104.yaml"

# Cromwell 35 in image  registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:5
CROMWELL="/opt/cromwell.jar"

CMD="/usr/bin/java -Dconfig.file=$CONFIG -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

