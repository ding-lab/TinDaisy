# Demonstration of running MutectDemo workflow using Rabix Executor and YAML configuration
#
# Note that for this demonstration is optimized for quick execution and minimal preparation.
# Production runs should be based on example in test.C3N-01649, which 
# uses VEP cache and deletes intermediate files

cd ..
CWL="cwl/tindaisy.cwl"
#YAML="project_config.yaml"

# Location TinDaisy installed
TD_BASE="/Users/mwyczalk/Projects/Rabix/TinDaisy"
YAML="$TD_BASE/demo/MutectDemo/project_config.MutectDemo.yaml"

mkdir -p results
RABIX_ARGS="--basedir results"

rabix $RABIX_ARGS $CWL $YAML

