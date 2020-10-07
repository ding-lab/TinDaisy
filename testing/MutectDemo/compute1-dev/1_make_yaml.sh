# Generate cromwell config file

YAML_TEMPLATE="config/MutectDemo-template.yaml"
TD_ROOT="../../.."
YAML_FILE="dat/MutectDemo.yaml"

>&2 echo Writing YAML file to $YAML_FILE

mkdir -p $(dirname $YAML_FILE)
src/make_yaml.sh $YAML_TEMPLATE "$TD_ROOT" > $YAML_FILE
