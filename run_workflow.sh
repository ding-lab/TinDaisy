
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

source project_config.sh

CWL="cwl/TinDaisy.workflow.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

# Mandatory args
# --tumor_bam
# --normal_bam
# --reference_fasta
# --strelka_config
# --varscan_config
# --pindel_config
# --dbsnp_db
# --assembly


# optional args:
# --centromere_bed 
# --vep_cache_dir  
# --vep_output 
# --no_delete_temp
# --is_strelka2
# --results_dir 


# OUTPUT_DIR must not have leading "./".  Below we strip it.
# In general, best to just have OUTPUT_DIR be sample name, not a path per se
OUTPUT_DIR=${OUTPUT_DIR#./}

# Cache file: not defined, so using vep_db
$RABIX $RABIX_ARGS $CWL -- " \
--tumor_bam $TUMOR_BAM \
--normal_bam $NORMAL_BAM \
--reference_fasta $REFERENCE_FASTA \
--strelka_config $STRELKA_CONFIG \
--varscan_config $VARSCAN_CONFIG \
--pindel_config $PINDEL_CONFIG \
--dbsnp_db $DBSNP_DB \
--assembly $ASSEMBLY \
--centromere_bed $CENTROMERE_BED \
--results_dir $OUTPUT_DIR \
--no_delete_temp \
--is_strelka2 \
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--varscan_vcf_filter_config $VCF_FILTER_CONFIG \
--strelka_vcf_filter_config $VCF_FILTER_CONFIG \
"  
#--vep_cache_dir $VEP_CACHE_DIR "
#--vep_cache_gz $VEP_CACHE_GZ \
#--vep_cache_version 90 \
