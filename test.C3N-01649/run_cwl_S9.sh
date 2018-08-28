source project_config.C3N-01649-test.sh
CWL="../cwl/s9_vep_annotate.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUN="/diskmnt/Projects/Users/hsun/beta_tinDaisy/tin-daisy/results/TinDaisy.workflow-2018-08-14-210442.362"
INPUT_VCF="$OLD_RUN/root/s8_merge_vcf/results/merged/merged.filtered.vcf"

ARGS_DB="\
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
"

ARGS_GZ="\
$ARGS_DB \
--vep_cache_version 90 \
--assembly GRCh37 \
--vep_cache_gz $VEP_CACHE_GZ \
"

#echo $ARGS_DB
#echo $ARGS_GZ

# We rely on online VEP cache lookup for initial testing, so vep_cache_dir is not specified

$RABIX $RABIX_ARGS $CWL -- $ARGS_DB


