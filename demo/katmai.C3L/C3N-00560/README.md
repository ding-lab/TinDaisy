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
```
    Running SomaticWrapper step vep_annotate 
    commit a57f62339b41911c6f973f22bd09338bd5bc7fd6 on 2019-02-18 13:29:49 -0600  (HEAD -> master)
    : 

    SomaticWrapper dir: /usr/local/somaticwrapper 
    Analysis dir: results
    Run script dir: results/runtime
    Extracting VEP Cache tarball /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz into ./vep-cache
    Writing to results/vep/vep.merged.input
    Writing to results/runtime/j10_vep.sh
    Executing:
     bash < results/runtime/j10_vep.sh 
    usedb	0
    vep_cmd	/usr/local/ensembl-vep/vep
    vep_opts	--pick_order tsl --flag_pick
    output_vep	0
    vcf	/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf
    reffasta	/diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
    cachedir	./vep-cache
    assembly	GRCh38
    cache_version	90
    output	results/vep/output_vep.vcf
    VEP Cache mode
    perl /usr/local/ensembl-vep/vep --pick_order tsl --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

    -------------------- EXCEPTION --------------------
    MSG: ERROR: Cache assembly version (GRCh37) and database or selected assembly version (GRCh38) do not match

    If using human GRCh37 add "--port 3337" to use the GRCh37 database, or --offline to avoid database connection entirely

    STACK Bio::EnsEMBL::VEP::CacheDir::dir /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/CacheDir.pm:340
    STACK Bio::EnsEMBL::VEP::CacheDir::init /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/CacheDir.pm:227
    STACK Bio::EnsEMBL::VEP::CacheDir::new /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/CacheDir.pm:111
    STACK Bio::EnsEMBL::VEP::AnnotationSourceAdaptor::get_all_from_cache /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/AnnotationSourceAdaptor.pm:115
    STACK Bio::EnsEMBL::VEP::AnnotationSourceAdaptor::get_all /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/AnnotationSourceAdaptor.pm:91
    STACK Bio::EnsEMBL::VEP::BaseRunner::get_all_AnnotationSources /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/BaseRunner.pm:175
    STACK Bio::EnsEMBL::VEP::Runner::init /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/Runner.pm:123
    STACK Bio::EnsEMBL::VEP::Runner::run /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/Runner.pm:194
    STACK toplevel /usr/local/ensembl-vep/vep:224
    Date (localtime)    = Tue Feb 19 20:50:01 2019
    Ensembl API version = 94
    ---------------------------------------------------
    Error executing: perl /usr/local/ensembl-vep/vep --pick_order tsl --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa 
      
    Fatal error 2: . Exiting.
    Exiting (512).
```

Will restart from `dbsnp_filter` output, `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-18-212809.259/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf`

