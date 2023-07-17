# TinDaisy2 workflow v2.6

Description of parameters in TinDaisy2 v2.6 pipeline.  [See here for more 
general information about TinDaisy2.](https://github.com/ding-lab/TinDaisy)

## Versions
* v2.6.2 - Bugfix to VCF headers.  Using updated VEP v99.
* v2.6.1 - Adds `bypass_classification` parameter.  Also introducing `-ffpe` variant
* v2.6 Adding staging of BAMs.  Does not affect results
* v2.5 pipeline uses `cwl/workflows/tindaisy2.cwl` workflow

## General filter parameters

* For indels, require length < 100
* Require normal VAF <= 0.02, tumor VAF >= 0.05 for all variants
* Require read depth in tumor > 14 and normal > 8 for all variants
* All variants must be called by 2 or more callers
* Require Allele Frequency < 0.005 (as determined by vep) 
* Retain exonic calls
* Exclude calls which are in dbSnP but not in COSMIC or ClinVar
* Adjacent variants merged into DNP, TNP, and QNP 

VAF Rescue is not used

## Specific databases used

* ClinVar annotation: [`clinvar_20200706`](https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/archive_2.0/2020/clinvar_20200706.vcf.gz)
* Reference: [GRCh38.d1.vd1.fa](https://gdc.cancer.gov/about-data/gdc-data-processing/gdc-reference-files)
* VEP version 99

## Output

Three files are output:
* `ProximityFiltered.vcf` = Output VCF - contains all variants which were called by 2 or 3 callers.
  * The FILTER field of this VCF indicates which filters a variant failed, or PASS if passed all filters
* `result.maf` = Clean VCF - contains only variants which passed all filters
* `HotspotFiltered.vcf` = Clean MAF - MAF file corresponding to Clean VCF


