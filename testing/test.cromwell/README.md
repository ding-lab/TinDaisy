
Preliminary testing of cromwell CWL engine for TinDaisy at MGI.
* cromwell

Preliminary testing on epazote using rabix and cwltool.

Start docker with,
`~/start_docker.sh`
This sets up the appropriate JAVA environment necessary to run Cromwell.  

# Testing C3N-01649

```
tmux
sh run_cromwell.C3N-01649.sh 
(then CTRL-b d)
```

## Errors:

dbSnP filter error:

Could not localize /gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.vcf.tbi -> /gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/ba2d414c-
e19e-4fe3-a9c0-fcf4f6595ab8/call-dbsnp_filter/inputs/-1021637489/00-All.brief.pass.cosmic.vcf.tbi:
        /gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.vcf.tbi doesn't exist

# Lessons learned

## Hard links

If cromwell-executions is on the same volume as the BAM files, cromwell will create hard links to the dat rather than
try to copy it over.  This is much much faster, so for now, should have an Executions folder on each allocation

This is specified in config.ini, and is currently set for /gscmnt/gc2741/ding/cptac/cromwell-workdir

## tmux

Use TMUX from virtual workstation to capture logs and disconnect / attach at will without killing
job.  nohup will die when log out, bsub takes a long time


