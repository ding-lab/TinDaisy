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
    'sbg:x': -167.82557678222656
    'sbg:y': 413.5559387207031
  - id: normal_bam
    type: File
    'sbg:x': -176.10528564453125
    'sbg:y': 567.5147705078125
  - id: reference_fasta
    type: File
    'sbg:x': -176.10528564453125
    'sbg:y': 709.7911376953125
  - id: strelka_config
    type: File
    'sbg:x': 2.7516443729400635
    'sbg:y': 168.03123474121094
  - id: pindel_config
    type: File
    'sbg:x': -16.509870529174805
    'sbg:y': 837.4901123046875
  - id: varscan_config
    type: File
    'sbg:x': -16.509870529174805
    'sbg:y': 284.54278564453125
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
    'sbg:x': 553.0806884765625
    'sbg:y': 903.8436889648438
  - id: bypass_merge
    type: boolean?
    'sbg:exposed': true
  - id: bypass_dbsnp
    type: boolean?
    'sbg:exposed': true
  - id: dbsnp_db
    type: File?
    'sbg:x': 1223
    'sbg:y': 644.7845458984375
  - id: assembly
    type: string?
    'sbg:exposed': true
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: vep_cache_gz
    'sbg:fileTypes': .tar.gz
    type: File?
    'sbg:x': 1452.9342041015625
    'sbg:y': 277.28125
  - id: centromere_bed
    type: File?
    'sbg:x': -22.013160705566406
    'sbg:y': 968.9407958984375
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 542.0740356445312
    'sbg:y': 94.05094909667969
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 547.5773315429688
    'sbg:y': 243.58224487304688
  - id: af_filter_config
    type: File
    'sbg:x': 1691.6595458984375
    'sbg:y': 674.0197143554688
  - id: classification_filter_config
    type: File
    'sbg:x': 1680.6529541015625
    'sbg:y': 534
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
    'sbg:x': 2420.78955078125
    'sbg:y': 459.7055969238281
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2208.80908203125
    'sbg:y': 661.29443359375
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
    'sbg:x': 244.24835205078125
    'sbg:y': 252.84866333007812
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
    'sbg:x': 247
    'sbg:y': 472.569091796875
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
    'sbg:x': 874.1907958984375
    'sbg:y': 264.96051025390625
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
    'sbg:x': 1461.4638671875
    'sbg:y': 492.4835510253906
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
    'sbg:x': 1688.9078369140625
    'sbg:y': 385.4835510253906
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
    'sbg:x': 1981.9144287109375
    'sbg:y': 520
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
    'sbg:x': 2205.639892578125
    'sbg:y': 459.24835205078125
requirements: []
