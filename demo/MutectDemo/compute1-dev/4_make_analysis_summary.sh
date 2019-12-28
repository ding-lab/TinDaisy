# Generate YAML files

# Note that running `runplan` will give back useful information about anticipated runs

# This is sourced both here and in make_yaml.sh to fill out template parameters
PARAMS="config/project_config.MMRF-restart.sh"
source $PARAMS  

CWLS=$(basename $CWL)
$TD_ROOT/src/runplan -x summary -P $PARAMS -W $CWLS "$@" 

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

