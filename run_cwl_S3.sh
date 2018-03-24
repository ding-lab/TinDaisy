RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="s3_parse_strelka.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

$RABIX $RABIX_ARGS $CWL -- " \
--reference_fasta /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.fa \
--reference_dict /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.dict \
--strelka_snv_raw /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/s1_run_strelka-2018-03-23-131743.719/root/strelka/strelka_out/results/passed.somatic.snvs.vcf"

#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
