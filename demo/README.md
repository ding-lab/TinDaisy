Contents of demo directory

There are a number of projects created here during development and testing.

* StrelkaDemo - test run of complete workflow with small test dataset (StrelkaDemo)
    * this will not run with Mutect, so is here for historical reasons 
* MutectDemo - test run of complete workflow with small test dataset (MutectDemo)
    * This runs to completion, but does not yield any variants
    * Currently has errors on Cromwell
* test.cwltool - Using cwltool to test validity of CWL code before using on Cromwell
* katmai.C3L - development and examples of CPTAC3 real data pipelines. Called individually using Rabix
* task_call - running multiple samples at once with Rabix and Cromwell
    * Old development of run manager, currently deleted
        * Archived datasets on MGI:/gscuser/mwyczalk/projects/TinDaisy/old.task_call.dev.tar.gz
    * This formed the basis of utilities including cq, runtidy, datatidy, rungo, runplan
        * Driver scripts are specific to Cromwell on MGI, though could be extended to Rabix
    * [CromwellRunner](https://github.com/ding-lab/CromwellRunner) has detailed documenation about running TinDaisy
      using cq and related utilities
* restart/Cromwell - development and testing of tindaisy-postcall.cwl on Cromwell
