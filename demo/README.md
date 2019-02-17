Contents of demo directory

**TODO** implement and run MutectDemo on epazote

* StrelkaDemo - test run of complete workflow with small test dataset (StrelkaDemo)
    * this will not run with Mutect, so is here for historical reasons 
* MutectDemo - test run of complete workflow with small test dataset (MutectDemo)
    * This runs to completion, but does not yield any variants
* ./C3L-01032-katmai-demo - Run of real tumor / normal PDA hg19 dataset on katmai with YAML
* test.C3N-01649 - demonstration of running real dataset using rabix with command line arguments
    * this is old
* test.rabix - Run individual steps of workflow using rabix with command line args
    * this is old
* test.cromwell - Example runs of StrelkaDemo, real dataset, and restart using Cromwell on MGI.  Uses YAML
    * this is old
* test.cwltool - Using cwltool to test validity of CWL code before using on Cromwell
    * this is old
* test.varscan-only - example of running alternate workflow using Rabix with YAML 
    * this is old
