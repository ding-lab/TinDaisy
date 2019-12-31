# TinDaisy Project Config file
#
# This file is common to all steps in project
# Contains all per-system configuration
# Contains only definitions, no execution code

# System: MGI

# Restarting from merge step

PROJECT="LSCC.20191104"

# Root directory.  Where TinDaisy is installed
# TD_ROOT="/gscuser/mwyczalk/projects/TinDaisy/TinDaisy"

# using development version of TinDaisy
TD_ROOT="/gscuser/mwyczalk/projects/CWL/TinDaisy.dev"

# Using common datalog file
export DATALOG="/gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/cq.datalog/datalog.dat"

CROMWELL_JAR="/gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/cromwell.jar/44/cromwell-44.jar"

#CWL="$TD_ROOT/cwl/workflows/tindaisy.cwl"
CWL="$TD_ROOT/cwl/workflows/tindaisy-postcall.cwl"

# Workflow root - where Cromwell output goes.  This value replaces text WORKFLOW_ROOT in CONFIG_TEMPLATE,
# and is written to CONFIG_FILE
WORKFLOW_ROOT="/gscmnt/gc2541/cptac3_analysis"
CONFIG_TEMPLATE="config/cromwell-config-db.template.dat"
CONFIG_FILE="dat/cromwell-config-db.dat"

# RESTART_ROOT required when restarting
RESTART_ROOT="$WORKFLOW_ROOT/cromwell-workdir/cromwell-executions/tindaisy.cwl"

# List of cases to analyze.  This has to be created
CASES_FN="dat/cases.dat"

# Path to BamMap, which is a file which defines sequence data path and other metadata
# BamMap format is defined here: https://github.com/ding-lab/importGDC/blob/master/make_bam_map.sh
BAMMAP="/gscuser/mwyczalk/projects/CPTAC3/CPTAC3.catalog/BamMap/MGI.BamMap.dat"

# This path below is for CPTAC3-standard GRCh38 reference
REF_PATH="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1.fa"

# See katmai:/home/mwyczalk_test/Projects/TinDaisy/sw1.3-compare/README.dbsnp.md for discussion of dbSnP references
# Updating to dbSnP-COSMIC version 20190416
DBSNP_DB="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbSnP-COSMIC.GRCh38.d1.vd1.20190416.vcf.gz"

# VEP Cache is used for VEP annotation and vcf_2_maf.
# If not defined, online lookups will be used by VEP annotation. These are slower and do not include allele frequency info (MAX_AF) needed by AF filter.
# For performance reasons, defining vep_cache_gz is suggested for production systems
VEP_CACHE_GZ="/gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/D_VEP/vep-cache.90_GRCh38.tar.gz"

# template used for generating YAML files
# YAML_TEMPLATE="config/CPTAC3-template.yaml"
YAML_TEMPLATE="config/PostMerge-template.yaml"

# These parameters used when finding data in BamMap
ES="WXS"                            # experimental strategy

# TUMOR_ST is normally "tumor", but will be "tissue_normal" for Normal Adjacent Normal Adjacent analyses
TUMOR_ST="tumor"                    # Sample type for tumor BAM, for BAMMAP matching
# TUMOR_ST="tissue_normal"            # Sample type for Normal Adjacent analyses
NORMAL_ST='blood_normal'            # Sample type for normal BAM, for BAMMAP matching.  Default 'blood_normal'
REF_NAME="hg38"                     # Reference, used when matching to BAMMAP


