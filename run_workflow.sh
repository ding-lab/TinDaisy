
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

source project_config.sh

CWL="cwl/tindaisy.cwl"

mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

Missing:
    output_vcf, caller, output_vcf_1, caller_1, output_vcf_2, caller_2, output_vcf_3, caller_3, results_dir_2
-> can I make these have nicer names?

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
--strelka_vcf_filter_config $VCF_FILTER_CONFIG \
--tumor_bam $TUMOR_BAM \
--varscan_config $VARSCAN_CONFIG \
--varscan_vcf_filter_config $VCF_FILTER_CONFIG \
--vep_cache_version $VEP_CACHE_VERSION \
--classification_filter_config $CLASSIFICATION_FILTER_CONFIG \
--af_filter_config $AF_FILTER_CONFIG \
"  
#--vep_cache_gz $VEP_CACHE_GZ \

#--bypass_merge_vcf  \
#--bypass_parse_pindel  \
#--bypass_vep_annotate  \

$RABIX $RABIX_ARGS $CWL -- $ARGS

    --af_filter_config <arg>
    --assembly <arg>
    --assembly_1 <arg>
    --bypass
    --bypass_1
    --bypass_2
    --bypass_3
    --bypass_4
    --bypass_af
    --bypass_cvs
    --bypass_dbsnp
    --bypass_depth
    --bypass_depth_1
    --bypass_depth_2
    --bypass_depth_3
    --bypass_homopolymer
    --bypass_length
    --bypass_length_1
    --bypass_length_2
    --bypass_length_3
    --bypass_merge
    --bypass_vaf
    --bypass_vaf_1
    --bypass_vaf_2
    --bypass_vaf_3
    --caller <arg>
    --caller_1 <arg>
    --caller_2 <arg>
    --caller_3 <arg>
    --centromere_bed <arg>
    --classification_filter_config <arg>
    --dbsnp_db <arg>
    --debug
    --debug_1
    --debug_2
    --debug_3
    --debug_4
    --debug_5
    --debug_6
    --debug_7
    --no_delete_temp
    --no_delete_temp_1
    --normal_bam <arg>
    --output_vcf <arg>
    --output_vcf_1 <arg>
    --output_vcf_2 <arg>
    --output_vcf_3 <arg>
    --pindel_config <arg>
    --pindel_vcf_filter_config <arg>
    --reference_fasta <arg>
    --results_dir <arg>
    --results_dir_10 <arg>
    --results_dir_12 <arg>
    --results_dir_2 <arg>
    --results_dir_4 <arg>
    --results_dir_6 <arg>
    --results_dir_8 <arg>
    --strelka_config <arg>
    --strelka_vcf_filter_config <arg>
    --tumor_bam <arg>
    --varscan_config <arg>
    --varscan_vcf_filter_config <arg>
    --vep_cache_gz <arg>
    --vep_cache_version <arg>
    --vep_cache_version_1 <arg>
