Test run of MutectDemo dataset.  We are currently relying on test data distributed
with TinDaisy.  TinDaisy installation directory is defined as TD_ROOT in 


Goal of this work is to,
1) implement running of simple (lobotomized) workflow
2) test running on compute1
3) demonstrate updated workflow organizational structure (./workflow.XXX)


# How to run

Trying idea of having base scripts in .., passing arguments to scripts to be workflow-specific

```
bash 1_make_yaml.sh -P workflow.MutectDemo/project_config.MutectDemo.compute1.sh -g MutectDemo
bash 2_make_config.sh workflow.MutectDemo/project_config.MutectDemo.compute1.sh 
bash 3_start_runs.sh workflow.MutectDemo/project_config.MutectDemo.compute1.sh MutectDemo

```

With, WORKFLOW_ROOT="/data/Active/cromwell-data"
Getting the following error:
    [2019-12-15 01:27:35,26] [error] /data/Active/cromwell-data/cromwell-workdir/cromwell-workflow-logs
    java.nio.file.AccessDeniedException: /data/Active/cromwell-data/cromwell-workdir/cromwell-workflow-logs
        at sun.nio.fs.UnixException.translateToIOException(UnixException.java:84)


