# Demonstration of running StrelkaDemo workflow using Rabix Executor and YAML configuration
#
# This demonstration is appropriate for production runs.
# Uses VEP cache and deletes intermediate files

# The TinDaisy installation directory
TD_BASE="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy"

CWL="cwl/workflows/tindaisy.cwl"

cd $TD_BASE
YAML="demo/katmai.C3L/C3N-00560/C3N-00560.katmai.yaml"

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

rabix $RABIX_ARGS $CWL $YAML

