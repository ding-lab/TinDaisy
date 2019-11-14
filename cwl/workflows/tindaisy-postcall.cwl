class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
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
  - id: bypass_cvs
    type: boolean?
  - id: bypass_homopolymer
    type: boolean?
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
  - id: bypass_af
    type: boolean?
  - id: bypass_classification
    type: boolean?
  - id: bypass_vcf2maf
    type: boolean?
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
      - id: bypass_cvs
        source: bypass_cvs
      - id: bypass_homopolymer
        source: bypass_homopolymer
      - id: debug
        source: debug
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
  - id: pindel_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: parse_pindel/pindel_vcf
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
        source: run_strelka2/strelka2_snv_vcf
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
        source: parse_varscan_snv/varscan_snv
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
        source: parse_varscan_indel/varscan_indel
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
      - id: num_parallel_strelka2
        source: num_parallel_strelka2
      - id: call_regions
        source: call_regions
    out:
      - id: strelka2_snv_vcf
      - id: strelka2_indel_vcf
    run: ../tools/run_strelka2.cwl
    label: run_strelka2
  - id: strelka_indel_vaf_length_depth
    in:
      - id: input_vcf
        source: run_strelka2/strelka2_indel_vcf
      - id: vcf_filter_config
        source: strelka_vcf_filter_config
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: Strelka Indel vaf_length_depth
  - id: mutect_vaf_length_depth
    in:
      - id: input_vcf
        source: mutect/mutations
      - id: vcf_filter_config
        source: mutect_vcf_filter_config
    out:
      - id: filtered_vcf
    run: ../tools/vaf_length_depth_filters.cwl
    label: mutect vaf_length_depth
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
