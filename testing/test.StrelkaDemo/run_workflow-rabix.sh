cd ../..
CWL="cwl/tindaisy.cwl"
#YAML="project_config.yaml"
YAML="/Users/mwyczalk/Projects/Rabix/TinDaisy/testing/test.StrelkaDemo/project_config.yaml"

mkdir -p results
RABIX_ARGS="--basedir results"

rabix $RABIX_ARGS $CWL $YAML

