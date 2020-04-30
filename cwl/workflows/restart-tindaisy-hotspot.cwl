class: Workflow
cwlVersion: v1.0
id: tindaisy
label: Restart-TinDaisy-Hotspot
inputs:
  - id: tumor_bam
    type: File
  - id: reference_fasta
    type: File
  - id: pindel_vcf_filter_config
    type: File
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
  - id: mutect_vcf_filter_config
    type: File
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: Hotspot_BED
    type: File
  - id: mutect_vcf_filter_config_A
    type: File
  - id: pindel_vcf_filter_config_A
    type: File
  - id: varscan_vcf_filter_config_A
    type: File
  - id: strelka_vcf_filter_config_A
    type: File
  - id: input_vcf_varscan_snv
    type: File
  - id: input_vcf_varscan_indel
    type: File
  - id: input_vcf_strelka_snv
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
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: hotspot_vld_strelka_snv/output
      - id: varscan_indel_vcf
        source: hotspot_vld_varscan_indel/output
      - id: varscan_snv_vcf
        source: hotspot_vld_varscan_snv/output
      - id: pindel_vcf
        source: hotspot_vld_pindel/output
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_indel_vcf
        source: hotspot_vld_strelka_indel/output
      - id: mutect_vcf
        source: hotspot_vld_mutect/output
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
    out:
      - id: output_vcf
    run: ../tools/vep_filter.cwl
    label: vep_filter
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
  - id: hotspot_vld_mutect
    in:
      - id: vcf_filter_config_A
        source: mutect_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_mutect
      - id: vcf_filter_config_B
        source: mutect_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_mutect
  - id: hotspot_vld_pindel
    in:
      - id: vcf_filter_config_A
        source: pindel_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_pindel
      - id: vcf_filter_config_B
        source: pindel_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_pindel
  - id: hotspot_vld_varscan_snv
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_varscan_snv
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_snv
  - id: hotspot_vld_varscan_indel
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_varscan_indel
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_indel
  - id: hotspot_vld_strelka_snv
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_strelka_snv
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_snv
  - id: hotspot_vld_strelka_indel
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_strelka_indel
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: Hotspot_BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_indel
requirements:
  - class: SubworkflowFeatureRequirement
