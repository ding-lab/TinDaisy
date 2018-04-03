source demo_paths.sh
CWL="s10_annotate_vep.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"


INPUT_VCF="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/workflow-v1-1-2018-03-28-142620.317/root/s8_merge_vcf/merged/merged.vcf"

$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--assembly GRCh37 \
--output_vep 1 \
--use_vep_db 1 "


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
