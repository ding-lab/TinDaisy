Demonstration of hg19 YAML run on katmai

Test dataset is C3L-01032, which is part of CPTAC3 PDA8 core / bulk test.

This is extension of previous run, which died early because of wrong dbSnP name.

/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-14-231532.904/root/merge_vcf/results/merged/merged.filtered.vcf

This run ends up dying on vcf2maf step.  Details of this, including how to reproduce and debugging suggestions, in TODO.md

however, vcf2maf is an optional step, and can be disabled in the YAML file.  Until the error described in TODO.md is
resolved, setting in the YAML file
```
bypass_vcf2maf: true
```
will avoid this problem.


