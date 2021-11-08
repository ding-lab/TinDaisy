# Be sure this is running within cromwell-compatible docker at MGI with,
# 0_start_docker-MGI_cromwell.sh

source /opt/lsf9/conf/lsf.conf

CONFIG="cromwell-config-db.dat"

CWL="../../../../cwl/workflows/tindaisy2-restart_postcall.cwl"
YAML="cwl-yaml/tindaisy2-restart_postcall-C3L-00908.yaml"


CROMWELL="/usr/local/cromwell/cromwell-47.jar"

# from https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase
# Connecting to the database section
# Note also database section in config fil
DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
CMD="/usr/bin/java -Dconfig.file=$CONFIG $DB_ARGS -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

