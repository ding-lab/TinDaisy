#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Usage: make_yaml.sh [options] [CASE1 [ CASE2 ... ]]
  Create YAML files and analysis pre-summary for TinDaisy runs

Reqired Options:
-b BAMMAP: path to BamMap data file.  Required, must exist
-Y YAML_TEMPLATE: template YAML file upon which we'll do variable substitution
-P PARAMS: parameters file which holds varibles for substution in template

Options:
-h: print usage information
-1 : Quit after evaluating one case
-k CASES_FN: file with list of all cases, one per line, used when CASE1 not defined. Default: dat/cases.dat
-y YAMLD: output directory of YAML files.  If "-", write YAML to stdout.  Default: .
-p PRE_SUMMARY: analysis pre-summary filename
-e ES : experimental strategy - WGS, WXS, etc.  This is required

YAML files (./yaml/CASE.yaml) contain inputs for each run, including paths to BAMs.  Analysis pre-summary file 
(typically ./logs/analysis_pre-summary.dat) contains inputs for each run, and will be the basis of the
analysis_summary.dat file written when run is finalized

If CASE is - then read CASE from STDIN.  If CASE is not defined, read from CASES_FN file.

Output YAML file filename is CASE.yaml.  It is based on YAML_TEMPLATE, with the following variables substituted:
    * NORMAL_BAM
    * TUMOR_BAM
    * REF
    * TD_ROOT
    * DBSNP_DB
    * VEP_CACHE_GZ
The BAMs are defined by lookup of CASE in BamMap, the remainder in PARAMS
Assuming all references are hg38 (this is used for searching BAMMAP)
Analysis pre-summary is an optional output file which contains the UUID and sample names of input data; this information will be
  combined with run results at the conclusion of analysis to generate analysis summary file.  Columns: case, tumor name, tumor uuid, normal name, normal uuid
Format of BamMap is defined here: https://github.com/ding-lab/importGDC/blob/master/make_bam_map.sh
    
EOF

source cromwell_utils.sh

SCRIPT=$(basename $0)

YAMLD="."
CASES_FN="dat/cases.dat"
PRE_SUMMARY="dat/analysis_pre-summary.dat"
while getopts ":hb:Y:P:p:y:1e:k:" opt; do
  case $opt in
    h)  # Required
      echo "$USAGE"
      exit 0
      ;;
    b)  # Required
      BAMMAP="$OPTARG"
      ;;
    Y)  # Required
      YAML_TEMPLATE="$OPTARG"
      ;;
    P)  # Required
      PARAM_FILE="$OPTARG"
      ;;
    y)  
      YAMLD="$OPTARG"
      ;;
    1)  
      JUSTONE=1
      ;;
    p)  
      PRE_SUMMARY="$OPTARG"
      >&2 echo "Writing analysis pre-summary file to $PRE_SUMMARY"
      ;;
    e) # Required
      ES="$OPTARG"
      ;;
    k) 
      CASES_FN="$OPTARG"
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      >&2 echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      >&2 echo "$USAGE"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z $BAMMAP ]; then
    >&2 echo ERROR: BamMap file not defined \(-b\)
    >&2 echo "$USAGE"
    exit 1
fi
confirm $BAMMAP 

if [ -z $YAML_TEMPLATE ]; then
    >&2 echo ERROR: YAML template not defined \(-Y\)
    >&2 echo "$USAGE"
    exit 1
fi
confirm $YAML_TEMPLATE 

if [ -z $PARAM_FILE ]; then
    >&2 echo ERROR: Parameter file  not defined \(-p\)
    >&2 echo "$USAGE"
    exit 1
fi
confirm $PARAM_FILE 

if [ -z $ES ]; then
    >&2 echo ERROR: Experimental strategy not defined \(-e\)
    >&2 echo "$USAGE"
    exit 1
fi

# this allows us to get case names in one of three ways:
# 1: cq CASE1 CASE2 ...
# 2: cat cases.dat | cq -
# 3: read from CASES_FN file
# Note that if no cases defined, assume CASE='-'
if [ "$#" == 0 ]; then
    confirm "$CASES_FN"
    CASES=$(cat $CASES_FN)
elif [ "$1" == "-" ] ; then
    CASES=$(cat - )
else
    CASES="$@"
fi

# searches for entries with
#   ref = hg38
#   experimental strategy = WGS, WXS, RNA-Seq, etc
#   sample type = as given
#   case = as given
# Returns BAM, sample name, UUID 
function get_BAM {
    CASE=$1
    ST=$2
    ES=$3
    REF="hg38"
    # BAMMAP as global

    # BamMap columns
    #     1  sample_name
    #     2  case
    #     3  disease
    #     4  experimental_strategy
    #     5  sample_type
    #     6  data_path
    #     7  filesize
    #     8  data_format
    #     9  reference
    #    10  UUID
    #    11  system

    LINE_A=$(awk -v c=$CASE -v ref=$REF -v es=$ES -v st=$ST 'BEGIN{FS="\t";OFS="\t"}{if ($2 == c && $4 == es && $5 == st && $9 == ref) print}' $BAMMAP)

    if [ -z "$LINE_A" ]; then
        >&2 echo ERROR: $REF $CASE $ES $ST sample not found in $BAMMAP
        exit 1
    elif [ $(echo "$LINE_A" | wc -l) != "1" ]; then
        >&2 echo ERROR: $REF $CASE $ES $ST sample has multiple matches in $BAMMAP
        >&2 echo Not making assumptions about which to choose, YAML will need to be created manually
        #LINE_A=$(echo "$LINE_A" | head -n 1)
        exit 1
    fi

    # Sample Name and UUID will be needed for analysis summary
    SN=$(echo "$LINE_A" | cut -f 1)
    DIS=$(echo "$LINE_A" | cut -f 3)
    BAM=$(echo "$LINE_A" | cut -f 6)
    UUID=$(echo "$LINE_A" | cut -f 10)

    printf "$BAM\t$SN\t$UUID\t$DIS"
}

# Write analysis pre-summary header 
if [ ! -z $PRE_SUMMARY ]; then
    # To avoid data loss, return with error if PRE_SUMMARY exists
    if [ -f $PRE_SUMMARY ]; then
        >&2 echo ERROR: File $PRE_SUMMARY exists.  Please delete / rename before continuing
        exit 1
    fi
    PSD=$(dirname $PRE_SUMMARY)
    if [ ! -d $PSD ]; then
        >&2 echo Making output directory for analysis pre-summary: $PSD
        mkdir -p $PSD
        test_exit_status
    fi

    printf "# case\tdisease\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\n" > $PRE_SUMMARY
    test_exit_status
fi

source $PARAM_FILE
# Not all of these really need to be defined
if [ -z $REF ]; then
    >&2 echo ERROR: REF not defined in $PARAM_FILE
    exit 1
fi
if [ -z $TD_ROOT ]; then
    >&2 echo ERROR: TD_ROOT not defined in $PARAM_FILE
    exit 1
fi
if [ -z $DBSNP_DB ]; then
    >&2 echo ERROR: DBSNP_DB not defined in $PARAM_FILE
    exit 1
fi
if [ -z $VEP_CACHE_GZ ]; then
    >&2 echo ERROR: VEP_CACHE_GZ not defined in $PARAM_FILE
    exit 1
fi

# envsubst requires variables to be exported
export REF
export TD_ROOT
export DBSNP_DB
export VEP_CACHE_GZ

for CASE in $CASES; do
    >&2 echo Processing $CASE

    TUMOR=$(get_BAM $CASE "tumor" $ES)
    test_exit_status
    export TUMOR_BAM=$(echo "$TUMOR" | cut -f 1)

    NORMAL=$(get_BAM $CASE "blood_normal" $ES)
    test_exit_status
    export NORMAL_BAM=$(echo "$NORMAL" | cut -f 1)

# envsubst: https://stackoverflow.com/a/11050943
    YAML=$(envsubst < $YAML_TEMPLATE)
    if [ $YAMLD == "-" ]; then
        echo "$YAML"
    else
        YAML_FN="$YAMLD/$CASE.yaml"
        echo "$YAML" > $YAML_FN
        >&2 echo Written to $YAML_FN
    fi

    if [ ! -z $PRE_SUMMARY ]; then
        TUMOR_SN=$(echo "$TUMOR" | cut -f 2)
        TUMOR_UUID=$(echo "$TUMOR" | cut -f 3)
        NORMAL_SN=$(echo "$NORMAL" | cut -f 2)
        NORMAL_UUID=$(echo "$NORMAL" | cut -f 3)
        DIS=$(echo "$TUMOR" | cut -f 4)
        printf "$CASE\t$DIS\t$TUMOR_SN\t$TUMOR_UUID\t$NORMAL_SN\t$NORMAL_UUID\n" >> $PRE_SUMMARY
    fi

    if [ $JUSTONE ]; then
        >&2 echo Quitting after one
        exit 0
    fi
done

