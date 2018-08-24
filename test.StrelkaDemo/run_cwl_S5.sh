
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

cd ..
source project_config.sh
CWL="cwl/s5_run_pindel.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

$RABIX $RABIX_ARGS $CWL -- " \
--tumor_bam $TUMOR_BAM \
--normal_bam $NORMAL_BAM \
--reference_fasta $REFERENCE_FASTA \
--pindel_config $PINDEL_CONFIG \
--centromere_bed $CENTROMERE_BED \
--results_dir $RESULTS_DIR \
"  # optional 
