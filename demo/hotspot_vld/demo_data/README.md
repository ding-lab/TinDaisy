Data to demonstrate functionality is based on real runs.

# VCF
Currently, just evaluating varscan-snv, others could be used.

Specifically, the file below is from the output of parse_varscan_snv
step for LSCC case C3L-00081.  It is copied to ./varscan-snv.vcf from
    /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy.cwl/ba435cc8-087e-416f-8e7a-55c00c322c64/analysis/call-parse_varscan_snv/execution/results/varscan/filter_snv_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf

This file has 2366 variants

Output of VLD filtering from above run is copied to ./filtered.baseline.vcf from
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy.cwl/ba435cc8-087e-416f-8e7a-55c00c322c64/analysis/call-varscan_snv_vaf_length_depth_filters/execution/results/vaf_length_depth_filters/filtered.vcf

# BED

BED file corresponding to 299 SMGs from 
    From Bailey et al., Comprehensive Characterization of Cancer Driver Genes and Mutations
    https://doi.org/10.1016/j.cell.2018.02.060

Created here: /gscuser/mwyczalk/projects/TinDaisy/SMG_BED/README.md

Based on intersect of SMGs and list of gene positions developed in BreakpointSurveyor
    https://github.com/ding-lab/BreakPointSurveyor
    BreakPointSurveyor/B_ExonGene/dat

NOTE, this is based on older v84 version of ensembl, should be updated for production work

File from smg-genes.ens84.norm.bed copied here from above work

# Parameter files

hotspot_vld filter uses two filter parameters for each input VCF file.  For testing here,
and for further tests, we will have a hotspot parameter file which has the following difference:
For all callers, in the file /gscuser/mwyczalk/projects/TinDaisy/TinDaisy/params/filter_config/vcf_filter_config-varscan.ini
    min_vaf_somatic = 0.05
is changed to
    min_vaf_somatic = 0.00

Currently, the filters need different input files with different callers defined in them
(in the future, have caller be an argument in CWL), so that for a full run there will be 8 input files.

For purposes of this testing, will create vcf_filter_config-hotspot-varscan.ini which contains the above modification

