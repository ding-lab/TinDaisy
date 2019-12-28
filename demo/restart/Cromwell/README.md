Goal is to develop simple test of running tindaisy-postcall.cwl, which 
is a workflow which starts following the vaf / length / depth filter
for each caller.

Testing is done on LSCC runs performed here:
    /gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/LSCC.20191104
In particular, focus on LSCC case C3L-01000   
    Run directory: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy.cwl/e8d19867-8b3b-497e-b853-37a1579da46f
        Run output uncompressed in this directory
    Original yaml in orig.C3L-01000.yaml from /gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/LSCC.20191104/logs/stashed/e8d19867-8b3b-497e-b853-37a1579da46f/C3L-01000.yaml
    cromwell-config-db.dat based on /gscuser/mwyczalk/projects/TinDaisy/CromwellRunner/LSCC.20191104/config/cromwell-config-db.template.dat
        Using WORKFLOW_ROOT = /gscmnt/gc2508/dinglab/mwyczalk/cromwell-dev
    

Prior work on restarts done in /gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_restart
    YAML file for restarting based on /gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_restart/config/PostMerge-template.yaml

Cromwell testing based on work here: https://github.com/ding-lab/mnp_filter/tree/master/testing/cwl_call


