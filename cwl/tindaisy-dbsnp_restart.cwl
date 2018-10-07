class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
inputs:
  - id: reference_fasta
    type: File
  - id: debug
    type: boolean?
  - id: bypass_dbsnp
    type: boolean?
  - id: dbsnp_db
    type: File?
  - id: assembly
    type: string?
  - id: vep_cache_version
    type: string?
  - id: vep_cache_gz
    type: File?
  - id: af_filter_config
    type: File
  - id: classification_filter_config
    type: File
  - id: bypass_af
    type: boolean?
  - id: bypass_classification
    type: boolean?
  - id: input_vcf
    type: File
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File?
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
requirements: []
