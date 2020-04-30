# `demo` directory

This directory contains projects which were used for testing and development and/or can
be used as templates for future runs.

Some past development concerned a simple workflow manager, out of which grew the
[CromwellRunner project]().  Some of these are removed from current repository; some
are described below and can be found in past git commits or on
MGI:/gscuser/mwyczalk/projects/TinDaisy/attic

Current projects:

* MutectDemo/MGI - test run of complete workflow with small test dataset (MutectDemo) on MGI
    * This runs to completion, but does not yield any variants
    * As a result, its purpose is mainly to test the general setup of cromwell and 
      exercise the early parts of the TinDaisy pipeline
    * See `MutectDemo/MutectDemo-data/README` for instrucions on making reference available
* MutectDemo/compute1-dev - demonstration of running MutectDemo on compute1
    * Based on work here: compute1:/home/m.wyczalkowski/Projects/TinDaisy/Runs/RIS-Preliminary
    * Demo above did run, but in context of CromwellRunner, without database, and writing only to local disk
    * It will need to be updated / integrated here when doing additional compute1 development
    * Based on commit 18d786bb5 of https://github.com/ding-lab/CromwellRunner
* tindaisy-postcall/MGI - development and testing of tindaisy-postcall.cwl on Cromwell on MGI
    * Test input dataset of filtered VCFs from callers, from CPTAC3 C3L-01000 LSCC case
* hotspot/MGI - development and testing of hotspot_vld sub-workflow

Archived projects:
* StrelkaDemo - test run of complete workflow with small test dataset (StrelkaDemo)
    * this will not run with Mutect, so is here for historical reasons 
    * Archived on MGI:/gscuser/mwyczalk/projects/TinDaisy/attic/StrelkaDemo
* test.cwltool - Using cwltool to test validity of CWL code before using on Cromwell
    * Trivial wrapper around "cwltool --validate $CWL"
    * Archived on MGI:/gscuser/mwyczalk/projects/TinDaisy/attic/test.cwltool
* katmai.C3L - development and examples of CPTAC3 real data pipelines. Called individually using Rabix
    * Archived on MGI:/gscuser/mwyczalk/projects/TinDaisy/attic/katmai.C3L.tar.gz
* task_call - running multiple samples at once with Rabix and Cromwell
    * Old development of run manager, currently deleted
        * Archived datasets on MGI:/gscuser/mwyczalk/projects/TinDaisy/attic/old.task_call.dev.tar.gz
    * This formed the basis of utilities including cq, runtidy, datatidy, rungo, runplan
        * Driver scripts are specific to Cromwell on MGI, though could be extended to Rabix
    * [CromwellRunner](https://github.com/ding-lab/CromwellRunner) has detailed documenation about running TinDaisy
      using cq and related utilities
