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
    * currently under active development
    * katmai.C3 and kenai.C3.B - two directories demonstrating multiple runs in parallel using Rabix
      These serve as models for production runs.  Note that these were mistakenly run using WGS data but WXS parameters
    * test.cromwell - Example runs of CPTAC3 data using Cromwell on MGI.  
