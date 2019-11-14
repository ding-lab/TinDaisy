class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
inputs:
  - id: tumor_bam
    type: File
  - id: reference_fasta
    type: File
  - id: debug
    type: boolean?
  - id: bypass_merge
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
  - id: bypass_vcf2maf
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
  - id: output_maf
    outputSource:
      vcf_2_maf/output_maf
    type: File
  - id: output_vcf
    outputSource:
      vep_filter/output_vcf
    type: File
  - id: merged_vcf
    outputSource:
      merge_vcf/merged_vcf
    type: File
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
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: dnp_filter/filtered_VCF
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
  - id: dnp_filter
    in:
      - id: input
        source: merge_vcf/merged_vcf
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_VCF
    run: ../dnp_filter/cwl/dnp_filter.cwl
    label: DNP_filter
requirements: []
