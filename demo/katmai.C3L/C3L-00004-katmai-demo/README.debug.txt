[2019-02-18 10:03:43.077] [INFO] Job root.vep_annotate has started
[2019-02-18 10:05:04.866] [INFO] Pulling docker image mwyczalkowski/tindaisy-core:mutect
[2019-02-18 10:05:05.463] [INFO] Running command line: /usr/bin/perl /usr/local/somaticwrapper/SomaticWrapper.pl --results_dir results --assembly GRCh38 --input_vcf /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-17-134803.927/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass
.vcf --reference_fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa --vep_cache_gz /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz --vep_cache_version 90 vep_annotate
[2019-02-18 10:06:41.959] [INFO] Job root.vep_annotate failed with exit code 25. with message:
Running SomaticWrapper step vep_annotate
commit 6b975533f7c91912b64651eacf39577614c6b5e2 on 2019-02-13 23:59:16 -0600  (HEAD -> master)
:

SomaticWrapper dir: /usr/local/somaticwrapper
Analysis dir: results
Run script dir: results/runtime
Extracting VEP Cache tarball /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz into ./vep-cache
Writing to results/vep/vep.merged.input
Writing to results/runtime/j10_vep.sh
Executing:
 bash < results/runtime/j10_vep.sh
cache_version   90
vcf     /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-17-134803.927/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf
output  results/vep/output_vep.vcf
cachedir        ./vep-cache
vep_cmd /usr/local/ensembl-vep/vep
usedb   0
assembly        GRCh38
vep_opts        --flag_pick
output_vep      0
reffasta        /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
VEP Cache mode
perl /usr/local/ensembl-vep/vep --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-17-134803.927/ro
ot/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

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
Date (localtime)    = Mon Feb 18 16:06:40 2019
Ensembl API version = 94
---------------------------------------------------
Error executing: perl /usr/local/ensembl-vep/vep --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02
-17-134803.927/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

Fatal error 2: . Exiting.
Exiting (512).

Job root.vep_annotate failed with exit code 25. with message:
Running SomaticWrapper step vep_annotate
commit 6b975533f7c91912b64651eacf39577614c6b5e2 on 2019-02-13 23:59:16 -0600  (HEAD -> master)
:

SomaticWrapper dir: /usr/local/somaticwrapper
Analysis dir: results
Run script dir: results/runtime
Extracting VEP Cache tarball /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz into ./vep-cache
Writing to results/vep/vep.merged.input
Writing to results/runtime/j10_vep.sh
Executing:
 bash < results/runtime/j10_vep.sh
cache_version   90
vcf     /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-17-134803.927/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf
output  results/vep/output_vep.vcf
cachedir        ./vep-cache
vep_cmd /usr/local/ensembl-vep/vep
usedb   0
assembly        GRCh38
vep_opts        --flag_pick
output_vep      0
reffasta        /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
VEP Cache mode
perl /usr/local/ensembl-vep/vep --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-17-134803.927/ro
ot/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

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
Date (localtime)    = Mon Feb 18 16:06:40 2019
Ensembl API version = 94
---------------------------------------------------
Error executing: perl /usr/local/ensembl-vep/vep --flag_pick --assembly GRCh38 --cache_version 90 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02
-17-134803.927/root/dbsnp_filter/results/dbsnp_filter/dbsnp_pass.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

Fatal error 2: . Exiting.
Exiting (512).
