# Run given step of SomaticWrapper in docker environment
# Typically the run will start with ./start_docker.sh

DATAD="/data"
TUMOR_BAM=$DATAD/StrelkaDemoCase.T.bam
NORMAL_BAM=$DATAD/StrelkaDemoCase.N.bam
REFERENCE_FASTA=$DATAD/demo20.fa
STRELKA_CONFIG=$DATAD/strelka.WES.ini
VARSCAN_CONFIG=$DATAD/varscan.WES.ini
PINDEL_CONFIG=$DATAD/pindel.WES.ini
DBSNP_DB=$DATAD/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz
CENTROMERE_BED=$DATAD/ucsc-centromere.GRCh37.bed
#VEP_CACHE_DIR=/home/mwyczalk_test/data/docker/data/D_VEP

OUTDIR="./results"
mkdir -p $OUTDIR

SAMPLE="fastq2bam_test"

STEP="1"

ARGS="\
--tumor_bam $TUMOR_BAM \
--normal_bam $NORMAL_BAM \
--reference_fasta $REFERENCE_FASTA \
--strelka_config $STRELKA_CONFIG \
--varscan_config $VARSCAN_CONFIG \
--pindel_config $PINDEL_CONFIG \
--dbsnp_db $DBSNP_DB \
--output_vep 0 \
--assembly GRCh37 \
--centromere_bed $CENTROMERE_BED \
--is_strelka2 1 \
--results_dir $OUTDIR"

BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
perl $BIN $ARGS $STEP

