cd ..
source project_config.sh
CWL="cwl/s9_vep_annotate.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUN="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/s8_merge_vcf-2018-08-22-123300.128"
INPUT_VCF="$OLD_RUN/root/results/merged/merged.filtered.vcf"

ARGS="\
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
"

# We rely on online VEP cache lookup for initial testing, so vep_cache_dir is not specified

$RABIX $RABIX_ARGS $CWL -- $ARGS


