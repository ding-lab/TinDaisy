# Create YAML file
# Usage:
#   bash make_yaml.sh TEMPLATE TD_ROOT

# Usage is same as make_config.sh


if [ "$#" -ne 2 ]; then
    >&2 echo Error: Wrong number of arguments
    exit 1
fi

TEMPLATE=$1
TD_ROOT=$2

if [ ! -f $TEMPLATE ]; then
    >&2 echo ERROR: $TEMPLATE does not exist
    exit 1
fi

if [ ! -d $TD_ROOT ]; then
    >&2 echo ERROR: Directory $TD_ROOT does not exist.  Please create it
    exit 1
fi

# This is printed to STDOUT
sed "s|TD_ROOT|$TD_ROOT|g" $TEMPLATE 
