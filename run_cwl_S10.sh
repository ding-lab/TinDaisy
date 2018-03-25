RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="annotate_vep.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"



$RABIX $RABIX_ARGS $CWL -- " \
--input_vcf /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/workflow-v1-1-2018-03-25-170259.572/root/s8_merge_vcf/merged/merged.vcf \
--reference_fasta /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.fa "


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
