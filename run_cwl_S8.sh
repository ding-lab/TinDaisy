source demo_paths.sh
CWL="json/s8_merge_vcf.cwl.json"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

# Note that the paths below will be different for every single run and will need to be hand modified
STRELKA_SNV_VCF="/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s3_parse_strelka/strelka/filter_out/strelka.somatic.snv.all.gvip.dbsnp_pass.vcf"
VARSCAN_INDEL_VCF="/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s4_parse_varscan/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf"
VARSCAN_SNV_VCF="/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s4_parse_varscan/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf"
PINDEL_VCF="/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s7_parse_pindel/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf"


$RABIX $RABIX_ARGS $CWL -- " \
--reference_fasta $REFERENCE_FASTA \
--strelka_snv_vcf $STRELKA_SNV_VCF  \
--varscan_indel_vcf $VARSCAN_INDEL_VCF  \
--varscan_snv_vcf $VARSCAN_SNV_VCF  \
--pindel_vcf $PINDEL_VCF "


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
