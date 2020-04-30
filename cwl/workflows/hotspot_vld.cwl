class: Workflow
cwlVersion: v1.0
id: hotspot_vld
label: hotspot_vld
inputs:
  - id: vcf_filter_config_A
    type: File
  - id: input_vcf
    type: File
  - id: vcf_filter_config_B
    type: File
  - id: BED
    type: File
outputs:
  - id: output
    outputSource:
      hotspotfilter/output
    type: File
steps:
  - id: vaf_length_depth_filters_A
    in:
      - id: input_vcf
        source: input_vcf
      - id: vcf_filter_config
        source: vcf_filter_config_A
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters_A
  - id: vaf_length_depth_filters_B
    in:
      - id: input_vcf
        source: input_vcf
      - id: vcf_filter_config
        source: vcf_filter_config_B
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters_B
  - id: hotspotfilter
    in:
      - id: VCF_A
        source: vaf_length_depth_filters_A/filtered_vcf
      - id: VCF_B
        source: vaf_length_depth_filters_B/filtered_vcf
      - id: BED
        source: BED
    out:
      - id: output
    run: ../hotspot_filter/hotspotfilter.cwl
    label: HotspotFilter
requirements: []
