# TinDaisy

Detection of somatic variants from tumor and normal exome data.  TinDaisy
obtains variant calls from four callers, merges them, and applies various filters.

Callers used:

* [Strelka2](https://github.com/Illumina/strelka.git)
* [VarScan.v2.3.8](http://varscan.sourceforge.net/)
* [Pindel](https://github.com/ding-lab/pindel.git)
* [mutect-1.1.7](https://github.com/broadinstitute/mutect)

SNV calls from Strelka2, Varscan, Mutect. Indel calls from Stralka2, Varscan, and Pindel.
[CWL Mutect Tool](https://github.com/mwyczalkowski/mutect-tool) is used for CWL Mutect calls

Filters applied (details in VCF output)
* For indels, require length < 100
* Require normal VAF <= 0.020000, tumor VAF >= 0.050000 for all variants
* Require read depth in tumor > 14 and normal > 8 for all variants
* All variants must be called by 2 or more callers
* Require Allele Frequency < 0.005000 (as determined by vep) 
* Retain exonic calls
* Exclude calls which are in dbSnP but not in COSMIC
* Adjacent variants merged into DNP, TNP, and QNP 

## Versions

* v2.1
  * Fixes AD FORMAT issue for Varscan, so that AD has both alternate and reference allele depth
  * Fixes DNP issue, with FORMAT, TUMOR, and NORMAL fields given by first call
    * Uses [MNP_Filter](https://github.com/ding-lab/mnp_filter)
  * Varscan calls are prioritized during merge, and strelka2 calls are least significant


Details can be found [TinDaisy-Core](https://github.com/ding-lab/TinDaisy-Core)

TinDaisy and TinDaisy-Core were developed from [SomaticWrapper](https://github.com/ding-lab/somaticwrapper) and [GenomeVIP](https://genomevip.readthedocs.io/).  

## Authors

* Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
* Song Cao <scao@wustl.edu>
* Jay Mashl <rmashl@wustl.edu>
