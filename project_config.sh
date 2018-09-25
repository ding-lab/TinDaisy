TUMOR_BAM="StrelkaDemo.dat/StrelkaDemoCase.T.bam"
NORMAL_BAM="StrelkaDemo.dat/StrelkaDemoCase.N.bam"
REFERENCE_FASTA="StrelkaDemo.dat/demo20.fa" 
STRELKA_CONFIG="params/strelka.WES.ini"
VARSCAN_CONFIG="params/varscan.WES.ini"
PINDEL_CONFIG="params/pindel.WES.ini"
DBSNP_DB="StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"
CENTROMERE_BED="StrelkaDemo.dat/ucsc-centromere.GRCh37.bed"
VEP_CACHE_DIR="/home/mwyczalk_test/data/docker/data/D_VEP"
VEP_CACHE_GZ="/Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/image.setup/D_VEP/vep-cache.90_GRCh37.tar.gz"
#VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_VERSION="90"
ASSEMBLY="GRCh37"

STRELKA_VCF_FILTER_CONFIG="params/vcf_filter_config-strelka.ini"
VARSCAN_VCF_FILTER_CONFIG="params/vcf_filter_config-varscan.ini"
PINDEL_VCF_FILTER_CONFIG="params/vcf_filter_config-pindel.ini"
AF_FILTER_CONFIG="params/af_filter_config.ini"
CLASSIFICATION_FILTER_CONFIG="params/classification_filter_config.ini"

# RESULTS_DIR must not have leading "./"
# In general, best to just have RESULTS_DIR be sample name, not a path per se
RESULTS_DIR=results
# RESULTS_DIR=${RESULTS_DIR#./}  # strip leading ./ if necessary


#RABIX="/home/mwyczalk_test/src/rabix-cli-1.0.5/rabix"
#export RABIX=/home/mwyczalk_test/src/rabix-cli-1.0.5/rabix
RABIX="rabix"

