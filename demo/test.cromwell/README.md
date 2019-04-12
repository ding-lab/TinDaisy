
Testing of cromwell CWL engine for TinDaisy at MGI.  Additions from `task_call/katmai.C3`

Start docker with,
`~/0_start_docker.sh`
This sets up the appropriate JAVA environment necessary to run Cromwell.  

## TODO

### Add Bobo VCF parameters

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



# Testing C3L-00104

This is a GBM hg38 case which is available on both MGI and katmai

```
MGI.BamMap.dat:C3L-00104.WXS.N.hg38 C3L-00104   GBM WXS blood_normal    /gscmnt/gc2741/ding/CPTAC3-data/GDC_import/data/cd8ff448-91ea-44b2-9293-0c89f3b6c7a3/27b12d40-946d-4fc4-b336-b0edd9bcaa3c_wxs_gdc_realn.bam 42838462277 BAM hg38    cd8ff448-91ea-44b2-9293-0c89f3b6c7a3    MGI
MGI.BamMap.dat:C3L-00104.WXS.T.hg38 C3L-00104   GBM WXS tumor   /gscmnt/gc2741/ding/CPTAC3-data/GDC_import/data/fc6acfc5-97f2-405f-9fb7-7f1b6c1dce00/d36cf415-f716-4e50-a949-a06459cd5277_wxs_gdc_realn.bam 56263243160 BAM hg38    fc6acfc5-97f2-405f-9fb7-7f1b6c1dce00    MGI
```

### Errors

C3L-00104 fails with the following:
```
[2019-04-12 00:56:12,59] [error] WorkflowManagerActor Workflow 9184d53d-2231-41fb-8bb9-e086e4c58490 failed (during ExecutingWorkflowState): Job vcf_2_maf:NA:1 exited with return
code 255 which has not been declared as a valid return code. See 'continueOnReturnCode' runtime attribute for more details.
Check the content of stderr for potential additional information: /gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/9184d53d-2231-41fb-8bb9-e086e4c58490
/call-vcf_2_maf/execution/stderr.
 Unknown option: skip bypass_vcf2maf
Error parsing command line args.
```

Output of this run: /gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/9184d53d-2231-41fb-8bb9-e086e4c58490

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

# Lessons learned

## Hard links

If cromwell-executions is on the same volume as the BAM files, cromwell will create hard links to the dat rather than
try to copy it over.  This is much much faster, so for now, should have an Executions folder on each allocation

This is specified in config.ini, and is currently set for /gscmnt/gc2741/ding/cptac/cromwell-workdir

For preliminary testing this is unavoidable

## tmux

Use TMUX from virtual workstation to capture logs and disconnect / attach at will without killing
job.  nohup will die when log out, bsub takes a long time

