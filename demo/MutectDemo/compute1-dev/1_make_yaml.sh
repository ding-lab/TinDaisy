# Generate YAML config files

# Usage:
# 1_make_yaml.sh -P PARAMS

# All arguments are passed as is to src/runplan

# Note that running `runplan` with no arguments will give back useful information about anticipated runs
# perhaps add this as default?

#RESTART_MAP="dat/MMRF-20190925.map.dat"

>&2 echo Writing YAML files
CMD="src/runplan -x yaml "$@" "

>&2 echo Running: $CMD
eval $CMD

