# Demonstration of running MutectDemo workflow using Rabix Executor and YAML configuration
#
# Note that for this demonstration is optimized for quick execution and minimal preparation.
# Production runs should be based on example in C3L-01032, which 
# uses VEP cache and deletes intermediate files

# Be sure reference is uncompressed with 
# tar -xvjf Homo_sapiens_assembly19.COST16011_region.fa.tar.bz2
# in TinDaisy/demo/demo_data/MutectDemo-data

cd ../..
CWL="cwl/workflows/tindaisy.cwl"
#YAML="project_config.yaml"

# Location TinDaisy installed
#TD_BASE="/Users/mwyczalk/Projects/Rabix/TinDaisy"
TD_BASE="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy"
YAML="$TD_BASE/demo/MutectDemo/project_config.MutectDemo.yaml"

mkdir -p results
RABIX_ARGS="--basedir results"

rabix $RABIX_ARGS $CWL $YAML

