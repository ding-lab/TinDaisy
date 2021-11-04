# `testing` directory

This directory contains projects which were used for testing and development and/or can
be used as templates for future runs.

Some past development concerned a simple workflow manager, out of which grew the
[CromwellRunner project]().  Some of these are removed from current repository; some
are described below and can be found in past git commits or on
MGI:/gscuser/mwyczalk/projects/TinDaisy/attic

## Future work

Work here should be cleaned up to retain only a few relevent testing scripts,
* MutectDemo for testing callers on a small datasete
* VCF files from a real CPTAC3 dataset for testing filtering and merging

# Current work

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
* hotspot_vld - development and testing of hotspot_vld sub-workflow. Largely superceded by rescue VAF filter below
* TinDaisy2/C3L-00908
    * testing of TinDaisy2 against past project
* TinDaisy2/RescueVAF
    * testing of rescue VAF filter on C3L-00908 dataset
