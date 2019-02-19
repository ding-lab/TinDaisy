# Demonstration of hg38 YAML run on katmai

Test dataset is WXS hg38 LUAD C3N-00560
Goal is to evaluate against SomaticWrapper v1.3.  

from `~/Projects/CPTAC3/CPTAC3.catalog/katmai.BamMap.dat`:
```
C3N-00560.WXS.N.hg38	C3N-00560	LUAD	WXS	blood_normal	/diskmnt/Projects/cptac/GDC_import/data/accd545e-f33e-4ad8-9a31-1249a5a51290/4bf3027a-6c8c-4b4c-9fe9-9b9b9010d877_gdc_realn.bam	43028891230	BAM	hg38	accd545e-f33e-4ad8-9a31-1249a5a51290	katmai
C3N-00560.WXS.T.hg38	C3N-00560	LUAD	WXS	tumor	/diskmnt/Projects/cptac/GDC_import/data/8986d3b8-c817-4f96-a9e3-3842719e0735/5cc34d69-b52a-41a7-bf06-e5d2bce79815_gdc_realn.bam	43225649586	BAM	hg38	8986d3b8-c817-4f96-a9e3-3842719e0735	katmai
```

Debug:

This runs through to vep_annotate step, and dies with the following error:
`/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/vep_annotate/job.err.log`

This was traced back to incorrect version of VEP Cache file.

Restarted from `dbsnp_filter` output, `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf`

Final results, from restart, 
/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-vep_annotate-2019-02-19-172011.356/root/vep_filter/results/vep_filter/vep_filtered.vcf
