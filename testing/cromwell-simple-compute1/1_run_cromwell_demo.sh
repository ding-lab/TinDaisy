# Be sure this is running within cromwell-compatible docker on compute1 with,
# 0_start_docker-compute1_cromwell.sh

source /opt/ibm/lsfsuite/lsf/conf/lsf.conf

PWD=$(pwd)
CWL_ROOT_H=$PWD/../..
CWL="$CWL_ROOT_H/cwl/workflows/tindaisy2.6.2.cwl"

CONFIG="dat/cromwell-config-db.dat"
YAML="dat/C3L-03733.yaml"        ### This must be updated

# Cromwell v78 
JAVA="/opt/java/openjdk/bin/java"
CROMWELL="/app/cromwell-78-38cd360.jar"

# from https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase
# Connecting to the database section
# Note also database section in config file
CMD="$JAVA -Dconfig.file=$CONFIG -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

