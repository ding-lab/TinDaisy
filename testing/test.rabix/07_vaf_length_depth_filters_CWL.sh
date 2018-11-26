# TODO: note that this won't work because all runs will typically have different OLD_RUND path


# Usage:
# bash 07_vaf_length_depth_filters_CWL.sh OLD_RUND
# where OLD_RUND is e.g. .../run_varscan-2018-09-30-191554.323

cd ../..
source project_config.sh
CWL="cwl/vaf_length_depth_filters.cwl"

mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

OLD_RUND=$1

if [ -z $OLD_RUND ]; then
>&2 echo Error: Pass path to previous run output directory
exit 1
fi
if [ ! -d $OLD_RUND ]; then
>&2 echo Error: Previous output directory not found: $OLD_RUND
exit 1
fi

function run_vld_filter {
# Usage: run_vld_filter INPUT_VCF OUTPUT_VCF VCF_FILTER_CONFIG 

$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf $1 \
--output_vcf $2 \
--vcf_filter_config $3 \
"

}

INPUT_VCF="$OLD_RUND/root/results/strelka2/strelka_out/results/variants/somatic.snvs.vcf.gz"
run_vld_filter $INPUT_VCF strelka.snv.vcf $STRELKA_VCF_FILTER_CONFIG

INPUT_VCF="$OLD_RUND/root/results/varscan/varscan_out/varscan.out.som_snv.vcf"
run_vld_filter $INPUT_VCF varscan.snv.vcf $VARSCAN_VCF_FILTER_CONFIG

INPUT_VCF="$OLD_RUND/root/results/varscan/varscan_out/varscan.out.som_indel.vcf"
run_vld_filter $INPUT_VCF varscan.indel.vcf $VARSCAN_VCF_FILTER_CONFIG --debug

INPUT_VCF="$OLD_RUND/root/results/pindel/filter_out/pindel-raw.dat.CvgVafStrand_pass.Homopolymer_pass.vcf"
run_vld_filter $INPUT_VCF pindel.indel.vcf $PINDEL_VCF_FILTER_CONFIG --bypass

