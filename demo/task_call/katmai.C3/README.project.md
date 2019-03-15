This is a demonstration project for running TinDaisy on katmai
43 GBM cases, CPTAC3 harmonized WXS data

Initial development of YAML creation and simple task manager implementation,
based on somatic_sv_workflow/demo/task_call/Demo

Current run is on kobuk

NOTE: Something is creating TinDaisy/demo_data directory repeatedly, as root.  Investigate why


TODO: add flags
    --hgvs
    --tsr
    --canonical
as arguments to vep


grep Y2.b1 ~/Projects/CPTAC3/CPTAC3.catalog/CPTAC3.cases.dat | grep GBM | cut -f 1 > dat/Y2.b1.GBM.cases.dat


Note: C3L-01834 has no WGS tumor
