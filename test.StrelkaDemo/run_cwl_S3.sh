cd ..
source project_config.sh
CWL="cwl/s3_parse_strelka.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUND="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/s1_run_strelka-2018-08-24-110004.139"
# This is dependent on whether Strelka1 or Strelka2 is used
STRELKA_SNV_RAW="$OLD_RUND/root/results/strelka/strelka_out/results/variants/somatic.snvs.vcf.gz"


ARGS="\
--strelka_snv_raw $STRELKA_SNV_RAW \
--strelka_config $STRELKA_CONFIG \
--strelka_vcf_filter_config $VCF_FILTER_CONFIG \
--dbsnp_db $DBSNP_DB \
--results_dir $RESULTS_DIR \
"

$RABIX $RABIX_ARGS $CWL -- $ARGS
