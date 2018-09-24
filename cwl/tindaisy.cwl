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
  - id: reference_fasta
    type: File
    'sbg:x': -635.7837524414062
    'sbg:y': 204.4996337890625
  - id: strelka_config
    type: File
    'sbg:x': -680.761474609375
    'sbg:y': -292.0731201171875
  - id: pindel_config
    type: File
    'sbg:x': -414.78375244140625
    'sbg:y': -345.4902648925781
  - id: varscan_config
    type: File
    'sbg:x': -597.774658203125
    'sbg:y': 400.7431640625
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
  - id: bypass_vaf
    type: boolean?
    'sbg:exposed': true
  - id: bypass_length
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_pindel
    type: string?
    'sbg:exposed': true
  - id: caller_pindel
    type: string?
    'sbg:exposed': true
  - id: bypass_depth
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_strelka
    type: string?
    'sbg:exposed': true
  - id: caller_strelka
    type: string?
    'sbg:exposed': true
  - id: bypass_3
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_varscan_snv
    type: string?
    'sbg:exposed': true
  - id: caller_varscan
    type: string?
    'sbg:exposed': true
  - id: bypass_4
    type: boolean?
    'sbg:exposed': true
  - id: output_vcf_varscan_indel
    type: string?
    'sbg:exposed': true
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': -31.71896743774414
    'sbg:y': -374.38299560546875
  - id: bypass_merge
    type: boolean?
    'sbg:exposed': true
  - id: bypass_dbsnp
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
  - id: bypass_af
    type: boolean?
    'sbg:exposed': true
  - id: classification_filter_config
    type: File
    'sbg:x': 794.95068359375
    'sbg:y': 406.7112121582031
  - id: vep_cache_gz
    'sbg:fileTypes': .tar.gz
    type: File?
    'sbg:x': 855.1481323242188
    'sbg:y': -110.74287414550781
  - id: af_filter_config
    type: File
    'sbg:x': 778.2200317382812
    'sbg:y': 534.7636108398438
  - id: centromere_bed
    type: File?
    'sbg:x': -659.09375
    'sbg:y': -415.9898681640625
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 35.598453521728516
    'sbg:y': -27.433225631713867
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 37.95334243774414
    'sbg:y': 719.0504150390625
outputs:
  - id: output_dat_1
    outputSource:
      - vcf_2_maf/output_dat
    type: File
    'sbg:x': 1708.0706787109375
    'sbg:y': 227.937255859375
  - id: output_dat
    outputSource:
      - vep_filter/output_dat
    type: File
    'sbg:x': 1459.08984375
    'sbg:y': 454.402587890625
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
    out:
      - id: strelka_vcf
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
      - id: no_delete_temp
        source: no_delete_temp
      - id: bypass
        source: bypass
      - id: bypass_cvs
        source: bypass_cvs
      - id: bypass_homopolymer
        source: bypass_homopolymer
      - id: debug
        source: debug
    out:
      - id: pindel_vcf
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
    out:
      - id: varscan_snv
    run: ./parse_varscan_snv.cwl
    label: parse_varscan_snv
    'sbg:x': -14.049745559692383
    'sbg:y': 288.8690490722656
  - id: parse_varscan_indel
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel
    run: ./parse_varscan_indel.cwl
    label: parse_varscan_indel
    'sbg:x': -38.21725845336914
    'sbg:y': 476.6700744628906
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
      - id: output_vcf
        default: pindel.indel.vcf
        source: output_vcf_pindel
      - id: caller
        default: pindel
        source: caller_pindel
      - id: vcf_filter_config
        source: pindel_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: Pindel VAF Length Depth
    'sbg:x': 229.64466857910156
    'sbg:y': -169.85391235351562
  - id: strelka_vaf_length_depth_filters
    in:
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: run_strelka/strelka_vcf
      - id: output_vcf
        default: strelka.snv.vcf
        source: output_vcf_strelka
      - id: caller
        default: strelka
        source: caller_strelka
      - id: vcf_filter_config
        source: strelka_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: Strelka SNV VAF Length Depth
    'sbg:x': 247.50181579589844
    'sbg:y': 63.91232681274414
  - id: varscan_snv_vaf_length_depth_filters
    in:
      - id: bypass
        source: bypass_3
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: parse_varscan_snv/varscan_snv
      - id: output_vcf
        default: varscan.snv.vcf
        source: output_vcf_varscan_snv
      - id: caller
        default: varscan
        source: caller_varscan
      - id: vcf_filter_config
        source: varscan_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: Varscan SNV VAF Length Depth
    'sbg:x': 223.1511688232422
    'sbg:y': 247.3538818359375
  - id: varscan_indel_vaf_length_depth_filters
    in:
      - id: bypass
        source: bypass_4
      - id: bypass_vaf
        source: bypass_vaf
      - id: bypass_length
        source: bypass_length
      - id: debug
        source: debug
      - id: input_vcf
        source: parse_varscan_indel/varscan_indel
      - id: output_vcf
        default: varscan.indel.vcf
        source: output_vcf_varscan_indel
      - id: caller
        default: varscan
        source: caller_varscan
      - id: vcf_filter_config
        source: varscan_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: Varscan indel VAF Length Depth
    'sbg:x': 239.3849334716797
    'sbg:y': 416.18505859375
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
    'sbg:x': 779.2794799804688
    'sbg:y': 148.43875122070312
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
    'sbg:x': 1010.4227905273438
    'sbg:y': 190.464599609375
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: vep_filter/output_dat
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
    run: ./vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 1448.525146484375
    'sbg:y': 234.188232421875
  - id: vep_filter
    in:
      - id: input_vcf
        source: vep_annotate/output_dat
      - id: af_filter_config
        source: af_filter_config
      - id: classification_filter_config
        source: classification_filter_config
    out:
      - id: output_dat
    run: ./vep_filter.cwl
    label: vep_filter
    'sbg:x': 1229.893798828125
    'sbg:y': 338.4498596191406
requirements: []
