source demo_paths.sh
CWL="cwl/s10_annotate_vep.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

VEP_CACHE="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"

INPUT_VCF="/diskmnt/Projects/TinDaisy/results/workflow-v1-1-2018-04-04-234352.162/root/s8_merge_vcf/merged/merged.vcf"

echo NOTE: v90 hard coded

$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--assembly GRCh37 \
--output_vep 0 \
--vep_cache_gz $VEP_CACHE \
--vep_cache_version 90"

