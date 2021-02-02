Testing of Rescue VAF filter CWL workflow, rescuevaffilter.cwl
on a "real" dataset.

Based on prior Hotspot VLD testing: hotspot_vld/cromwell-simple/README.md 

VAF Rescue runs `somatic_vaf_filter.cwl` on an input VCF file twice and generates
generates two VCF files which differ in the input parameters:
* `VCF_A` - min_vaf_normal = 0.0  
* `VCF_B` - min_vaf_normal = 0.05 
In all cases, max_vaf_normal = 0.02

HotspotFilter takes both as input, as well as a BED file defining regions where
rescue will occur. It outputs a VCF file which consists of:
* All regions of VCF_A which lie within regions defined by BED file
* All regions of VCF_B which lie outside regions defined by BED file

## template

caller: a_string  # type "string"
BED:  # type "File"
    class: File
    path: a/file/path
VCF:  # type "File"
    class: File
    path: a/file/path

## Input data

Based on run5 of C3L-00908, from ../C3L-00908/cromwell-simple/README.md
Output base dir:
BASE=/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2-restart_postcall.cwl/5281f45b-ae70-473b-abc6-64d445ccfe11

From past work (README.hotspot_vld.md), can use any of six different inputs for testing.  Here choosing Varscan SNV:
VCF=$BASE/call-parse_varscan_snv/execution/results/varscan/filter_snv_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf

## Input BED

Gene list obtained from UMich group:
    /gscmnt/gc3021/dinglab/yli/CPTAC_CCRCC/rescue_UMich/rescue_list_SMG_add_UMich.tsv

Input BED file for rescue obtained as described here: /gscuser/mwyczalk/projects/TinDaisy/SMG_BED/CCRCC_UMich_SMG/README.md
Based on gencode v36 coordinates

Path to Rescue BED: /gscuser/mwyczalk/projects/TinDaisy/SMG_BED/CCRCC_UMich_SMG/dat/CCRCC_UMich.SMG.v36.bed

# Result

OLDRUN1=/cac70a15-2caa-4f0e-8888-13b96dcb5609
BASE=/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/rescuevaffilter.cwl/4e0dceac-a17a-455e-aee7-f412fe06dbad

VCF_A=$BASE/call-somatic_vaf_filter_A/execution/somatic_vaf_filter.output.vcf
VCF_B=$BASE/call-somatic_vaf_filter_B/execution/somatic_vaf_filter.output.vcf
-> note, these dont' differ except in header

Final result: VCF_OUT=$BASE/call-hotspotfilter/execution/output/HotspotFiltered.vcf
