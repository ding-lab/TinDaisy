# TinDaisy Project Config file
#
# This file is common to all steps in project
# Contains all per-system configuration
# Contains only definitions, no execution code

# testing of mutect demo on compute1 using cromwell 47
# Assume LSF Volume mapping /storage1/fs1/m.wyczalkowski:/data

# System: compute1

## per-project ##

PROJECT="MutectDemo"
# List of cases to analyze.  This has to be created
CASES_FN="dat/cases.dat"


## System ##
CROMWELL_JAR="/usr/local/cromwell/cromwell-47.jar"

# Where TinDaisy is installed
TD_ROOT="/home/m.wyczalkowski/Projects/TinDaisy/TinDaisy"

# Workflow root - where Cromwell output goes.  This value replaces text WORKFLOW_ROOT in CONFIG_TEMPLATE,
# and is written to CONFIG_FILE
# On compute1 are putting WORKFLOW_ROOT on scratch disk for performance
#   * doesn't seem to work currently
# WORKFLOW_ROOT="/scratch/cromwell"     # Doesn't work
# WORKFLOW_ROOT="/data/Active/cromwell-data"    # doesn't work
WORKFLOW_ROOT="/home/m.wyczalkowski/Projects/TinDaisy/cromwell-data"
CONFIG_TEMPLATE="config/cromwell-config-db.template.dat"
CONFIG_FILE="dat/cromwell-config-db.dat"

# Path to BamMap, which is a file which defines sequence data path and other metadata
# BamMap format is defined here: https://github.com/ding-lab/importGDC/blob/master/make_bam_map.sh
## BamMap not needed for MutectDemo 
# BAMMAP="/home/m.wyczalkowski/Projects/CPTAC3/CPTAC3.catalog/BamMap/compute1.BamMap.dat"

# This path below is for CPTAC3-standard GRCh38 reference
## REF_PATH not needed for MutectDemo 
# REF_PATH="/data/Active/Resources/References/GRCh38.d1.vd1/GRCh38.d1.vd1.fa"

# See katmai:/diskmnt/Datasets/dbSNP/SomaticWrapper/README.md for discussion of dbSnP references
# Updating to dbSnP-COSMIC version 20190416
## DBSNP_DB not needed for MutectDemo
# DBSNP_DB="/data/Active/Resources/Databases/dbSnP-COSMIC/GRCh38.d1.vd1/dbSnP-COSMIC.GRCh38.d1.vd1.20190416.vcf.gz"

# VEP Cache is used for VEP annotation and vcf_2_maf.
# If not defined, online lookups will be used by VEP annotation. These are slower and do not include allele frequency info (MAX_AF) needed by AF filter.
# For performance reasons, defining vep_cache_gz is suggested for production systems
## VEP_CACHE_GZ not needed for MutectDemo
# VEP_CACHE_GZ="/data/Active/Resources/Databases/VEP/compressed/vep-cache.90_GRCh38.tar.gz"

## Pipeline ##
# template used for generating YAML files
YAML_TEMPLATE="workflow.MutectDemo/MutectDemo.yaml"

CWL="$TD_ROOT/cwl/workflows/tindaisy.cwl"

## Variables below superfluous for MutectDemo 
# These parameters used when finding data in BamMap
# ES="WXS"                            # experimental strategy

# TUMOR_ST is normally "tumor", but will be "tissue_normal" for Normal Adjacent Normal Adjacent analyses
# TUMOR_ST="tumor"                    # Sample type for tumor BAM, for BAMMAP matching
# TUMOR_ST="tissue_normal"            # Sample type for Normal Adjacent analyses
# NORMAL_ST='blood_normal'            # Sample type for normal BAM, for BAMMAP matching.  Default 'blood_normal'
# REF_NAME="hg38"                     # Reference, used when matching to BAMMAP


