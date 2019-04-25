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

# Production runs
    * cromwell.LB is run of Bobo's homemade realigned GBM
    * cromwell is run of 42 GBM cases.  Both this and cromwell.LB succeeded
    * cromwell.C3L-01834 is a run of just that particular case
        -> the three runs above should be finalized and merged
    * cromwell.Y2b1.normals is run of 92 Y2b1 adjacent / blood normal analysis
        -> 27 runs in total because only a subset has adjacent normals
        -> run has been completed, not finalized
