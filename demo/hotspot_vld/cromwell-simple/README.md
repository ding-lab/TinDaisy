Testing of hotspot-vld workflow using "real" test data.
See ../demo_data/README.md for details about provenance

VCF=../demo_data/varscan-snv.vcf
BED=../demo_data/smg-genes.ens84.norm.bed

## VCF Filter Config files
"A" corresponds to parameters within domain of BED.  This is the hotspot

vcf_filter_config_A:  ../demo_data/hotspot_filter_config/vcf_filter_config-varscan.hotspot.ini

"B" corresponnds to standard parameters:
vcf_filter_config_B:  ../../../params/filter_config/vcf_filter_config-varscan.ini

## Run errors

Workflow output parameters such as WorkflowOutputParameter(file:///gscuser/mwyczalk/projects/TinDaisy/TinDaisy/cwl/workflows/hotspot_vld.cwl#output,None,None,None,None,None,None,Some(Inr(Inl([Ljava.lang.String;@4d99316))),None,Some(Inl(Inl(File)))) are not supported.
