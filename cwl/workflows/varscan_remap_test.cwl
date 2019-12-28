class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: reference_fasta
    type: File
    'sbg:x': -163.6551055908203
    'sbg:y': 445.9594421386719
  - id: debug
    type: boolean?
    'sbg:x': 0
    'sbg:y': 963
  - id: bypass_merge
    type: boolean?
    'sbg:x': 0
    'sbg:y': 1070
  - id: pindel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 749
  - id: varscan_snv_vcf
    type: File
    'sbg:x': -169.94305419921875
    'sbg:y': 134.90701293945312
  - id: varscan_indel_vcf
    type: File
    'sbg:x': -173.14952087402344
    'sbg:y': 308.1741027832031
  - id: strelka_snv_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 535
  - id: strelka_indel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 642
  - id: mutect_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 856
outputs:
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
    'sbg:x': 650.9874877929688
    'sbg:y': 367.5
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
    'sbg:x': 203.8125
    'sbg:y': 479
  - id: varscan_vcf_remap
    in:
      - id: input
        source: varscan_snv_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
    'sbg:x': -11.66775131225586
    'sbg:y': 160.25889587402344
  - id: varscan_vcf_remap_1
    in:
      - id: input
        source: varscan_indel_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
    'sbg:x': -26.044235229492188
    'sbg:y': 363.8053894042969
requirements: []
