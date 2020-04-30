class: Workflow
cwlVersion: v1.0
id: tindaisy
label: Restart-TinDaisy-Hotspot
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': 0
    'sbg:y': 426.96875
  - id: reference_fasta
    type: File
    'sbg:x': 1083.9287109375
    'sbg:y': 466.359375
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 853.953125
  - id: dbsnp_db
    type: File?
    'sbg:x': 858.6053466796875
    'sbg:y': 640.453125
  - id: assembly
    type: string?
    'sbg:x': 1083.9287109375
    'sbg:y': 707.8125
  - id: vep_cache_version
    type: string?
    'sbg:x': 0
    'sbg:y': 0
  - id: vep_cache_gz
    type: File?
    'sbg:x': 0
    'sbg:y': 106.734375
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 640.453125
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 320.234375
  - id: af_filter_config
    type: File
    'sbg:x': 1400.00244140625
    'sbg:y': 693.828125
  - id: classification_filter_config
    type: File
    'sbg:x': 1400.00244140625
    'sbg:y': 587.078125
  - id: mutect_vcf_filter_config
    type: File
    'sbg:x': 0
    'sbg:y': 1067.453125
  - id: tumor_barcode
    type: string?
    'sbg:x': 1768.295654296875
    'sbg:y': 587.09375
  - id: normal_barcode
    type: string?
    'sbg:x': 1768.295654296875
    'sbg:y': 693.8125
  - id: BED
    type: File
    'sbg:x': 0
    'sbg:y': 1174.1875
  - id: mutect_vcf_filter_config_A
    type: File
    'sbg:x': 0
    'sbg:y': 960.703125
  - id: pindel_vcf_filter_config_A
    type: File
    'sbg:x': 0
    'sbg:y': 747.203125
  - id: varscan_vcf_filter_config_A
    type: File
    'sbg:x': 0
    'sbg:y': 213.484375
  - id: strelka_vcf_filter_config_A
    type: File
    'sbg:x': 0
    'sbg:y': 533.703125
  - id: input_vcf_varscan_snv
    type: File
    'sbg:x': -256.2572326660156
    'sbg:y': 208.26156616210938
  - id: input_vcf_varscan_indel
    type: File
    'sbg:x': -239.144775390625
    'sbg:y': 421.21649169921875
  - id: input_vcf_strelka_snv
    type: File
    'sbg:x': -246.75030517578125
    'sbg:y': 592.3410034179688
  - id: input_vcf_strelka_indel
    type: File
    'sbg:x': -222.03231811523438
    'sbg:y': 786.2820434570312
  - id: input_vcf_pindel
    type: File
    'sbg:x': -220.1309356689453
    'sbg:y': 953.5880737304688
  - id: input_vcf_mutect
    type: File
    'sbg:x': -220.1309356689453
    'sbg:y': 1098.0931396484375
outputs:
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2171.510009765625
    'sbg:y': 640.453125
  - id: output_maf
    outputSource:
      - vcf2maf/output
    type: File?
    'sbg:x': 2463.260009765625
    'sbg:y': 587.09375
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
    'sbg:x': 531.9334716796875
    'sbg:y': 545.078125
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
    'sbg:x': 1083.9287109375
    'sbg:y': 587.078125
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
    'sbg:x': 1400.00244140625
    'sbg:y': 452.34375
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
    'sbg:x': 1768.295654296875
    'sbg:y': 466.375
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
    'sbg:x': 858.6053466796875
    'sbg:y': 526.734375
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
    'sbg:x': 2171.510009765625
    'sbg:y': 505.734375
  - id: hotspot_vld_mutect
    in:
      - id: vcf_filter_config_A
        source: mutect_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_mutect
      - id: vcf_filter_config_B
        source: mutect_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_mutect
    'sbg:x': 269.546875
    'sbg:y': 937.890625
  - id: hotspot_vld_pindel
    in:
      - id: vcf_filter_config_A
        source: pindel_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_pindel
      - id: vcf_filter_config_B
        source: pindel_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_pindel
    'sbg:x': 269.546875
    'sbg:y': 789.171875
  - id: hotspot_vld_varscan_snv
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_varscan_snv
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_snv
    'sbg:x': 269.546875
    'sbg:y': 194.296875
  - id: hotspot_vld_varscan_indel
    in:
      - id: vcf_filter_config_A
        source: varscan_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_varscan_indel
      - id: vcf_filter_config_B
        source: varscan_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_varscan_indel
    'sbg:x': 269.546875
    'sbg:y': 343.015625
  - id: hotspot_vld_strelka_snv
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_strelka_snv
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_snv
    'sbg:x': 269.546875
    'sbg:y': 491.734375
  - id: hotspot_vld_strelka_indel
    in:
      - id: vcf_filter_config_A
        source: strelka_vcf_filter_config_A
      - id: input_vcf
        source: input_vcf_strelka_indel
      - id: vcf_filter_config_B
        source: strelka_vcf_filter_config
      - id: BED
        source: BED
    out:
      - id: output
    run: ./hotspot_vld.cwl
    label: hotspot_vld_strelka_indel
    'sbg:x': 269.546875
    'sbg:y': 640.453125
requirements:
  - class: SubworkflowFeatureRequirement
