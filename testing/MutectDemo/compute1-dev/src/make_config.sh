# Create cromwell configuration file
# Usage:
#   bash make_config.sh TEMPLATE WORKFLOW_ROOT

# TEMPLATE is cromwell configuration file template
# The text "WORKFLOW_ROOT" is replaced in the template file by the value of the passed argument
# Note that directory WORKFLOW_ROOT must exist

# location to write error output logs from individual tools:
#   WORKFLOW_ROOT/logs/cromwell-%J.err
# location for Cromwell's main working directory (temp, intermediate, and final files will all be stored here)
#   WORKFLOW_ROOT/cromwell-executions
# location to write Cromwell's workflow logs
#   WORKFLOW_ROOT/cromwell-workflow-logs

# Note that having WORKFLOW_ROOT on same filesystem as BAMs allows for hard links and is much faster.  


if [ "$#" -ne 2 ]; then
    >&2 echo Error: Wrong number of arguments
    exit 1
fi

TEMPLATE=$1
WORKFLOW_ROOT=$2

if [ ! -f $TEMPLATE ]; then
    >&2 echo ERROR: $TEMPLATE does not exist
    exit 1
fi

if [ ! -d $WORKFLOW_ROOT ]; then
    >&2 echo ERROR: Directory $WORKFLOW_ROOT does not exist.  Please create it
    exit 1
fi

# This is printed to STDOUT
sed "s|WORKFLOW_ROOT|$WORKFLOW_ROOT|g" $TEMPLATE 
