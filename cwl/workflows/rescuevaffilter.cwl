class: Workflow
cwlVersion: v1.0
id: rescuevaffilter
label: RescueVAFFilter
inputs:
  - id: VCF
    type: File
  - id: BED
    type: File
  - id: caller
    type: string
outputs:
  - id: output
    outputSource:
      hotspotfilter/output
    type: File
steps:
  - id: somatic_vaf_filter_B
    in:
      - id: VCF
        source: VCF
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        source: caller
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF Filter - General
  - id: somatic_vaf_filter_A
    in:
      - id: VCF
        source: VCF
      - id: min_vaf_tumor
        default: 0
      - id: max_vaf_normal
        default: 0.05
      - id: caller
        source: caller
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF Filter - Rescue
  - id: hotspotfilter
    in:
      - id: VCF_A
        source: somatic_vaf_filter_A/output
      - id: VCF_B
        source: somatic_vaf_filter_B/output
      - id: BED
        source: BED
      - id: filter_name
        default: VAF_rescue
    out:
      - id: output
    run: ../../submodules/HotspotFilter/cwl/hotspotfilter.cwl
    label: HotspotFilter
requirements: []
