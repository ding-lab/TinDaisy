
# How rabix runs

# source project_config.sh
# # -J N - specify number of jobs to run at once
# bash $TD_ROOT/src/run_rabix_tasks.sh $@ -y $YAMLD -r $RABIXD -c $CWL - < $CASES_LIST


source /opt/lsf9/conf/lsf.conf
source project_config.sh

CONFIG="cromwell-config-db.dat"
CWL="$TD_ROOT/cwl/workflows/tindaisy.cwl"

YAML="yaml/C3L-00104.yaml"

CROMWELL="/opt/cromwell.jar"

# from https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase
# Connecting to the database section
# Note also database section in config fil
DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
CMD="/usr/bin/java -Dconfig.file=$CONFIG $DB_ARGS -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

#### new ####
# Run Demo project 

source project_config.sh

# -J N - specify number of jobs to run at once
bash $TD_ROOT/src/run_rabix_tasks.sh $@ -y $YAMLD -r $RABIXD -c $CWL - < $CASES_LIST

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi


