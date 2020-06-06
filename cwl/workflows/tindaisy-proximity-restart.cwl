class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy-Hotspot-Proximity
inputs:
  - id: reference_fasta
    type: File
  - id: assembly
    type: string?
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: distance
    type: int?
  - id: input_VCF
    type: File
outputs:
  - id: output_maf
    outputSource:
      vcf2maf/output
    type: File?
  - id: output_vcf
    outputSource:
      snp_indel_proximity_filter/output
    type: File
steps:
  - id: vcf2maf
    in:
      - id: ref-fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: input-vcf
        source: snp_indel_proximity_filter/output
      - id: tumor_barcode
        source: tumor_barcode
      - id: normal_barcode
        source: normal_barcode
    out:
      - id: output
    run: ../tools/vcf2maf.cwl
    label: vcf2maf
  - id: snp_indel_proximity_filter
    in:
      - id: input
        source: input_VCF
      - id: distance
        default: 5
        source: distance
    out:
      - id: output
    run: ../SnpIndelProximityFilter/snp_indel_proximity_filter.cwl
    label: snp_indel_proximity_filter
requirements: []
