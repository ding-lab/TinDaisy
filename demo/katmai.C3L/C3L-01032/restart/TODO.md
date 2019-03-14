Details to pick up development of vcf2maf step.

This step currently dies with the error from `/usr/local/ensembl-vep/vep`,
```
Can't call method "db" on an undefined value
```

This currently prevents us from running vcf2maf, but that can be considered an optional step.

As a reminder, this step is a restart of a previous one which proceeded as far as the merge step.  vep_annotate
failed, and this workflow starts there, allowing for quick analysis of downstream workflow.

## Run 1:
Died at dbSnP filter step, after merge.  Merge details here:
  /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2019-02-14-231532.904/root/merge_vcf

This work restarts from the above run by using the merged dataset:
    /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-postmerge-2019-02-18-150711.796/root/vep_filter/results/vep_filter/vep_filtered.vcf

Details of error below.  To reproduce it:

### Start docker image
```
    bash /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/src/start_docker.sh -I mwyczalkowski/tindaisy-core:mutect /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-postmerge-2019-02-18-150711.796 /diskmnt/Datasets/Reference/Homo_sapiens_assembly19

    VCF="/data1/root/vep_filter/results/vep_filter/vep_filtered.vcf"
    FA="/data2/Homo_sapiens_assembly19.fasta"

    /usr/bin/perl /usr/local/ensembl-vep/vep --species homo_sapiens --assembly GRCh37 --offline --no_progress --no_stats --buffer_size 5000 --sift b --ccds --uniprot --hgvs --symbol --numbers --domains --gene_phenotype --canonical --protein --biotype --uniprot --tsl --pubmed --variant_class --shift_hgvs 1 --check_existing --total_length --allele_number --no_escape --xref_refseq --failed 1 --vcf --flag_pick_allele --pick_order canonical,tsl,biotype,rank,ccds,length --dir ./vep-cache --fasta $FA --format vcf --input_file $VCF --output_file results/maf/vep_filtered.vep.vcf --fork 4 --cache_version 90 --polyphen b --af --af_1kg --af_esp --af_gnomad --regulatory
```
This yields the error described below.

### Steps ahead

Note that SomaticWrapper does not experience this error.  Example runs for LUAD:

* Data as submitted to DCC: /gscmnt/gc2521/dinglab/scao/cptac3/hg38/luad.b1-4/somatic_per_sample
* Main work dir: /gscmnt/gc2521/dinglab/scao/cptac3/hg38/luad.b1-4/somatic/C3N-00560
* stderr / stdout: /gscmnt/gc2521/dinglab/scao/cptac3/hg38/luad.b1-4/LSF_DIR_SOMATIC/*C3N-00560*
* run scripts: /gscmnt/gc2521/dinglab/scao/cptac3/hg38/luad.b1-4/tmpsomatic/*C3N-00560*

May want to closely compare this run and the one above.

# Error running vcf_2_maf in CWL:
Now get error running vcf_2_maf:
```
    [2019-02-18 15:13:07.334] [INFO] Job root.vcf_2_maf has started
    [2019-02-18 15:14:33.868] [INFO] Pulling docker image mwyczalkowski/tindaisy-core:mutect
    [2019-02-18 15:14:34.314] [INFO] Running command line: /usr/bin/perl /usr/local/somaticwrapper/SomaticWrapper.pl --results_dir results --assembly GRCh37 --input_vcf /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-postmerge-2019-02-18-150711.796/root/vep_filter/results/vep_filter/vep_filtered.vcf --reference_fasta /diskmnt/Datasets/Reference/Homo_sapiens_assembly19/Homo_sapiens_assembly19.fasta --vep_cache_gz /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz --vep_cache_version 90 vcf_2_maf
    [2019-02-18 15:16:05.867] [INFO] Job root.vcf_2_maf failed with exit code 25. with message:
    Running SomaticWrapper step vcf_2_maf
    commit a57f62339b41911c6f973f22bd09338bd5bc7fd6 on 2019-02-18 13:29:49 -0600  (HEAD -> master)
    :

    SomaticWrapper dir: /usr/local/somaticwrapper
    Analysis dir: results
    Run script dir: results/runtime
    Extracting VEP Cache tarball /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz into ./vep-cache
    Writing to results/runtime/j_vcf_2_maf.sh
    Executing:
     bash < results/runtime/j_vcf_2_maf.sh
    STATUS: Running VEP and writing to: results/maf/vep_filtered.vep.vcf
    Can't call method "db" on an undefined value at /usr/local/ensembl-vep/Bio/EnsEMBL/Funcgen/BindingMatrix.pm line 237, <__ANONIO__> line 304.
    Died in forked process 146

    ERROR: Failed to run the VEP annotator! Command: /usr/bin/perl /usr/local/ensembl-vep/vep --species homo_sapiens --assembly GRCh37 --offline --no_progress --no_stats --buffer_size 5000 --sift b --ccds --uniprot --hgvs --symbol --numbers --domains --gene_phenotype --canonical --protein --biotype --uniprot --tsl --pubmed --variant_class --shift_hgvs 1 --check_existing --total_length --allele_number --no_escape --xref_refseq --failed 1 --vcf --flag_pick_allele --pick_order canonical,tsl,biotype,rank,ccds,length --dir ./vep-cache --fasta /diskmnt/Datasets/Reference/Homo_sapiens_assembly19/Homo_sapiens_assembly19.fasta --format vcf --input_file /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-postmerge-2019-02-18-150711.796/root/vep_filter/results/vep_filter/vep_filtered.vcf --output_file results/maf/vep_filtered.vep.vcf --fork 4 --cache_version 90 --polyphen b --af --af_1kg --af_esp --af_gnomad --regulatory
    Fatal error 2: . Exiting.
    Exiting (512).

    Job root.vcf_2_maf failed with exit code 25. with message:
    Running SomaticWrapper step vcf_2_maf
    commit a57f62339b41911c6f973f22bd09338bd5bc7fd6 on 2019-02-18 13:29:49 -0600  (HEAD -> master)
    :

    SomaticWrapper dir: /usr/local/somaticwrapper
    Analysis dir: results
    Run script dir: results/runtime
    Extracting VEP Cache tarball /diskmnt/Datasets/VEP/vep-cache.90_GRCh37.tar.gz into ./vep-cache
    Writing to results/runtime/j_vcf_2_maf.sh
    Executing:
     bash < results/runtime/j_vcf_2_maf.sh
    STATUS: Running VEP and writing to: results/maf/vep_filtered.vep.vcf
    Can't call method "db" on an undefined value at /usr/local/ensembl-vep/Bio/EnsEMBL/Funcgen/BindingMatrix.pm line 237, <__ANONIO__> line 304.
    Died in forked process 146

    ERROR: Failed to run the VEP annotator! Command: /usr/bin/perl /usr/local/ensembl-vep/vep --species homo_sapiens --assembly GRCh37 --offline --no_progress --no_stats --buffer_size 5000 --sift b --ccds --uniprot --hgvs --symbol --numbers --domains --gene_phenotype --canonical --protein --biotype --uniprot --tsl --pubmed --variant_class --shift_hgvs 1 --check_existing --total_length --allele_number --no_escape --xref_refseq --failed 1 --vcf --flag_pick_allele --pick_order canonical,tsl,biotype,rank,ccds,length --dir ./vep-cache --fasta /diskmnt/Datasets/Reference/Homo_sapiens_assembly19/Homo_sapiens_assembly19.fasta --format vcf --input_file /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-postmerge-2019-02-18-150711.796/root/vep_filter/results/vep_filter/vep_filtered.vcf --output_file results/maf/vep_filtered.vep.vcf --fork 4 --cache_version 90 --polyphen b --af --af_1kg --af_esp --af_gnomad --regulatory
    Fatal error 2: . Exiting.
    Exiting (512).
```

Related links:
* https://github.com/mskcc/vcf2maf
* https://support.bioconductor.org/p/63779/
* http://lists.ensembl.org/pipermail/dev/2015-October/011463.html
