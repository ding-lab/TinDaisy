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
  - id: bypass_vaf
    type: boolean?
  - id: bypass_length
    type: boolean?
  - id: bypass_depth
    type: boolean?
  - id: pindel_vcf_filter_config
    type: File
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
  - id: strelka_vcf_filter_config
    type: File
  - id: varscan_vcf_filter_config
    type: File
  - id: af_filter_config
    type: File
  - id: classification_filter_config
    type: File
  - id: bypass_af
    type: boolean?
  - id: bypass_classification
    type: boolean?
  - id: mutect_vcf_filter_config
    type: File
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: input_vcf_varscan_snv
    type: File
  - id: input_vcf_varscan_indel
    type: File
  - id: input_vcf_strelka_snp
    type: File
  - id: input_vcf_strelka_indel
    type: File
  - id: input_vcf_pindel
    type: File
  - id: input_vcf_mutect
    type: File
outputs:
  - id: output_vcf
    outputSource:
      vep_filter/output_vcf
    type: File
  - id: output_maf
    outputSource:
      vcf2maf/output
    type: File?
steps:
  - id: pindel_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: input_vcf_pindel
      - id: vcf_filter_config
        source: pindel_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Pindel VAF Length Depth
  - id: strelka_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: input_vcf_strelka_snp
      - id: vcf_filter_config
        source: strelka_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Strelka SNV VAF Length Depth
  - id: varscan_snv_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: input_vcf_varscan_snv
      - id: vcf_filter_config
        source: varscan_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Varscan SNV VAF Length Depth
  - id: varscan_indel_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: input_vcf_varscan_indel
      - id: vcf_filter_config
        source: varscan_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Varscan indel VAF Length Depth
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_vaf_length_depth_filters/filtered_vcf
      - id: varscan_indel_vcf
        source: varscan_indel_vaf_length_depth_filters/filtered_vcf
      - id: varscan_snv_vcf
        source: varscan_snv_vaf_length_depth_filters/filtered_vcf
      - id: pindel_vcf
        source: pindel_vaf_length_depth_filters/filtered_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_merge
        source: bypass_merge
      - id: debug
        source: debug
      - id: strelka_indel_vcf
        source: strelka_indel_vaf_length_depth/filtered_vcf
      - id: mutect_vcf
        source: mutect_vaf_length_depth/filtered_vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: merge_vcf
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: mnp_filter/filtered_VCF
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
  - id: strelka_indel_vaf_length_depth
    in:
      - id: input_vcf
        source: input_vcf_strelka_indel
      - id: vcf_filter_config
        source: strelka_vcf_filter_config
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Strelka Indel vaf_length_depth
  - id: mutect_vaf_length_depth
    in:
      - id: input_vcf
        source: input_vcf_mutect
      - id: vcf_filter_config
        source: mutect_vcf_filter_config
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: mutect vaf_length_depth
  - id: mnp_filter
    in:
      - id: input
        source: merge_vcf/merged_vcf
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_VCF
    run: ../mnp_filter/cwl/mnp_filter.cwl
    label: MNP_filter
  - id: vcf2maf
    in:
      - id: ref-fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: input-vcf
        source: vep_filter/output_vcf
      - id: tumor_barcode
        source: tumor_barcode
      - id: normal_barcode
        source: normal_barcode
    out:
      - id: output
    run: ../tools/vcf2maf.cwl
    label: vcf2maf
requirements: []
