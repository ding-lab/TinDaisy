class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: no_delete_temp
    type: boolean?
    'sbg:x': 0
    'sbg:y': 1391
  - id: tumor_bam
    type: File
    'sbg:x': 0
    'sbg:y': 428
  - id: normal_bam
    type: File
    'sbg:x': 0
    'sbg:y': 1284
  - id: reference_fasta
    type: File
    'sbg:x': 0
    'sbg:y': 749
  - id: pindel_config
    type: File
    'sbg:x': 0
    'sbg:y': 963
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 321
  - id: bypass_cvs
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1489
  - id: bypass_homopolymer
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1275
  - id: debug
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 954
  - id: bypass_vaf
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1061
  - id: bypass_length
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1168
  - id: bypass_depth
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1382
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 856
  - id: bypass_merge
    type: boolean?
    'sbg:x': 1120.54833984375
    'sbg:y': 1140
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 1991.1295166015625
    'sbg:y': 1070
  - id: dbsnp_db
    type: File?
    'sbg:x': 1991.1295166015625
    'sbg:y': 963
  - id: assembly
    type: string?
    'sbg:x': 2216.452880859375
    'sbg:y': 963
  - id: vep_cache_version
    type: string?
    'sbg:x': 0
    'sbg:y': 0
  - id: vep_cache_gz
    type: File?
    'sbg:x': 0
    'sbg:y': 107
  - id: centromere_bed
    type: File?
    'sbg:x': 0
    'sbg:y': 1712
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 535
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 214
  - id: af_filter_config
    type: File
    'sbg:x': 2626.952880859375
    'sbg:y': 1123.5
  - id: classification_filter_config
    type: File
    'sbg:x': 2626.952880859375
    'sbg:y': 802.5
  - id: bypass_af
    type: boolean?
    'sbg:x': 2626.952880859375
    'sbg:y': 1016.5
  - id: bypass_classification
    type: boolean?
    'sbg:x': 2626.952880859375
    'sbg:y': 909.5
  - id: mutect_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 1498
  - id: strelka_config
    type: File
    'sbg:x': 0
    'sbg:y': 642
  - id: chrlist
    type: File?
    'sbg:x': 0
    'sbg:y': 1605
  - id: call_regions
    type: File?
    'sbg:x': 0
    'sbg:y': 1819
  - id: num_parallel_pindel
    type: int?
    'sbg:x': 0
    'sbg:y': 1177
  - id: num_parallel_strelka2
    type: int?
    'sbg:x': 0
    'sbg:y': 1070
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 3446.74609375
    'sbg:y': 963
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
    'sbg:x': 1991.1295166015625
    'sbg:y': 856
  - id: output_maf
    outputSource:
      - vcf2maf/output
    type: File?
    'sbg:x': 3468.54541015625
    'sbg:y': 718.3995971679688
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
    'sbg:x': 247.28125
    'sbg:y': 663
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
    'sbg:x': 247.28125
    'sbg:y': 309
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
    'sbg:x': 689.5953979492188
    'sbg:y': 1091
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
    'sbg:x': 689.5953979492188
    'sbg:y': 807
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
    'sbg:x': 689.5953979492188
    'sbg:y': 935
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
    'sbg:x': 1120.54833984375
    'sbg:y': 998
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
    'sbg:x': 696.9108276367188
    'sbg:y': 459.2952880859375
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
    'sbg:x': 1120.54833984375
    'sbg:y': 644
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
    'sbg:x': 1120.54833984375
    'sbg:y': 821
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
    'sbg:x': 1543.95458984375
    'sbg:y': 853.5
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
    'sbg:x': 2216.452880859375
    'sbg:y': 828
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
    'sbg:x': 2626.952880859375
    'sbg:y': 667.5
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
    'sbg:x': 2995.24609375
    'sbg:y': 828
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
    'sbg:x': 247.28125
    'sbg:y': 833
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
    'sbg:x': 247.28125
    'sbg:y': 472
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
    'sbg:x': 689.5953979492188
    'sbg:y': 679
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
    'sbg:x': 689.5953979492188
    'sbg:y': 1247
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
    'sbg:x': 1991.1295166015625
    'sbg:y': 742
  - id: vcf2maf
    in:
      - id: ref-fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: input-vcf
        source: vep_filter/output_vcf
    out:
      - id: output
    run: ../tools/vcf2maf.cwl
    label: vcf2maf
    'sbg:x': 3299.807861328125
    'sbg:y': 707.0283813476562
requirements: []
