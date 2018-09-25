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
    'sbg:x': 0
    'sbg:y': 320.53125
  - id: normal_bam
    type: File
    'sbg:x': 0
    'sbg:y': 961.59375
  - id: reference_fasta
    type: File
    'sbg:x': 0
    'sbg:y': 641.0625
  - id: strelka_config
    type: File
    'sbg:x': 0
    'sbg:y': 534.21875
  - id: pindel_config
    type: File
    'sbg:x': 0
    'sbg:y': 854.75
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 213.6875
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
  - id: bypass_depth
    type: boolean?
    'sbg:exposed': true
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 747.90625
  - id: bypass_merge
    type: boolean?
    'sbg:exposed': true
  - id: bypass_dbsnp
    type: boolean?
    'sbg:exposed': true
  - id: dbsnp_db
    type: File?
    'sbg:x': 1223.008544921875
    'sbg:y': 587.640625
  - id: assembly
    type: string?
    'sbg:exposed': true
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: vep_cache_gz
    'sbg:fileTypes': .tar.gz
    type: File?
    'sbg:x': 1563.0543212890625
    'sbg:y': 225.65220642089844
  - id: centromere_bed
    type: File?
    'sbg:x': 0
    'sbg:y': 1068.4375
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 427.375
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 106.84375
  - id: af_filter_config
    type: File
    'sbg:x': 1843.500732421875
    'sbg:y': 641.0625
  - id: classification_filter_config
    type: File
    'sbg:x': 1843.500732421875
    'sbg:y': 534.21875
  - id: bypass_af
    type: boolean?
    'sbg:exposed': true
  - id: bypass_classification
    type: boolean?
    'sbg:exposed': true
outputs:
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File
    'sbg:x': 2773.22119140625
    'sbg:y': 534.21875
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2528.58544921875
    'sbg:y': 587.640625
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
    'sbg:x': 247.265625
    'sbg:y': 662.0625
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
    'sbg:x': 247.265625
    'sbg:y': 506.21875
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
    'sbg:x': 247.265625
    'sbg:y': 357.375
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
    run: ./parse_pindel.cwl
    label: parse_pindel
    'sbg:x': 555.64306640625
    'sbg:y': 715.484375
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
    'sbg:x': 555.64306640625
    'sbg:y': 459.796875
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
    'sbg:x': 555.64306640625
    'sbg:y': 587.640625
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
    run: ./vaf_length_depth_filters.cwl
    label: Pindel VAF Length Depth
    'sbg:x': 889.3258056640625
    'sbg:y': 648.0625
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
      - id: vcf_filter_config
        source: strelka_vcf_filter_config
      - id: bypass_depth
        source: bypass_depth
    out:
      - id: filtered_vcf
    run: ./vaf_length_depth_filters.cwl
    label: Strelka SNV VAF Length Depth
    'sbg:x': 555.64306640625
    'sbg:y': 331.953125
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
    run: ./vaf_length_depth_filters.cwl
    label: Varscan SNV VAF Length Depth
    'sbg:x': 889.3258056640625
    'sbg:y': 406.375
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
    run: ./vaf_length_depth_filters.cwl
    label: Varscan indel VAF Length Depth
    'sbg:x': 889.3258056640625
    'sbg:y': 527.21875
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
    'sbg:x': 1223.008544921875
    'sbg:y': 452.796875
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
    'sbg:x': 1522.864501953125
    'sbg:y': 520.21875
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
    'sbg:x': 1843.500732421875
    'sbg:y': 413.375
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
    'sbg:x': 2125.37109375
    'sbg:y': 520.21875
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
    out:
      - id: output_maf
    run: ./vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 2390.99267578125
    'sbg:y': 462.7894592285156
requirements: []
