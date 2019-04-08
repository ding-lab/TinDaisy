Task call is based on that developed here:
/home/mwyczalk_test/Projects/SomaticSV/somatic_sv_workflow/demo/task_call/Demo

It consists of a simple workflow manager which uses GNU Parallel to run N tasks at a time

Currently running two batches of cases:
* katmai.C3 - ran cases.A.dat and running cases.B.dat on kobuk
    * these fail at merge step.  Is it kobuk-specific?
    * yes, this is kobuk-specific.  Runs with no error like this on kenai
* kenai.C3.B - running cases.C.dat on kenai
    * Dies at vcf_2_maf step, error reported to Cyriac
