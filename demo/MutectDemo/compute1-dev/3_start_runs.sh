# This file below is for MGI
# source /opt/lsf9/conf/lsf.conf

# below is for compute1
source /opt/ibm/lsfsuite/lsf/conf/lsf.conf

# /usr/bin/java -Xmx10g -Dconfig.file=dat/cromwell-config-db.dat -Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore -jar /usr/local/cromwell/cromwell-47.jar run -t cwl -i ./yaml/MutectDemo.yaml /home/m.wyczalkowski/Projects/TinDaisy/TinDaisy/cwl/workflows/tindaisy.cwl

ARGS="-Xmx10g"
YAML="./dat/MutectDemo.yaml"
DB_ARGS="-Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore"
#CROMWELL_JAR="/opt/cromwell.jar"
CROMWELL_JAR="/usr/local/cromwell/cromwell-47.jar"
CWL="/home/m.wyczalkowski/Projects/TinDaisy/TinDaisy/cwl/workflows/tindaisy.cwl"
CONFIG="-Dconfig.file=dat/cromwell-config-db.dat"

/usr/bin/java $ARGS $CONFIG $DB_ARGS -jar $CROMWELL_JAR run -t cwl -i $YAML $CWL

# Could not localize /home/m.wyczalkowski/Projects/TinDaisy/TinDaisy/demo/demo/MutectDemo/demo-data/G15512.HCC1954.1.COST16011_region.bam -> /data/Active/cromwell-data/cromwell-wor
