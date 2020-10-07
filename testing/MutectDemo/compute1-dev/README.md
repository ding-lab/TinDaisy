# Developing simple demonstration MutectDemo for compute1 testing

## Current status

* step 3 fails to start because of bad BAM paths - may have to do with relative / absolute path conversion

## Ongoing issues

* Cannot mount /scratch1
* Cannot start Cromwell server.  May have to do with obtaining compute1 equivalent of 
    -Djavax.net.ssl.trustStore=/gscmnt/gc2560/core/genome/cromwell/cromwell.truststore

# Past work
This is copy of some of the scripts and all of the config files from a test compute1 run which took place here:
    compute1:/storage1/fs1/home1/Active/home/m.wyczalkowski/Projects/TinDaisy/Runs/RIS-Preliminary

This demo is being moved from CromwellRunner project to TinDaisy project, where it will serve as an independent demo
for use in future development.  

CromwellRunner-specific scripts and git directories are deleted.
Scripts in src directory are those present in commit 18d786bb5 of https://github.com/ding-lab/CromwellRunner (compute1 branch)

