Testing of hotspot-vld workflow using "real" test data.
See ../demo_data/README.md for details about provenance

VCF=../demo_data/varscan-snv.vcf
BED=../demo_data/smg-genes.ens84.norm.bed

## VCF Filter Config files
"A" corresponds to parameters within domain of BED.  This is the hotspot

vcf_filter_config_A:  ../demo_data/hotspot_filter_config/vcf_filter_config-varscan.hotspot.ini

"B" corresponnds to standard parameters:
vcf_filter_config_B:  ../../../params/filter_config/vcf_filter_config-varscan.ini

## Testing alternative cases

* test to make sure .gz files are properly processed
* test to make sure errors in malformed BED files are properly caught

# Run 1:
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/hotspot_vld.cwl/e6e3623c-3c50-48fd-abfb-9dc55bbaf9da/call-hotspotfilter/execution/output/HotspotFiltered.vcf
OK

# Run 2: 
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/hotspot_vld.cwl/fb6bd4ad-e639-4bf5-801c-38b476374b4b/call-hotspotfilter/execution/output/HotspotFiltered.vcf
-> may be good to compare against regular run

# Run 3:
This actually does two different things:

* demonstrates that original BED fails.  May be a tab/space issue? YAML="cwl-yaml/hotspot-vld-BED-error.yaml"
* demonstrates that 4-column BED file works.
  BED: /gscuser/mwyczalk/projects/TinDaisy/TinDaisy/demo/hotspot_vld/demo_data/smg-genes.ens84.norm.4col.bed
  * /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/hotspot_vld.cwl/7e07e3b7-a3ae-490b-951b-3df6f16fa509/call-hotspotfilter/execution/output/HotspotFiltered.vcf
