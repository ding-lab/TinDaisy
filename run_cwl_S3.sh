source demo_paths.sh
CWL="json/s3_parse_strelka.cwl.json"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

$RABIX $RABIX_ARGS $CWL -- " \
--strelka_snv_raw /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/workflow-v1-1-2018-03-25-164136.121/root/s1_run_strelka/strelka/strelka_out/results/passed.somatic.snvs.vcf \
--dbsnp_db /Users/mwyczalk/Data/SomaticWrapper/image/B_Filter/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
