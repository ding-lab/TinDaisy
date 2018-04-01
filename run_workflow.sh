
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

source demo_paths.sh

CWL="workflow-v1-1.cwl"

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
# --output_vep 

# Cache file: not defined, so using vep_db
$RABIX $RABIX_ARGS $CWL -- " \
--tumor_bam $TUMOR_BAM \
--normal_bam $NORMAL_BAM \
--reference_fasta $REFERENCE_FASTA \
--strelka_config $STRELKA_CONFIG \
--varscan_config $VARSCAN_CONFIG \
--pindel_config $PINDEL_CONFIG \
--dbsnp_db $DBSNP_DB \
--output_vep 1 \
--assembly GRCh37 \
--centromere_bed $CENTROMERE_BED"
