cd ..
source project_config.sh
CWL="cwl/s9_vep_annotate.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUN="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/s8_merge_vcf-2018-09-03-173611.246"
INPUT_VCF="$OLD_RUN/root/results/merged/merged.filtered.vcf"

#epazote
VEP_CACHE_GZ="/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/image.setup/D_VEP/vep-cache.90_GRCh37.tar.gz"

# Specific to denali:
#VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
#VEP_CACHE_DIR="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP"

ARGS_DB="\
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
--af_filter_config $AF_FILTER_CONFIG \
--classification_filter_config $CLASSIFIATION_FILTER_CONFIG \
--bypass \
"

#    --af_filter_config <arg>
#    --assembly <arg>
#    --bypass
#    --classification_filter_config <arg>
#    --input_vcf <arg>
#    --reference_fasta <arg>
#    --results_dir <arg>
#    --vep_cache_gz <arg>
#    --vep_cache_version <arg>
#    --vep_output <arg>

ARGS_GZ="\
$ARGS_DB \
--vep_cache_version 90 \
--assembly GRCh37 \
--vep_cache_gz $VEP_CACHE_GZ \
"

#echo $ARGS_DB
#echo $ARGS_GZ

# We rely on online VEP cache lookup for initial testing, so vep_cache_dir is not specified

$RABIX $RABIX_ARGS $CWL -- $ARGS_GZ



#$RABIX $RABIX_ARGS $CWL -- $ARGS_GZ

