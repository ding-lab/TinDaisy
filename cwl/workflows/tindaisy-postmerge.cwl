class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy-PostMerge
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: reference_fasta
    type: File
    'sbg:x': 1429.0174560546875
    'sbg:y': 467.3354797363281
  - id: debug
    type: boolean?
    'sbg:x': 1416.8162841796875
    'sbg:y': 292.2827453613281
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
  - id: input_vcf
    type: File
    'sbg:x': 1425.0262451171875
    'sbg:y': 85.12535858154297
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
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: input_vcf
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
