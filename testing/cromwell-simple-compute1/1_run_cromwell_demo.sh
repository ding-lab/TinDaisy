# Be sure this is running within cromwell-compatible docker on compute1 with,
# 0_start_docker-compute1_cromwell.sh

source /opt/ibm/lsfsuite/lsf/conf/lsf.conf

CWL="../../cwl/workflows/tindaisy2.6.1.cwl"

CONFIG="dat/cromwell-config-db.compute1-filedb.dat"
YAML="dat/C3N-02996.BIOTEXT_YEyWzRW.yaml"

CROMWELL="/usr/local/cromwell/cromwell-47.jar"

# from https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase
# Connecting to the database section
# Note also database section in config file
#DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
CMD="/usr/bin/java -Dconfig.file=$CONFIG $DB_ARGS -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

