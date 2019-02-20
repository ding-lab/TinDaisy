Contents of demo directory

* StrelkaDemo - test run of complete workflow with small test dataset (StrelkaDemo)
    * this will not run with Mutect, so is here for historical reasons 
* MutectDemo - test run of complete workflow with small test dataset (MutectDemo)
    * This runs to completion, but does not yield any variants
* test.rabix - Run individual steps of workflow using rabix with command line args
    * this is old
* test.cromwell - Example runs of StrelkaDemo, real dataset, and restart using Cromwell on MGI.  Uses YAML
    * this is old
* test.cwltool - Using cwltool to test validity of CWL code before using on Cromwell
    * this is old
* test.varscan-only - example of running alternate workflow using Rabix with YAML 
    * this is old
* katmai.C3L - development and examples of CPTAC3 real data pipelines 
    * currently under active development

## Notes about dbSnP database.
**Resolve this, save these elsewhere**

There are several versions of this floating around.  Here are collected notes, and md5sums of data files.  Will need to version and formalize this

Song Cao writes 2/14/19 about most recent version of his database:
    hg19: cb23ebfa578819ee51555b0efe32cbda /gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.snp142.vcf
    hg38: a39513578c4a4a77961563fa358da6a0 /gscmnt/gc2737/ding/hg38_database/DBSNP/00-All.vcf
    Details about how this is generated:  MGI:/gscmnt/gc3027/dinglab/medseq/cosmic/work_log_hg38
On denali: d536a720201d4510e2c9997196b3fc7a  /diskmnt/Projects/Users/hsun/data/dbsnp/00-All.brief.pass.cosmic.vcf.gz
Possibly older version:
    f532b39ba336356e8aefbd681f7c7584  /gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.vcf
    equivalent, but with .gz and .gz.tbi: 
    d536a720201d4510e2c9997196b3fc7a  /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/00-All.brief.pass.cosmic.vcf.gz

"B_Filter" version of dbSnP db, created by MAW workflow on denali.
    Work directory: denali:/home/mwyczalk_test/src/SomaticWrapper/somaticwrapper/image.setup/B_Filter
    Data diretory: denali:/home/mwyczalk_test/data/docker/data/B_Filter
    hg19:  5d57b3acc092d4241a5f5ae92edf3752  /diskmnt/Projects/Users/mwyczalk/data/docker/data/B_Filter/dbsnp.noCOSMIC.GRCh37.vcf.gz
    hg38:  e52e61d97cf7da72101f13790b798665  /diskmnt/Projects/Users/mwyczalk/data/docker/data/B_Filter/dbsnp.noCOSMIC.GRCh38.vcf.gz
B_Filter on MGI:
    hg19: b39b162de5c9f99b0e7297a2365c700e  /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbsnp.noCOSMIC.vcf.gz
    hg38: a6a48d27a89d7ba1a356bede7d588b88  /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbsnp.noCOSMIC.GRCh38.vcf.gz
B_Filter on katmai:
    hg19: 5d57b3acc092d4241a5f5ae92edf3752  /diskmnt/Datasets/dbSNP/SomaticWrapper/B_Filter/dbsnp.noCOSMIC.GRCh37.vcf.gz
    hg38: e52e61d97cf7da72101f13790b798665  /diskmnt/Datasets/dbSNP/SomaticWrapper/B_Filter/dbsnp.noCOSMIC.GRCh38.vcf.gz

Also, another katmai version:
    katmai: - From VCF: "reference=GRCh37.p13"
    d98b7d382f98b0e53aabb316962fae69  /diskmnt/Datasets/COSMIC/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.vcf.gz

