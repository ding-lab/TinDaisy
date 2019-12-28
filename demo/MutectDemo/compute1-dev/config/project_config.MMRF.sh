# TinDaisy Project Config file
#
# This file is common to all steps in project
# Contains all per-system configuration
# Contains only definitions, no execution code

# System: MGI

CROMWELL_JAR="/gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/cromwell.jar/44/cromwell-44.jar"

# Root directory.  Where TinDaisy is installed.  Using DNP branch
# TD_ROOT="/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/TinDaisy"
TD_ROOT="/gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/C3L-02219/TinDaisy.dnp"


# Workflow root - where Cromwell output goes.  This value replaces text WORKFLOW_ROOT in CONFIG_TEMPLATE,
# and is written to CONFIG_FILE
WORKFLOW_ROOT="/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/Results"
CONFIG_TEMPLATE="config/cromwell-config-db.template.dat"
CONFIG_FILE="dat/cromwell-config-db.dat"

# List of cases to analyze.  This has to be created
CASES_FN="dat/cases.dat"

# Path to BamMap, which is a file which defines sequence data path and other metadata
# BamMap format is defined here: https://github.com/ding-lab/importGDC/blob/master/make_bam_map.sh
BAMMAP="/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_20190425.BamMap"

# This path below is for multiple myeloma (MMRF) hs37d5 reference
REF_PATH="/gscmnt/gc2737/ding/Reference/hs37d5_plusRibo_plusOncoViruses_plusERCC.20170530.fa"

# See katmai:/home/mwyczalk_test/Projects/TinDaisy/sw1.3-compare/README.dbsnp.md for discussion of dbSnP references
# Updating to dbSnP-COSMIC version 20190416

# The version below does not have a .tbi file
#DBSNP_DB="/gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.song.GRCh37.vcf"
DBSNP_DB="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbsnp.noCOSMIC.vcf.gz"

# VEP Cache is used for VEP annotation and vcf_2_maf.
# If not defined, online lookups will be used by VEP annotation. These are slower and do not include allele frequency info (MAX_AF) needed by AF filter.
# For performance reasons, defining vep_cache_gz is suggested for production systems
VEP_CACHE_GZ="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/D_VEP/vep-cache.90_GRCh37.tar.gz"

# template used for generating YAML files
YAML_TEMPLATE="config/MMRF-template.yaml"

# These parameters used when finding data in BamMap
ES="WXS"                            # experimental strategy

# TUMOR_ST is normally "tumor", but will be "tissue_normal" for Normal Adjacent Normal Adjacent analyses
TUMOR_ST="tumor"                    # Sample type for tumor BAM, for BAMMAP matching
# TUMOR_ST="tissue_normal"            # Sample type for Normal Adjacent analyses
NORMAL_ST="normal"            # Sample type for normal BAM, for BAMMAP matching.  Default 'blood_normal'
REF_NAME="grch37"                     # Reference, used when matching to BAMMAP


