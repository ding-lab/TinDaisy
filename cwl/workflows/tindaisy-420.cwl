class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': 0
    'sbg:y': 533.359375
  - id: normal_bam
    type: File
    'sbg:x': 0
    'sbg:y': 959.671875
  - id: reference_fasta
    type: File
    'sbg:x': -4.513847351074219
    'sbg:y': -124.12403869628906
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 426.703125
  - id: debug
    type: boolean?
    'sbg:x': 247.296875
    'sbg:y': 493.578125
  - id: bypass_vaf
    type: boolean?
    'sbg:x': 247.296875
    'sbg:y': 600.3125
  - id: bypass_length
    type: boolean?
    'sbg:x': 247.296875
    'sbg:y': 707.046875
  - id: bypass_depth
    type: boolean?
    'sbg:x': 247.296875
    'sbg:y': 813.78125
  - id: bypass_merge
    type: boolean?
    'sbg:x': 532.515625
    'sbg:y': 646.859375
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 1403.0966796875
    'sbg:y': 693.1484375
  - id: dbsnp_db
    type: File?
    'sbg:x': 1403.0966796875
    'sbg:y': 586.4921875
  - id: assembly
    type: string?
    'sbg:x': 1628.419921875
    'sbg:y': 667.78125
  - id: vep_cache_version
    type: string?
    'sbg:x': 0
    'sbg:y': 0
  - id: vep_cache_gz
    type: File?
    'sbg:x': 0
    'sbg:y': 106.65625
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 213.390625
  - id: af_filter_config
    type: File
    'sbg:x': 2038.9200439453125
    'sbg:y': 746.59375
  - id: classification_filter_config
    type: File
    'sbg:x': 2038.9200439453125
    'sbg:y': 426.390625
  - id: bypass_af
    type: boolean?
    'sbg:x': 2038.9200439453125
    'sbg:y': 639.859375
  - id: bypass_classification
    type: boolean?
    'sbg:x': 2038.9200439453125
    'sbg:y': 533.125
  - id: mutect_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 1066.328125
  - id: varscan_indel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 320.046875
  - id: strelka_snv_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 639.9375
  - id: strelka_indel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 746.515625
  - id: pindel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 853.09375
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2858.71337890625
    'sbg:y': 586.4921875
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
    'sbg:x': 1403.0966796875
    'sbg:y': 479.8359375
  - id: output_maf
    outputSource:
      - vcf2maf/output
    type: File?
    'sbg:x': 3057.43212890625
    'sbg:y': 533.203125
steps:
  - id: parse_varscan_snv
    in:
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_snv
    run: ../tools/parse_varscan_snv.cwl
    label: parse_varscan_snv
    'sbg:x': 247.296875
    'sbg:y': 238.546875
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
    'sbg:x': 532.515625
    'sbg:y': 384.390625
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_snv_vcf
      - id: varscan_indel_vcf
        source: varscan_indel_vcf
      - id: varscan_snv_vcf
        source: varscan_snv_vaf_length_depth_filters/filtered_vcf
      - id: pindel_vcf
        source: pindel_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_merge
        source: bypass_merge
      - id: debug
        source: debug
      - id: strelka_indel_vcf
        source: strelka_indel_vcf
      - id: mutect_vcf
        source: mutect_vaf_length_depth/filtered_vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: merge_vcf
    'sbg:x': 1018.9041748046875
    'sbg:y': 537.0350952148438
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
    'sbg:x': 1628.419921875
    'sbg:y': 533.125
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
    'sbg:x': 2038.9200439453125
    'sbg:y': 291.734375
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
    'sbg:x': 2407.21337890625
    'sbg:y': 505.203125
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
    'sbg:x': 247.296875
    'sbg:y': 373.0234375
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
    'sbg:x': 532.515625
    'sbg:y': 533.125
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
    'sbg:x': 1403.0966796875
    'sbg:y': 366.1796875
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
    'sbg:x': 2858.71337890625
    'sbg:y': 466.015625
requirements: []
