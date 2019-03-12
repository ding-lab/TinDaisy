# Generate YAML files

# This is sourced both here and in make_yaml.sh to fill out template parameters
PARAMS="project_config.sh"
source $PARAMS

YAML_TEMPLATE="TinDaisy-template.yaml"

mkdir -p $YAMLD

# Usage: make_yaml.sh [options] CASE [ CASE2 ... ]
echo bash $TD_ROOT/src/make_yaml.sh $@ -b $BAMMAP -Y $YAML_TEMPLATE -P $PARAMS -y $YAMLD -p $PRE_SUMMARY - < $CASES 

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

