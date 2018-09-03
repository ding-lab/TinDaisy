cd ..
source project_config.sh
CWL="cwl/s7_parse_pindel.cwl"


# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUND="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/s5_run_pindel-2018-08-24-110121.753"

PINDEL_RAW="$OLD_RUND/root/results/pindel/pindel_out/pindel-raw.dat"

ARGS="\
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--pindel_config $PINDEL_CONFIG \
--pindel_raw $PINDEL_RAW \
--reference_fasta $REFERENCE_FASTA \
--dbsnp_db $DBSNP_DB \
--results_dir $RESULTS_DIR \
--no_delete_temp \
"

$RABIX $RABIX_ARGS $CWL -- $ARGS


