cd ../..
#CWL="cwl/tindaisy.cwl"
CWL="cwl/tindaisy-dbsnp_restart.cwl"
#YAML="project_config.yaml"
YAML="testing/test.StrelkaDemo/project_config.yaml"

#cwltool $CWL $YAML

# for validating CWL
cwltool --validate $CWL

