Task call is based on that developed here:
/home/mwyczalk_test/Projects/SomaticSV/somatic_sv_workflow/demo/task_call/Demo

It consists of a simple workflow manager which uses GNU Parallel to run N tasks at a time

Preliminary work focused on Rabix as a workflow manager:
* katmai.C3 - ran cases.A.dat and running cases.B.dat on kobuk
    * these fail at merge step.  Is it kobuk-specific?
    * yes, this is kobuk-specific.  Runs with no error like this on kenai
* kenai.C3.B - running cases.C.dat on kenai
    * Dies at vcf_2_maf step, error reported to Cyriac
* NOTE: because of an error generating YAML, this was run on WGS data (not WXS as expected)
    * Its suggested this data is kept for future testing

Subsequent runs in cromwell
* significant development of `cromwell_query.sh` and associated workflows
* Runs in directories cromwell, cromwell.B, and cromwell.C developed parallel runs tested on GBM cases
    * these were deleted, details noted in cromwell/README.historic-runs
* Preliminary runs were rerun because of problems detected with dbSnP database.  Continuing with updated dbSnP-COSMIC version 20190416
* cromwell.LB is run of Bobo's homemade realigned GBM

