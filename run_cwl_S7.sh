source demo_paths.sh
CWL="s7_parse_pindel.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"



$RABIX $RABIX_ARGS $CWL -- " \
--pindel_raw /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/s5_run_pindel-2018-03-25-132220.700/root/pindel/pindel_out/pindel_raw.dat \
--reference_fasta /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.fa \
--pindel_config /Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params/pindel.WES.ini"


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
