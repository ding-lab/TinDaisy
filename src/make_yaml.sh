#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Usage: make_yaml.sh [options] CASE [ CASE2 ... ]
  Create YAML files for SomaticSV runs

Options:
-h: print usage information
-b BAMMAP: path to BamMap data file.  Required, must exist
    Format defined here: https://github.com/ding-lab/importGDC/blob/master/make_bam_map.sh
-r REF: path to reference file.  Required, must exist
-y YAMLD: output directory of YAML files.  If "-", write YAML to stdout.  Default: .
-p PRE_SUMMARY: analysis pre-summary filename
-1 : Quit after evaluating one case

If CASE is - then read CASEs from STDIN

Output YAML file filename is CASE.yaml.  It defines tumor WGS BAM, normal WGS BAM, and reference file which is required to run SomaticSV CWL 
BAM paths obtained from BAMMAP 
Assuming all references are hg38 (this is used for searching BAMMAP)
Analysis pre-summary is an optional output file which contains the UUID and sample names of input data; this information will be
  combined with run results at the conclusion of analysis to generate analysis summary file.  Columns: case, tumor name, tumor uuid, normal name, normal uuid
    

EOF

SCRIPT=$(basename $0)

YAMLD="."
while getopts ":hb:r:y:1p:" opt; do
  case $opt in
    h)  # Required
      echo "$USAGE"
      exit 0
      ;;
    b)  # Required
      BAMMAP="$OPTARG"
      ;;
    r)  # Required
      REF="$OPTARG"
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
    exit 1
fi
if [ ! -e $BAMMAP ]; then
    >&2 echo "ERROR: $BAMMAP does not exist"
    exit 1
fi
if [ -z $REF ]; then
    >&2 echo ERROR: Reference not defined \(-r\)
    exit 1
fi
if [ ! -e $REF ]; then
    >&2 echo "ERROR: $REF does not exist"
    exit 1
fi

if [ "$#" -lt 1 ]; then
    >&2 echo ERROR: Wrong number of arguments
    >&2 echo Usage: make_docker_map.sh \[options\] CASE \[CASE2 ...\]
    exit 1
fi

# this allows us to get CASEs in one of two ways:
# 1: start_step.sh ... CASE1 CASE2 CASE3
# 2: cat CASES.dat | start_step.sh ... -
if [ $1 == "-" ]; then
    CASES=$(cat - )
else
    CASES="$@"
fi

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo $SCRIPT: Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

# searches for entries with
#   ref = hg38
#   experimental strategy = WGS
#   sample type = as given
#   case = as given
# Returns BAM, sample name, UUID 
function get_BAM {
    CASE=$1
    ST=$2
    REF="hg38"
    ES="WGS"
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
    BAM=$(echo "$LINE_A" | cut -f 6)
    UUID=$(echo "$LINE_A" | cut -f 10)

    printf "$BAM\t$SN\t$UUID"
}

function get_YAML {
    TUMOR=$1
    NORMAL=$2
    REF=$3

    cat <<EOF
tumor:
  class: File
  path: $TUMOR
normal:
  class: File
  path: $NORMAL
reference:
  class: File
  path: $REF
EOF

}

# Write analysis pre-summary header 
if [ ! -z $PRE_SUMMARY ]; then
    PSD=$(dirname $PRE_SUMMARY)
    if [ ! -d $PSD ]; then
        >&2 echo Making output directory for analysis pre-summary: $PSD
        mkdir -p $PSD
        test_exit_status
    fi

    printf "# case\ttumor_name\ttumor_uuid\tnormal_name\tnormal_uuid\n" > $PRE_SUMMARY
    test_exit_status
fi


for CASE in $CASES
do

    TUMOR=$(get_BAM $CASE "tumor")
    test_exit_status
    TUMOR_BAM=$(echo "$TUMOR" | cut -f 1)

    NORMAL=$(get_BAM $CASE "blood_normal")
    test_exit_status
    NORMAL_BAM=$(echo "$NORMAL" | cut -f 1)

    YAML=$(get_YAML $TUMOR_BAM $NORMAL_BAM $REF)
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
        printf "$CASE\t$TUMOR_SN\t$TUMOR_UUID\t$NORMAL_SN\t$NORMAL_UUID\n" >> $PRE_SUMMARY
    fi

    if [ $JUSTONE ]; then
        >&2 echo Quitting after one
        exit 0
    fi
done

