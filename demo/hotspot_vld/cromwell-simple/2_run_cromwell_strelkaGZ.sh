# Be sure this is running within cromwell-compatible docker at MGI with,
# 0_start_docker-MGI_cromwell.sh

source /opt/lsf9/conf/lsf.conf

CONFIG="cromwell-config-db.dat"

#CWL="/gscuser/mwyczalk/projects/TinDaisy/TinDaisy/cwl/mutect-tool/cwl/mutect.cwl"
CWL="../../../cwl/workflows/hotspot_vld.cwl"
YAML="cwl-yaml/hotspot-vld-strelkaGZ.yaml"

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

# /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/hotspot_vld.cwl/cfc1ebd4-b1a1-4e67-995d-bcb90935e479/call-hotspotfilter/execution/output/HotspotFiltered.vcf
