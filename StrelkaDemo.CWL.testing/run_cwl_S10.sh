cd ..
source project_config.sh
CWL="cwl/s10_annotate_vep.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

FAKE_VEP_CACHE="results/test-workflow.tar.gz"

INPUT_VCF="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/workflow-v1-1-2018-04-03-122218.518/root/s8_merge_vcf/merged/merged.vcf"

$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--assembly GRCh37 \
--output_vep 1 "
#--vep_cache_gz $FAKE_VEP_CACHE"

