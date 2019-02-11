# Usage:
# bash 05_parse_varscan_indel_CWL.sh OLD_RUND
# where OLD_RUND is e.g. .../run_varscan-2018-09-30-191554.323

cd ../..
source project_config.sh
CWL="cwl/parse_varscan_indel.cwl"

OLD_RUND=$1

if [ -z $OLD_RUND ]; then
>&2 echo Error: Pass path to previous run output directory
exit 1
fi
if [ ! -d $OLD_RUND ]; then
>&2 echo Error: Previous output directory not found: $OLD_RUND
exit 1
fi

VARSCAN_INDEL_RAW="$OLD_RUND/root/results/varscan/varscan_out/varscan.out.som_indel.vcf"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

$RABIX $RABIX_ARGS $CWL -- " \
--varscan_indel_raw $VARSCAN_INDEL_RAW \
--varscan_config $VARSCAN_CONFIG \
"
