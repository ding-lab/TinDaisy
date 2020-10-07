# Generate cromwell config file

CONFIG_TEMPLATE="config/cromwell-config-db.template.dat"
WORKFLOW_ROOT="/data/Active/cromwell-data"
CONFIG_FILE="dat/cromwell-config-db.dat"

>&2 echo Writing Cromwell config file to $CONFIG_FILE

mkdir -p $(dirname $CONFIG_FILE)
src/make_config.sh $CONFIG_TEMPLATE $WORKFLOW_ROOT > $CONFIG_FILE
