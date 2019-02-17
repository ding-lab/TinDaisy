# Usage:
# bash 06_parse_pindel_CWL.sh OLD_RUND
# where OLD_RUND is e.g. .../run_varscan-2018-09-30-191554.323

cd ../..
source project_config.sh
CWL="cwl/parse_pindel.cwl"

OLD_RUND=$1

if [ -z $OLD_RUND ]; then
>&2 echo Error: Pass path to previous run output directory
exit 1
fi
if [ ! -d $OLD_RUND ]; then
>&2 echo Error: Previous output directory not found: $OLD_RUND
exit 1
fi

PINDEL_RAW="$OLD_RUND/root/results/pindel/pindel_out/pindel-raw.dat"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

$RABIX $RABIX_ARGS $CWL -- " \
--pindel_config $PINDEL_CONFIG \
--pindel_raw $PINDEL_RAW \
--reference_fasta $REFERENCE_FASTA \
--bypass_cvs \
--bypass_homopolymer \
"
#--no_delete_temp \
#--bypass \
