class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy-Merge
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: reference_fasta
    type: File
    'sbg:x': 608.8523559570312
    'sbg:y': 407.1379699707031
  - id: debug
    type: boolean?
    'sbg:x': 586.862060546875
    'sbg:y': 253.97012329101562
  - id: bypass_merge
    type: boolean?
    'sbg:x': 602.9306030273438
    'sbg:y': 562.3523559570312
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 1427.963134765625
    'sbg:y': 747.46875
  - id: dbsnp_db
    type: File?
    'sbg:x': 1427.963134765625
    'sbg:y': 640.6875
  - id: assembly
    type: string?
    'sbg:x': 1856.738525390625
    'sbg:y': 694.078125
  - id: vep_cache_version
    type: string?
    'sbg:x': 1847.685302734375
    'sbg:y': 248.6655731201172
  - id: vep_cache_gz
    type: File?
    'sbg:x': 1847.6796875
    'sbg:y': 383.77581787109375
  - id: af_filter_config
    type: File
    'sbg:x': 2271.801025390625
    'sbg:y': 854.25
  - id: classification_filter_config
    type: File
    'sbg:x': 2271.801025390625
    'sbg:y': 533.90625
  - id: bypass_af
    type: boolean?
    'sbg:x': 2271.801025390625
    'sbg:y': 747.46875
  - id: bypass_classification
    type: boolean?
    'sbg:x': 2271.801025390625
    'sbg:y': 640.6875
  - id: bypass_vcf2maf
    type: boolean?
    'sbg:x': 2797.294921875
    'sbg:y': 769.046142578125
  - id: varscan_snv_vcf
    type: File
    'sbg:x': 579.2044067382812
    'sbg:y': -166.57106018066406
  - id: varscan_indel_vcf
    type: File
    'sbg:x': 580.20556640625
    'sbg:y': -43.4282341003418
  - id: strelka_snv_vcf
    type: File
    'sbg:x': 577.2020874023438
    'sbg:y': 77.71227264404297
  - id: strelka_indel_vcf
    type: File
    'sbg:x': 449.0534362792969
    'sbg:y': 181.83303833007812
  - id: pindel_vcf
    type: File
    'sbg:x': 435.0372009277344
    'sbg:y': 347.0246276855469
  - id: mutect_vcf
    type: File
    'sbg:x': 431.0325622558594
    'sbg:y': 519.224365234375
outputs:
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File
    'sbg:x': 3463.528076171875
    'sbg:y': 640.6875
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 3091.59423828125
    'sbg:y': 694.078125
steps:
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_snv_vcf
      - id: varscan_indel_vcf
        source: varscan_indel_vcf
      - id: varscan_snv_vcf
        source: varscan_snv_vcf
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
    'sbg:x': 1502.548095703125
    'sbg:y': 158.9398651123047
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: merge_vcf/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_dbsnp
        source: bypass_dbsnp
      - id: debug
        source: debug
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: filtered_vcf
    run: ../tools/dbsnp_filter.cwl
    label: dbsnp_filter
    'sbg:x': 1856.738525390625
    'sbg:y': 559.296875
  - id: vep_annotate
    in:
      - id: input_vcf
        source: dbsnp_filter/filtered_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_dat
    run: ../tools/vep_annotate.cwl
    label: vep_annotate
    'sbg:x': 2271.801025390625
    'sbg:y': 399.1250305175781
  - id: vep_filter
    in:
      - id: input_vcf
        source: vep_annotate/output_dat
      - id: af_filter_config
        source: af_filter_config
      - id: classification_filter_config
        source: classification_filter_config
      - id: bypass_af
        source: bypass_af
      - id: bypass_classification
        source: bypass_classification
    out:
      - id: output_vcf
    run: ../tools/vep_filter.cwl
    label: vep_filter
    'sbg:x': 2640.09423828125
    'sbg:y': 612.6875
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: vep_filter/output_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: bypass_vcf2maf
        source: bypass_vcf2maf
    out:
      - id: output_maf
    run: ../tools/vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 3091.59423828125
    'sbg:y': 559.296875
requirements: []
