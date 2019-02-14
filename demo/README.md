Contents of demo directory

**TODO** implement and run MutectDemo on epazote

* StrelkaDemo - test run of complete workflow with small test dataset (StrelkaDemo)
    * this will not run with Mutect, so is here for historical reasons 
* MutectDemo - test run of complete workflow with small test dataset (MutectDemo)
    * This runs to completion, but does not yield any variants
* test.C3N-01649 - demonstration of running real dataset using rabix with command line arguments
* test.rabix - Run individual steps of workflow using rabix with command line args
* test.cromwell - Example runs of StrelkaDemo, real dataset, and restart using Cromwell on MGI.  Uses YAML
* test.cwltool - Using cwltool to test validity of CWL code before using on Cromwell
* test.varscan-only - example of running alternate workflow using Rabix with YAML 

* `run_workflow.StrelkaDemo.sh` - script which runs entire StrelkaDemo using Rabix with YAML
