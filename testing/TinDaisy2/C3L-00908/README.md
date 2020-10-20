Using test CCRCC case C3L-00908.
See MGI:/gscuser/mwyczalk/projects/TinDaisy/testing/dbSnP-filter-dev/VEP_annotate.testing.C3L-00908/testing/README.data.md
for details on this dataset.  It is based on CromwellRunner run: 06_CCRCC.HotSpot.20200511
Path on MGI: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy-hotspot.cwl/47c63123-dab6-417b-a431-c9aa9589e6e4/results

Principal output: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy-hotspot.cwl/47c63123-dab6-417b-a431-c9aa9589e6e4/results/call-canonical_filter/execution/output/HotspotFiltered.vcf


YAML file for C3L-00908:
/gscuser/mwyczalk/projects/CromwellRunner/TinDaisy/06_CCRCC.HotSpot.20200511/logs/stashed/47c63123-dab6-417b-a431-c9aa9589e6e4/C3L-00908.yaml

# VEP Annotation

Development work:
    /gscuser/mwyczalk/projects/TinDaisy/testing/dbSnP-filter-dev/VEP_annotate.testing.C3L-00908/testing/cwl_call-MGI

On MGI:
custom_filename = /gscmnt/gc7202/dinglab/common/databases/ClinVar/GRCh38/20200706/clinvar_20200706.vcf.gz
Can be obtained here: ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/

# Comparison vs. TinDaisy2

TD1=/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy-hotspot.cwl/47c63123-dab6-417b-a431-c9aa9589e6e4/results/call-canonical_filter/execution/output/HotspotFiltered.vcf
TD2=/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2-restart_postcall.cwl/c1501766-fad5-41dd-a03b-5a952c49d219/call-canonical_filter/execution/output/HotspotFiltered.vcf

vimdiff $TD1 $TD2

Additional comparison here: /gscuser/mwyczalk/projects/TinDaisy/testing/TinDaisy2/C3L-00908/README.md
