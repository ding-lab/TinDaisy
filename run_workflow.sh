
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

source project_config.sh

CWL="cwl/tindaisy.cwl"

mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# TODO: test debug output

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
--vep_cache_gz $VEP_CACHE_GZ \
"  

#--bypass_merge_vcf  \
#--bypass_parse_pindel  \
#--bypass_vep_annotate  \

$RABIX $RABIX_ARGS $CWL -- $ARGS

