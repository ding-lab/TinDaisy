
source project_config.sh

CWL="cwl/tindaisy.cwl"

mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Valid inputs are:
#     --af_filter_config <arg>
#     --assembly <arg>
#     --bypass_af
#     --bypass_classification
#     --bypass_cvs
#     --bypass_dbsnp
#     --bypass_depth
#     --bypass_homopolymer
#     --bypass_length
#     --bypass_merge
#     --bypass_vaf
#     --centromere_bed <arg>
#     --classification_filter_config <arg>
#     --dbsnp_db <arg>
#     --debug
#     --no_delete_temp
#     --normal_bam <arg>
#     --pindel_config <arg>
#     --pindel_vcf_filter_config <arg>
#     --reference_fasta <arg>
#     --strelka_config <arg>
#     --strelka_vcf_filter_config <arg>
#     --tumor_bam <arg>
#     --varscan_config <arg>
#     --varscan_vcf_filter_config <arg>
#     --vep_cache_gz <arg>
#     --vep_cache_version <arg>
 
 
ARGS=" \
--assembly $ASSEMBLY \
--centromere_bed $CENTROMERE_BED \
--dbsnp_db $DBSNP_DB \
--no_delete_temp \
--normal_bam $NORMAL_BAM \
--pindel_config $PINDEL_CONFIG \
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--reference_fasta $REFERENCE_FASTA \
--strelka_config $STRELKA_CONFIG \
--strelka_vcf_filter_config $STRELKA_VCF_FILTER_CONFIG \
--tumor_bam $TUMOR_BAM \
--varscan_config $VARSCAN_CONFIG \
--varscan_vcf_filter_config $VARSCAN_VCF_FILTER_CONFIG \
--vep_cache_version $VEP_CACHE_VERSION \
--classification_filter_config $CLASSIFICATION_FILTER_CONFIG \
--af_filter_config $AF_FILTER_CONFIG \
"  
# --vep_cache_gz $VEP_CACHE_GZ \

$RABIX $RABIX_ARGS $CWL -- $ARGS

