class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy-Hotspot
inputs:
  - id: no_delete_temp
    type: boolean?
  - id: tumor_bam
    type: File
  - id: normal_bam
    type: File
  - id: reference_fasta
    type: File
  - id: pindel_config
    type: File
  - id: varscan_config
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
  - id: centromere_bed
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
  - id: strelka_config
    type: File
  - id: chrlist
    type: File?
  - id: call_regions
    type: File?
  - id: num_parallel_pindel
    type: int?
  - id: num_parallel_strelka2
    type: int?
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: BED
    type: File
  - id: mutect_vcf_filter_config_A
    type: File
  - id: pindel_vcf_filter_config_A
    type: File
  - id: varscan_vcf_filter_config_A
    type: File
  - id: strelka_vcf_filter_config_A
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
  - id: run_pindel
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: centromere_bed
        source: centromere_bed
      - id: no_delete_temp
        source: no_delete_temp
      - id: pindel_config
        source: pindel_config
      - id: chrlist
        source: chrlist
      - id: num_parallel_pindel
        source: num_parallel_pindel
    out:
      - id: pindel_raw
    run: ../tools/run_pindel.cwl
    label: run_pindel
  - id: run_varscan
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel_raw
      - id: varscan_snv_raw
    run: ../tools/run_varscan.cwl
    label: run_varscan
  - id: parse_pindel
    in:
      - id: pindel_raw
        source: run_pindel/pindel_raw
      - id: reference_fasta
        source: reference_fasta
      - id: pindel_config
        source: pindel_config
      - id: no_delete_temp
        source: no_delete_temp
    out:
      - id: pindel_vcf
    run: ../tools/parse_pindel.cwl
    label: parse_pindel
  - id: parse_varscan_snv
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source: run_varscan/varscan_snv_raw
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_snv
    run: ../tools/parse_varscan_snv.cwl
    label: parse_varscan_snv
  - id: parse_varscan_indel
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel
    run: ../tools/parse_varscan_indel.cwl
    label: parse_varscan_indel
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
  - id: mutect
    in:
      - id: normal
        source: normal_bam
      - id: reference
        source: reference_fasta
      - id: tumor
        source: tumor_bam
    out:
      - id: call_stats
      - id: coverage
      - id: mutations
    run: ../mutect-tool/cwl/mutect.cwl
    label: MuTect
  - id: run_strelka2
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_config
        source: strelka_config
      - id: call_regions
        source: call_regions
      - id: num_parallel_strelka2
        source: num_parallel_strelka2
    out:
      - id: strelka2_snv_vcf
      - id: strelka2_indel_vcf
    run: ../tools/run_strelka2.cwl
    label: run_strelka2
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
  - id: varscan_indel_vcf_remap
    in:
      - id: input
        source: parse_varscan_indel/varscan_indel
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_indel_vcf_remap
  - id: varscan_snv_vcf_remap
    in:
      - id: input
        source: parse_varscan_snv/varscan_snv
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_snv_vcf_remap
  - id: hotspot_vld_mutect
    in:
      - id: vcf_filter_config_A
        source: mutect_vcf_filter_config_A
      - id: input_vcf
        source: mutect/mutations
      - id: vcf_filter_config_B
        source: mutect_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_mutect
  - id: hotspot_vld_pindel
    in:
      - id: vcf_filter_config_A
        source: pindel_vcf_filter_config_A
      - id: input_vcf
        source: parse_pindel/pindel_vcf
      - id: vcf_filter_config_B
        source: pindel_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_pindel
  - id: hotspot_vld_varscan_snv
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: varscan_snv_vcf_remap/remapped_VCF
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_snv
  - id: hotspot_vld_varscan_indel
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: varscan_indel_vcf_remap/remapped_VCF
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_indel
  - id: hotspot_vld_strelka_snv
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: run_strelka2/strelka2_snv_vcf
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_snv
  - id: hotspot_vld_strelka_indel
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: run_strelka2/strelka2_indel_vcf
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_indel
requirements:
  - class: SubworkflowFeatureRequirement
