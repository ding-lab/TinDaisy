# Demonstration of running StrelkaDemo workflow using Rabix Executor and YAML configuration
#
# Note that for this demonstration is optimized for quick execution and minimal preparation.
# Production runs should be based on example in test.C3N-01649, which 
# uses VEP cache and deletes intermediate files

cd ../..

CWL="cwl/workflows/tindaisy.cwl"
#YAML="project_config.yaml"
YAML="demo/StrelkaDemo/project_config.StrelkaDemo.yaml"

mkdir -p results
RABIX_ARGS="--basedir results"

echo rabix $RABIX_ARGS $CWL $YAML

