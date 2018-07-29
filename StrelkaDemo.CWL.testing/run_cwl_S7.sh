cd ..
source project_config.C3N-01649-test.sh
CWL="cwl/s7_parse_pindel.cwl"

# try to have all output go to output_dir
mkdir -p $OUTPUT_DIR
RABIX_ARGS="--basedir $OUTPUT_DIR"

# This is obtained from previous step5 run
#PINDEL_RAW="/Projects/Rabix/SomaticWrapper.CWL1/results/s5_run_pindel-2018-03-25-132220.700/root/pindel/pindel_out/pindel_raw.dat" 
DATAD="/diskmnt/Projects/Users/hsun/beta_tinDaisy/compare/mgi_sw_C3N-01649"
PINDEL_RAW="$DATAD/pindel/pindel.out.raw"



$RABIX $RABIX_ARGS $CWL -- " \
--pindel_raw $PINDEL_RAW \
--reference_fasta $REFERENCE_FASTA \
--no_delete_temp \
--pindel_config $PINDEL_CONFIG \
--dbsnp_db $DBSNP_DB \
"

#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \
