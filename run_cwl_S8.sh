RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="s8_merge_vcf.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"



$RABIX $RABIX_ARGS $CWL -- " \
--reference_fasta /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.fa \
--strelka_snv_vcf /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s3_parse_strelka/strelka/filter_out/strelka.somatic.snv.all.gvip.dbsnp_pass.vcf \
--varscan_indel_vcf /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s4_parse_varscan/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf \
--varscan_snv_vcf /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s4_parse_varscan/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf \
--pindel_vcf /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/somaticwrapper-workflow-2018-03-25-134014.776/root/s7_parse_pindel/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf \
"


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
