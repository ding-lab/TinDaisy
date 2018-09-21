class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: no_delete_temp
    type: boolean?
    'sbg:exposed': true
  - id: tumor_bam
    type: File
    'sbg:x': -640.7837524414062
    'sbg:y': -138.4971160888672
  - id: normal_bam
    type: File
    'sbg:x': -638.7837524414062
    'sbg:y': 17.501800537109375
  - id: results_dir
    type: string?
    'sbg:x': -631.7837524414062
    'sbg:y': -299.4981994628906
  - id: reference_fasta
    type: File
    'sbg:x': -635.7837524414062
    'sbg:y': 204.4996337890625
  - id: strelka_config
    type: File
    'sbg:x': -368.78375244140625
    'sbg:y': -116.50035858154297
  - id: pindel_config
    type: File
    'sbg:x': -414.78375244140625
    'sbg:y': -345.4902648925781
  - id: varscan_config
    type: File
    'sbg:x': -380.7447814941406
    'sbg:y': 132.09413146972656
  - id: no_delete_temp_1
    type: boolean?
    'sbg:exposed': true
  - id: bypass
    type: boolean?
    'sbg:exposed': true
  - id: bypass_cvs
    type: boolean?
    'sbg:exposed': true
  - id: bypass_homopolymer
    type: boolean?
    'sbg:exposed': true
  - id: debug
    type: boolean?
    'sbg:exposed': true
  - id: bypass_1
    type: boolean?
    'sbg:exposed': true
  - id: bypass_vaf
    type: boolean?
    'sbg:exposed': true
  - id: bypass_length
    type: boolean?
    'sbg:exposed': true
  - id: debug_1
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf
    type: string
    'sbg:exposed': true
  - id: caller
    type: string
    'sbg:exposed': true
  - id: bypass_depth
    type: boolean?
    'sbg:exposed': true
  - id: bypass_2
    type: boolean?
    'sbg:exposed': true
  - id: bypass_vaf_1
    type: boolean?
    'sbg:exposed': true
  - id: bypass_length_1
    type: boolean?
    'sbg:exposed': true
  - id: debug_2
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_1
    type: string
    'sbg:exposed': true
  - id: caller_1
    type: string
    'sbg:exposed': true
  - id: bypass_depth_1
    type: boolean?
    'sbg:exposed': true
  - id: bypass_3
    type: boolean?
    'sbg:exposed': true
  - id: bypass_vaf_2
    type: boolean?
    'sbg:exposed': true
  - id: bypass_length_2
    type: boolean?
    'sbg:exposed': true
  - id: debug_3
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_2
    type: string
    'sbg:exposed': true
  - id: caller_2
    type: string
    'sbg:exposed': true
  - id: bypass_depth_2
    type: boolean?
    'sbg:exposed': true
  - id: bypass_4
    type: boolean?
    'sbg:exposed': true
  - id: bypass_vaf_3
    type: boolean?
    'sbg:exposed': true
  - id: bypass_length_3
    type: boolean?
    'sbg:exposed': true
  - id: debug_4
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_3
    type: string
    'sbg:exposed': true
  - id: caller_3
    type: string
    'sbg:exposed': true
  - id: bypass_depth_3
    type: boolean?
    'sbg:exposed': true
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': -31.71896743774414
    'sbg:y': -374.38299560546875
  - id: vcf_filter_config
    type: File
    'sbg:x': 34.839473724365234
    'sbg:y': -41.590789794921875
  - id: debug_5
    type: boolean?
    'sbg:exposed': true
  - id: bypass_merge
    type: boolean?
    'sbg:exposed': true
  - id: bypass_dbsnp
    type: boolean?
    'sbg:exposed': true
  - id: debug_6
    type: boolean?
    'sbg:exposed': true
  - id: dbsnp_db
    type: File?
    'sbg:x': 533.4241943359375
    'sbg:y': 478.34478759765625
  - id: assembly
    type: string?
    'sbg:exposed': true
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: bypass_5
    type: boolean?
    'sbg:exposed': true
  - id: bypass_af
    type: boolean?
    'sbg:exposed': true
  - id: bypass_classification
    type: boolean?
    'sbg:exposed': true
  - id: debug_7
    type: boolean?
    'sbg:exposed': true
  - id: af_filter_config
    type: File
    'sbg:x': 816.3441162109375
    'sbg:y': 525.7122802734375
  - id: classification_filter_config
    type: File
    'sbg:x': 794.95068359375
    'sbg:y': 406.7112121582031
  - id: vep_cache_gz
    'sbg:fileTypes': .tar.gz
    type: File?
    'sbg:x': 855.1481323242188
    'sbg:y': -110.74287414550781
  - id: assembly_1
    type: string?
    'sbg:exposed': true
  - id: vep_cache_version_1
    type: string?
    'sbg:exposed': true
outputs:
  - id: output_dat
    outputSource:
      - annotate_vep/output_dat
    type: File
    'sbg:x': 1148.010986328125
    'sbg:y': -54.57110595703125
  - id: output_dat_1
    outputSource:
      - vcf_2_maf/output_dat
    type: File
    'sbg:x': 1442.2681884765625
    'sbg:y': 230.23907470703125
steps:
  - id: run_pindel
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: no_delete_temp
        source: no_delete_temp
      - id: results_dir
        source: results_dir
      - id: pindel_config
        source: pindel_config
    out:
      - id: pindel_raw
    run: ./run_pindel.cwl
    label: run_pindel
    'sbg:x': -275.3984375
    'sbg:y': -230
  - id: run_strelka
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_config
        source: strelka_config
      - id: results_dir
        source: results_dir
    out:
      - id: snvs_passed
    run: ./run_strelka.cwl
    label: run_strelka
    'sbg:x': -287.39886474609375
    'sbg:y': 10
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
      - id: results_dir
        source: results_dir
    out:
      - id: varscan_indel_raw
      - id: varscan_snv_raw
    run: ./run_varscan.cwl
    label: run_varscan
    'sbg:x': -288.39886474609375
    'sbg:y': 242
  - id: parse_pindel
    in:
      - id: pindel_raw
        source: run_pindel/pindel_raw
      - id: reference_fasta
        source: reference_fasta
      - id: pindel_config
        source: pindel_config
      - id: results_dir
        source: results_dir
      - id: no_delete_temp
        source: no_delete_temp_1
      - id: bypass
        source: bypass
      - id: bypass_cvs
        source: bypass_cvs
      - id: bypass_homopolymer
        source: bypass_homopolymer
      - id: debug
        source: debug
    out:
      - id: pindel_dbsnp
    run: ./parse_pindel.cwl
    label: parse_pindel
    'sbg:x': -8.991544723510742
    'sbg:y': -199.07469177246094
  - id: parse_varscan_snv
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source: run_varscan/varscan_snv_raw
      - id: varscan_config
        source: varscan_config
      - id: results_dir
        source: results_dir
    out:
      - id: varscan_snv_dbsnp
    run: ./parse_varscan_snv.cwl
    label: parse_varscan_snv
    'sbg:x': -21.978710174560547
    'sbg:y': 224.62661743164062
  - id: parse_varscan_indel
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_config
        source: varscan_config
      - id: results_dir
        source: results_dir
    out:
      - id: varscan_indel_dbsnp
    run: ./parse_varscan_indel.cwl
    label: parse_varscan_indel
    'sbg:x': -22.610389709472656
    'sbg:y': 384.4934997558594
  - id: vaf_length_depth_filters
    in:
      - id: results_dir
        source: results_dir
      - id: bypass
        source: bypass_1
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug_1
      - id: input_vcf
        source: parse_pindel/pindel_dbsnp
      - id: output_vcf
        source: output_vcf
      - id: caller
        source: caller
      - id: vcf_filter_config
        source: pindel_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters
    'sbg:x': 229.64466857910156
    'sbg:y': -169.85391235351562
  - id: vaf_length_depth_filters_1
    in:
      - id: results_dir
        source: results_dir
      - id: bypass
        source: bypass_2
      - id: bypass_vaf
        source: bypass_vaf_1
      - id: bypass_length
        source: bypass_length_1
      - id: debug
        source: debug_2
      - id: input_vcf
        source: run_strelka/snvs_passed
      - id: output_vcf
        source: output_vcf_1
      - id: caller
        source: caller_1
      - id: vcf_filter_config
        source: vcf_filter_config
      - id: bypass_depth
        source: bypass_depth_1
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters
    'sbg:x': 247.50181579589844
    'sbg:y': 63.91232681274414
  - id: vaf_length_depth_filters_2
    in:
      - id: results_dir
        source: results_dir
      - id: bypass
        source: bypass_3
      - id: bypass_vaf
        source: bypass_vaf_2
      - id: bypass_length
        source: bypass_length_2
      - id: debug
        source: debug_3
      - id: input_vcf
        source: parse_varscan_snv/varscan_snv_dbsnp
      - id: output_vcf
        source: output_vcf_2
      - id: caller
        source: caller_2
      - id: vcf_filter_config
        source: vcf_filter_config
      - id: bypass_depth
        source: bypass_depth_2
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters
    'sbg:x': 223.1511688232422
    'sbg:y': 247.3538818359375
  - id: vaf_length_depth_filters_3
    in:
      - id: results_dir
        source: results_dir
      - id: bypass
        source: bypass_4
      - id: bypass_vaf
        source: bypass_vaf_3
      - id: bypass_length
        source: bypass_length_3
      - id: debug
        source: debug_4
      - id: input_vcf
        source: parse_varscan_indel/varscan_indel_dbsnp
      - id: output_vcf
        source: output_vcf_3
      - id: caller
        source: caller_3
      - id: vcf_filter_config
        source: vcf_filter_config
      - id: bypass_depth
        source: bypass_depth_3
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: vaf_length_depth_filters
    'sbg:x': 239.3849334716797
    'sbg:y': 416.18505859375
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: vaf_length_depth_filters_1/filtered_vcf
      - id: varscan_indel_vcf
        source: vaf_length_depth_filters_3/filtered_vcf
      - id: varscan_snv_vcf
        source: vaf_length_depth_filters_2/filtered_vcf
      - id: pindel_vcf
        source: vaf_length_depth_filters/filtered_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: results_dir
        source: results_dir
      - id: bypass_merge
        source: bypass_merge
      - id: debug
        source: debug_5
    out:
      - id: merged_vcf
    run: ./merge_vcf.cwl
    label: merge_vcf
    'sbg:x': 546.203125
    'sbg:y': 125.60285949707031
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: merge_vcf/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: results_dir
        source: results_dir
      - id: bypass_dbsnp
        source: bypass_dbsnp
      - id: debug
        source: debug_6
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: merged_vcf
    run: ./dbsnp_filter.cwl
    label: dbsnp_filter
    'sbg:x': 779.2794799804688
    'sbg:y': 148.43875122070312
  - id: annotate_vep
    in:
      - id: input_vcf
        source: dbsnp_filter/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: results_dir
        source: results_dir
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: bypass
        source: bypass_5
      - id: af_filter_config
        source: af_filter_config
      - id: classification_filter_config
        source: classification_filter_config
      - id: bypass_af
        source: bypass_af
      - id: bypass_classification
        source: bypass_classification
      - id: debug
        source: debug_7
    out:
      - id: output_dat
    run: ./vep_annotate.cwl
    label: vep_annotate
    'sbg:x': 1010.4227905273438
    'sbg:y': 190.464599609375
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: annotate_vep/output_dat
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly_1
      - id: vep_cache_version
        source: vep_cache_version_1
      - id: results_dir
        source: results_dir
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_dat
    run: ./vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 1234.921875
    'sbg:y': 228.89212036132812
requirements: []
