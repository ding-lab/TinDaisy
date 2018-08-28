
source project_config.C3N-01649-test.sh

CWL="../cwl/TinDaisy.workflow.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Mandatory args
# --tumor_bam
# --normal_bam
# --reference_fasta
# --dbsnp_db
# --strelka_config
# --varscan_config
# --pindel_config
# --strelka_vcf_filter_config
# --varscan_vcf_filter_config
# --pindel_vcf_filter_config


# optional args:
# --centromere_bed
# --vep_cache_dir
# --vep_output
# --no_delete_temp
# --is_strelka2
# --results_dir
# --assembly
# --vep_cache_version

ARGS=" \
--assembly $ASSEMBLY \
--centromere_bed $CENTROMERE_BED \
--dbsnp_db $DBSNP_DB \
--no_delete_temp \
--normal_bam $NORMAL_BAM \
--pindel_config $PINDEL_CONFIG \
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
--strelka_config $STRELKA_CONFIG \
--strelka_vcf_filter_config $STRELKA_VCF_FILTER_CONFIG \
--tumor_bam $TUMOR_BAM \
--varscan_config $VARSCAN_CONFIG \
--varscan_vcf_filter_config $VARSCAN_VCF_FILTER_CONFIG \
--vep_cache_gz $VEP_CACHE_GZ \
--vep_cache_version 90 \
"  

$RABIX $RABIX_ARGS $CWL -- $ARGS

