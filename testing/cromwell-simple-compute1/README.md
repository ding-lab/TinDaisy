This is a template for running TinDaisy2 using [Cromwell](https://cromwell.readthedocs.io/en/stable/) on compute1 system at Wash U.
Note that extensive past examples of workflows can be found through commit ee6d954eb

# Setup
Currently using file-based cromwell database as developed here: 
`/home/m.wyczalkowski/Projects/CWL-dev/SomaticSV-dev/SomaticSV.database`

## WORKFLOW_ROOT
Prior to running, be sure to update the Cromwell configuration to point to an appropirate work directory, which will
typically be different for each user.  As an example, for user `m.wyczalkowski`, the destination directory may be,
    WORKFLOW_ROOT="/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data"

Specifically,
* Create `$WORKFLOW_ROOT` if it does not exist
    * Also create `$WORKFLOW_ROOT/logs`
* `cp dat/cromwell-config-db.compute1-filedb.template.dat dat/cromwell-config-db.compute1-filedb.dat`
* Edit `dat/cromwell-config-db.compute1-filedb.dat` to replace all instances of the string WORKFLOW_ROOT with the 
  appropriate value

# Starting

TinDaisy run on WXS data typically takes several hours, and run will generally die if console
disconnects.  Several ways

## Run directly
Run directly from command line and make sure terminal stays open.  This is the easiest and good for initial
testing
```
bash 0_start_docker-compute1_cromwell.sh
bash 1_run_cromwell_demo.sh
```

## tmux
Run in tmux session.  This will run for up to 24 hours
```
tmux new -s TinDaisy
bash 0_start_docker-compute1_cromwell.sh
cd testing/cromwell-simple-compute1
bash 1_run_cromwell_demo.sh
```

This should start Cromwell and run the TinDaisy2 workflow on a single case.  Such a run will typically take
several hours.  

## bsub
To allow for jobs which run longer than 24 hours, need to submit job to bsub directly.  This is preferred for advanceed testing
and simple "production" runs.  
```
2_launch_demo_bsub.sh
```
This calls `1_run_cromwell_demo.sh` and writes output to ./logs

For larger batches of runs, suggest using CromwellRunner rather than multiple bsub submissions

