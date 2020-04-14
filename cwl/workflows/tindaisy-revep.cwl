class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: reference_fasta
    type: File
    'sbg:x': -127.39801025390625
    'sbg:y': 79.86292266845703
  - id: assembly
    type: string?
    'sbg:x': 0
    'sbg:y': 401.5390625
  - id: vep_cache_version
    type: string?
    'sbg:x': -418.2881774902344
    'sbg:y': -189.26849365234375
  - id: vep_cache_gz
    type: File?
    'sbg:x': -115.20032501220703
    'sbg:y': -27.492372512817383
  - id: af_filter_config
    type: File
    'sbg:x': 203.8125
    'sbg:y': 454.921875
  - id: classification_filter_config
    type: File
    'sbg:x': 203.8125
    'sbg:y': 134.71875
  - id: bypass_af
    type: boolean?
    'sbg:x': 203.8125
    'sbg:y': 348.1875
  - id: bypass_classification
    type: boolean?
    'sbg:x': 203.8125
    'sbg:y': 241.453125
  - id: input_vcf
    type: File
    'sbg:x': -206.8599853515625
    'sbg:y': 309.260498046875
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 1000.1475830078125
    'sbg:y': 227.60719299316406
steps:
  - id: vep_annotate
    in:
      - id: input_vcf
        source: input_vcf
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
    'sbg:x': 203.8125
    'sbg:y': 0
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
    'sbg:x': 572.105712890625
    'sbg:y': 213.46875
requirements: []
