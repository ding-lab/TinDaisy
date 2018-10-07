source /opt/lsf9/conf/lsf.conf

# set HOME and USER, which seems to be clobbered
#export HOME="/gscuser/mwyczalk"
#export USER="mwyczalk"


CONFIG="config.dat"
#CWL="../../cwl/tindaisy.cwl"

# here we're restarting after merging, to test dbsnp filter and downstream
CWL="../../cwl/tindaisy-dbsnp_restart.cwl"
YAML="../test.C3N-01649/project_config.C3N-01649.yaml"

# Cromwell 35 in image  registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:5
CROMWELL="/opt/cromwell.jar"

/usr/bin/java -Dconfig.file=$CONFIG -jar $CROMWELL run -t cwl -i $YAML $CWL

