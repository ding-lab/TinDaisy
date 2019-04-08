This is a demonstration project for running TinDaisy on katmai
43 GBM cases, CPTAC3 harmonized WXS data

Initial development of YAML creation and simple task manager implementation,
based on somatic_sv_workflow/demo/task_call/Demo

Current run is on kobuk

Note: C3L-01834 has no WGS tumor

Finding errors in varscan_snv_vaf_length_depth, where a .idx file of length 0 is created.  This makes the merge step crash.

Created C3L-00104 direct run on kobuk in image 460b370957f8, but cannot push to github because of NFS issues.  This is not 
a problem on kenai or sitka.  When NFS becomes available, push this branch (merge branch on TinDaisy-Core) to master
