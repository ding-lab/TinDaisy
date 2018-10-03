source /opt/lsf9/conf/lsf.conf

# set HOME and USER, which seems to be clobbered
#export HOME="/gscuser/mwyczalk"
#export USER="mwyczalk"


CONFIG="/gscuser/mwyczalk/projects/CWL/tin-daisy-cromwell/config.dat"
CWL="/gscuser/mwyczalk/projects/CWL/tin-daisy-cromwell/tin-daisy/cwl/tindaisy.cwl"
YAML="/gscuser/mwyczalk/projects/CWL/tin-daisy-cromwell/tin-daisy/testing/yaml/project_config.yaml"
/usr/bin/java -Dconfig.file=$CONFIG -jar /gscmnt/gc2764/cad/tmooney/cromwell/cromwell-34.jar run -t cwl -i $YAML $CWL

