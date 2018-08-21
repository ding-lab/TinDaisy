source project_config.C3N-01649-test.sh
CWL="../cwl/s10_vcf_2_maf.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

# Hua's recent run
INPUT_VCF="/diskmnt/Projects/Users/hsun/beta_tinDaisy/tin-daisy/results/TinDaisy.workflow-2018-08-14-210442.362/root/s8_merge_vcf/results/merged/merged.filtered.vcf"

# Options for vep_2_vcf step 
#    --input_vcf s: VCF file to be annotated with vep_annotate.  Required
#    --reference_fasta s: path to reference.  Required
#    --results_dir s: Per-sample analysis results location. Often same as sample name [.]
#    --assembly s: either "GRCh37" or "GRCh38", used to identify cache file. Optional if not ambigous
#    --vep_cache_version s: Cache version, e.g. '90', used to identify cache file.  Optional if not ambiguous
#    --vep_cache_dir s: location of VEP cache directory
#        * if vep_cache_dir is not defined, error.
#        * If vep_cache_dir is a directory, it indicates location of VEP cache
#        * If vep_cache_dir is a file ending in .tar.gz, will extract its contents into "./vep-cache" and use VEP cache

$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--vep_cache_gz $VEP_CACHE_GZ \
--vep_cache_version $VEP_CACHE_VERSION \
--assembly $ASSEMBLY \
--results_dir results \
"
