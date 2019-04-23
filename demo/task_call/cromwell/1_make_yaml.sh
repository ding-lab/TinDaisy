# Generate YAML files

# Note that running `runplan` will give back useful information about anticipated runs

# This is sourced both here and in make_yaml.sh to fill out template parameters
PARAMS="config/project_config.sh"
source $PARAMS  # we just care about TD_ROOT

$TD_ROOT/src/runplan -x yaml "$@" 

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

