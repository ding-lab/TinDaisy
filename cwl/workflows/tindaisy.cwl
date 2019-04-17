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
    'sbg:y': 1174.59375
  - id: tumor_bam
    type: File
    'sbg:x': 0
    'sbg:y': 427.125
  - id: normal_bam
    type: File
    'sbg:x': 0
    'sbg:y': 1067.8125
  - id: reference_fasta
    type: File
    'sbg:x': 0
    'sbg:y': 747.46875
  - id: pindel_config
    type: File
    'sbg:x': 0
    'sbg:y': 961.03125
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 320.34375
  - id: bypass_cvs
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1123.8125
  - id: bypass_homopolymer
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 910.25
  - id: debug
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 589.90625
  - id: bypass_vaf
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 696.6875
  - id: bypass_length
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 803.46875
  - id: bypass_depth
    type: boolean?
    'sbg:x': 247.28125
    'sbg:y': 1017.03125
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 854.25
  - id: bypass_merge
    type: boolean?
    'sbg:x': 1004.5568237304688
    'sbg:y': 870.859375
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
  - id: centromere_bed
    type: File?
    'sbg:x': 0
    'sbg:y': 1281.375
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 533.90625
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 213.5625
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
  - id: mutect_vcf_filter_config
    type: File
    'sbg:x': 6.4631853103637695
    'sbg:y': 83.9405517578125
  - id: strelka_config
    type: File
    'sbg:x': -7.595465660095215
    'sbg:y': -84.29430389404297
  - id: chrlist
    type: File?
    'sbg:x': -53.45024871826172
    'sbg:y': 664.668701171875
  - id: num_parallel_pindel
    type: int?
    'sbg:exposed': true
  - id: num_parallel_strelka2
    type: int?
    'sbg:exposed': true
outputs:
  - id: output_maf
    outputSource:
      vcf_2_maf/output_maf
    type: File
    'sbg:x': 3463.528076171875
    'sbg:y': 640.6875
  - id: output_vcf
    outputSource:
      vep_filter/output_vcf
    type: File
    'sbg:x': 3091.59423828125
    'sbg:y': 694.078125
  - id: merged_vcf
    outputSource:
      merge_vcf/merged_vcf
    type: File
    'sbg:x': 1844.6331787109375
    'sbg:y': 41.628971099853516
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
    'sbg:y': 448.1250305175781
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
    'sbg:y': 136.56253051757812
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
    'sbg:x': 573.6038208007812
    'sbg:y': 821.859375
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
    'sbg:x': 573.6038208007812
    'sbg:y': 538.296875
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
    'sbg:x': 573.6038208007812
    'sbg:y': 666.078125
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
    'sbg:x': 1004.5568237304688
    'sbg:y': 729.078125
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
    'sbg:x': 1019.2607421875
    'sbg:y': -88.8577651977539
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
    'sbg:x': 1004.5568237304688
    'sbg:y': 375.5156555175781
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
    'sbg:x': 1004.5568237304688
    'sbg:y': 552.296875
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
    'sbg:x': 1502.548095703125
    'sbg:y': 158.9398651123047
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: merge_vcf/merged_vcf
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
    'sbg:x': 226.59056091308594
    'sbg:y': -297.95751953125
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
    out:
      - id: strelka2_snv_vcf
      - id: strelka2_indel_vcf
    run: ../tools/run_strelka2.cwl
    label: run_strelka2
    'sbg:x': 223.633056640625
    'sbg:y': -81.21533966064453
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
    'sbg:x': 1021
    'sbg:y': -246.59422302246094
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
    'sbg:x': 1020
    'sbg:y': -438.0108947753906
requirements: []
