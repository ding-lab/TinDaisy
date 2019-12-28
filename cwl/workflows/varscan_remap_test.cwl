class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
inputs:
  - id: reference_fasta
    type: File
  - id: debug
    type: boolean?
  - id: bypass_merge
    type: boolean?
  - id: pindel_vcf
    type: File
  - id: varscan_snv_vcf
    type: File
  - id: varscan_indel_vcf
    type: File
  - id: strelka_snv_vcf
    type: File
  - id: strelka_indel_vcf
    type: File
  - id: mutect_vcf
    type: File
outputs:
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
steps:
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_snv_vcf
      - id: varscan_indel_vcf
        source: varscan_vcf_remap_1/remapped_VCF
      - id: varscan_snv_vcf
        source: varscan_vcf_remap/remapped_VCF
      - id: pindel_vcf
        source: pindel_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_merge
        source: bypass_merge
      - id: debug
        source: debug
      - id: strelka_indel_vcf
        source: strelka_indel_vcf
      - id: mutect_vcf
        source: mutect_vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: merge_vcf
  - id: varscan_vcf_remap
    in:
      - id: input
        source: varscan_snv_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
  - id: varscan_vcf_remap_1
    in:
      - id: input
        source: varscan_indel_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
requirements: []
