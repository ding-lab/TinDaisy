# Based on Hua testing:
#   /diskmnt/Projects/Users/hsun/beta_tinDaisy/tin-daisy/C3N-01649_paths.sh
# And docker run:
#  ./StrelkaDemo.docker.testing/start_docker.C3N-01649-test.sh 


TUMOR_BAM="/diskmnt/Projects/Users/hsun/beta_tinDaisy/data/C3N-01649.T.bam"
NORMAL_BAM="/diskmnt/Projects/Users/hsun/beta_tinDaisy/data/C3N-01649.N.bam"
REFERENCE_FASTA="/diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference/Homo_sapiens_assembly19.fasta"


STRELKA_CONFIG="../StrelkaDemo.dat/strelka.WES.ini"
VARSCAN_CONFIG="../StrelkaDemo.dat/varscan.WES.ini"
PINDEL_CONFIG="../StrelkaDemo.dat/pindel.WES.ini"

# VCF Filter args.  Strelka and varscan use same parameters, pindel has a different value of min_vaf_somatic 
PINDEL_VCF_FILTER_CONFIG="../StrelkaDemo.dat/pindel-vcf_filter_config.ini"
VARSCAN_VCF_FILTER_CONFIG="../StrelkaDemo.dat/vcf_filter_config.ini"
STRELKA_VCF_FILTER_CONFIG="../StrelkaDemo.dat/vcf_filter_config.ini"

#DBSNP_DB="/home/mwyczalk_test/data/docker/data/B_Filter/dbsnp.noCOSMIC.GRCh37.vcf.gz"
DBSNP_DB="/diskmnt/Projects/Users/hsun/data/dbsnp/00-All.brief.pass.cosmic.vcf.gz"
CENTROMERE_BED="../StrelkaDemo.dat/pindel-centromere-exclude.bed"

VEP_CACHE_DIR="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP"
VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_VERSION="90"
ASSEMBLY="GRCh37"

RESULTS_DIR="results"  #/diskmnt/Projects/TinDaisy/results

#RABIX="rabix"  # implies it is in path
RABIX="/home/mwyczalk_test/src/rabix-cli-1.0.5/rabix"

