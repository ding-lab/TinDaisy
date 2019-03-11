# Generate YAML files

source project_config.sh

mkdir -p $YAMLD

# Usage: make_yaml.sh [options] CASE [ CASE2 ... ]
bash $SSV_ROOT/src/make_yaml.sh $@ -b $BAMMAP -r $REF -y $YAMLD -p $PRE_SUMMARY - < $CASES 
rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

