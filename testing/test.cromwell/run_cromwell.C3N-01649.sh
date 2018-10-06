source /opt/lsf9/conf/lsf.conf

# set HOME and USER, which seems to be clobbered
#export HOME="/gscuser/mwyczalk"
#export USER="mwyczalk"


CONFIG="config.dat"
CWL="../../cwl/tindaisy.cwl"
YAML="../test.C3N-01649/project_config.C3N-01649.yaml"
/usr/bin/java -Dconfig.file=$CONFIG -jar /gscmnt/gc2764/cad/tmooney/cromwell/cromwell-34.jar run -t cwl -i $YAML $CWL

