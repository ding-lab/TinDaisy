class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: reference_fasta
    type: File
    'sbg:x': 1436.0509033203125
    'sbg:y': 397.6621398925781
  - id: debug
    type: boolean?
    'sbg:x': 1407.037353515625
    'sbg:y': 512.5458984375
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 1427.9630126953125
    'sbg:y': 749
  - id: dbsnp_db
    type: File?
    'sbg:x': 1427.9630126953125
    'sbg:y': 642
  - id: assembly
    type: string?
    'sbg:x': 1856.738525390625
    'sbg:y': 695.5
  - id: vep_cache_version
    type: string?
    'sbg:x': 1429.228759765625
    'sbg:y': 153.4971160888672
  - id: vep_cache_gz
    type: File?
    'sbg:x': 1429.228759765625
    'sbg:y': 270.7302551269531
  - id: af_filter_config
    type: File
    'sbg:x': 2271.801025390625
    'sbg:y': 856
  - id: classification_filter_config
    type: File
    'sbg:x': 2271.801025390625
    'sbg:y': 535
  - id: bypass_af
    type: boolean?
    'sbg:x': 2271.801025390625
    'sbg:y': 749
  - id: bypass_classification
    type: boolean?
    'sbg:x': 2271.801025390625
    'sbg:y': 642
  - id: input_vcf
    type: File
    'sbg:x': 1234.227783203125
    'sbg:y': 452.33782958984375
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2910.808837890625
    'sbg:y': 620.4569702148438
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File?
    'sbg:x': 2884.906005859375
    'sbg:y': 295.7909240722656
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
      - id: merged_vcf
    run: ./dbsnp_filter.cwl
    label: dbsnp_filter
    'sbg:x': 1856.738525390625
    'sbg:y': 560.5
  - id: vep_annotate
    in:
      - id: input_vcf
        source: dbsnp_filter/merged_vcf
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
    run: ./vep_annotate.cwl
    label: vep_annotate
    'sbg:x': 2271.801025390625
    'sbg:y': 400
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
    run: ./vep_filter.cwl
    label: vep_filter
    'sbg:x': 2534.446044921875
    'sbg:y': 599.51220703125
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: vep_filter/output_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_maf
    run: ./vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 2705.67236328125
    'sbg:y': 292.0940856933594
requirements: []
