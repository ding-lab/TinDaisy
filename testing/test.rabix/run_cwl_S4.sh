cd ..
source project_config.sh
CWL="cwl/s4_parse_varscan.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUND="/home/mwyczalk_test/Projects/Rabix/tin-daisy.StrelkaDemo/results/s2_run_varscan-2018-09-03-001829.600"

VARSCAN_SNV_RAW="$OLD_RUND/root/results/varscan/varscan_out/varscan.out.som_snv.vcf"
VARSCAN_INDEL_RAW="$OLD_RUND/root/results/varscan/varscan_out/varscan.out.som_indel.vcf"

ARGS="\
--varscan_snv_raw $VARSCAN_SNV_RAW \
--varscan_indel_raw $VARSCAN_INDEL_RAW \
--varscan_config $VARSCAN_CONFIG \
--dbsnp_db $DBSNP_DB \
--varscan_vcf_filter_config $VCF_FILTER_CONFIG \
--results_dir $RESULTS_DIR \
"

$RABIX $RABIX_ARGS $CWL -- $ARGS

# Output:
# * results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.filtered.vcf
# * results/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.filtered.vcf

