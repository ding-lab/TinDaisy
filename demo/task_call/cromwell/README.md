Testing of cromwell CWL engine for TinDaisy at MGI

# Getting started

1. edit `dat/cromwell-config-db.dat`
   -> this will define where the output of Cromwell goes, which can be large
2. edit `dat/project_config.dat`.  This has per-system definitions
3. Create file `dat/cases.dat`, which lists all cases we'll be processing
4. Start docker with `~/0_start_docker.sh`.  This sets up the appropriate JAVA environment necessary to run Cromwell at MGI.  
5. run `1_make_yaml.sh` to construct YAML files which define inputs for each run
6. Launch jobs with `2_run_tasks.sh`.
7. Describe how to check status
8. Run `3_make_analysis_summary.sh` to collect all results
9. Clean run directories **TODO**

## `jq` and `parallel`

The packages jq and parallel need to be installed.  Conda is good for this.  Prior to starting, do
```
conda activate jq
```

This is best run in tmux container.  tmux should probably be started before running `0_start_docker.sh` so that can
return to right remote server.

may need to run `parallel --citation` once

# Testing runs

## MGI definitions

The following parameters must be defined to generate the YAML file:

* NORMAL_BAM - from BamMap
* TUMOR_BAM  - from BamMap
* REF        - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1.fa
* TD_ROOT    - /gscuser/mwyczalk/projects/TinDaisy/TinDaisy 
* DBSNP_DB   - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbSnP-COSMIC.GRCh38.d1.vd1.vcf.gz
               see katmai:/home/mwyczalk_test/Projects/TinDaisy/sw1.3-compare/README.dbsnp.md for details
* VEP_CACHE_GZ - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/D_VEP/vep-cache.90_GRCh38.tar.gz

* Principal output directory - /gscmnt/gc2741/ding/cptac/cromwell-workdir
    -> this is not incorporated into config.dat

## Bobo VCF parameters were added

We wish to have the following flags for vcf invocation, per Bobo:
```
vep \
    --hgvs --shift_hgvs 1 --no_escape \
    --symbol --numbers --ccds --uniprot --xref_refseq --sift b \
    --tsl --canonical --total_length --allele_number \
    --variant_class --biotype       \
    --flag_pick_allele              \
    --pick_order tsl,biotype,rank,canonical,ccds,length
```

### Connect to db
Also test interaction with database
https://genome-cromwell.gsc.wustl.edu/

See description here of connection to Cromwell:
https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase

# Results of C3L-00104 run `6abf1c89-aac2-4b40-8ff4-8616fa728853`

This is a GBM hg38 case which is available on both MGI and katmai.  The run was a single case (not parallelized)

```
MGI.BamMap.dat:C3L-00104.WXS.N.hg38 C3L-00104   GBM WXS blood_normal    /gscmnt/gc2741/ding/CPTAC3-data/GDC_import/data/cd8ff448-91ea-44b2-9293-0c89f3b6c7a3/27b12d40-946d-4fc4-b336-b0edd9bcaa3c_wxs_gdc_realn.bam 42838462277 BAM hg38    cd8ff448-91ea-44b2-9293-0c89f3b6c7a3    MGI
MGI.BamMap.dat:C3L-00104.WXS.T.hg38 C3L-00104   GBM WXS tumor   /gscmnt/gc2741/ding/CPTAC3-data/GDC_import/data/fc6acfc5-97f2-405f-9fb7-7f1b6c1dce00/d36cf415-f716-4e50-a949-a06459cd5277_wxs_gdc_realn.bam 56263243160 BAM hg38    fc6acfc5-97f2-405f-9fb7-7f1b6c1dce00    MGI
```

Result VCF: `/gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/6abf1c89-aac2-4b40-8ff4-8616fa728853/call-vep_filter/execution/results/vep_filter/vep_filtered.vcf`

## Timing

run_strelka 2 has 4 cpu, run_pindel has 4 cpu:

run_varscan: start [2019-04-12 22:18:48,87], end [2019-04-13 02:50:38,10]  -> about 4.5 hrs
mutect: start [2019-04-12 22:18:48,97]  end [2019-04-13 02:51:25,79]       -> about 4.5 hrs
run_strelka2: [2019-04-12 22:18:49,18], end [2019-04-13 00:36:38,48]       -> about 2.3 hrs
run_pindel: [2019-04-12 22:18:49,19],   [2019-04-12 22:44:48,40]           -> about 0.5 hrs
Entire run: end [2019-04-13 03:03:57,04]                                   -> about 4.75 hrs

## disk space

Complete directory size of `/gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/6abf1c89-aac2-4b40-8ff4-8616fa728853`
-> 147G

This may not even account for all files, since some directories start with - and may not be reported.  For instance, with 50Gb tumor (?) bams staged
four times for four callers, would expect 200+Gb for that file alone.

### Cleanup 
Running `rm -rf */inputs` reduces disk use to 663M
Compressing `call-mutect/execution/mutect_call_stats.txt` reduces file size from 435M to 95M

`call-parse_varscan_snv/execution/results/varscan/filter_snv_out/varscan.out.som_snv.Germline*.vcf` are two files which take up 27M and 29M, and
are not used

`call-run_strelka2/execution/results/strelka2/strelka_out/workspace` is a temp directory which is 97M in size, can be compressed or deleted

-> It is possible to reduce size of completed job significantly with a cleanup script

# Testing multiple runs

Testing these three cases in a parallel run (-J 4): `C3L-00365 C3L-00674 C3L-00677`

All start OK, but Cromwell does not seem to capture any errors or job completed signals - it
still thinks they're running when the individual jobs are done.

It seems that `parallel` might not be an appropriate wrapper for Cromwell jobs.  Will test with non-parallel mode


# Lessons learned

## Hard links

If cromwell-executions is on the same volume as the BAM files, cromwell will create hard links to the dat rather than
try to copy it over.  This is much much faster, so for now, should have an Executions folder on each allocation

This is specified in config.ini, and is currently set for /gscmnt/gc2741/ding/cptac/cromwell-workdir

For preliminary testing this is unavoidable

## tmux

Use TMUX from virtual workstation to capture logs and disconnect / attach at will without killing
job.  nohup will die when log out, bsub takes a long time


