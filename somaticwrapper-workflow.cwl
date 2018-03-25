class: Workflow
cwlVersion: v1.0
id: somaticwrapper_workflow
label: somaticwrapper.workflow
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': -851.3268363402067
    'sbg:y': -180.59793814432973
  - id: strelka_config
    type: File
    'sbg:x': -531.2340528350514
    'sbg:y': -406.0721649484539
  - id: reference_fasta
    type: File
    'sbg:x': -850.935083762887
    'sbg:y': -15.608247422680343
  - id: normal_bam
    type: File
    'sbg:x': -847.6773518041242
    'sbg:y': 156.20618556701044
  - id: varscan_config
    type: File
    'sbg:x': -705.392636014014
    'sbg:y': 485.27626871325316
  - id: pindel_config
    type: File
    'sbg:x': -692.5741677824985
    'sbg:y': 828.1964992247908
outputs:
  - id: indels_passed
    outputSource:
      - s1_run_strelka/indels_passed
    type: File
    'sbg:x': 50.67437082313637
    'sbg:y': 19.307435001235376
  - id: varscan_snv_process
    outputSource:
      - s4_parse_varscan/varscan_snv_process
    type: File?
    'sbg:x': 288.5306701660156
    'sbg:y': 66.19490814208984
  - id: varscan_snv_filtered
    outputSource:
      - s4_parse_varscan/varscan_snv_filtered
    type: File?
    'sbg:x': 306.60296630859375
    'sbg:y': 177.64068603515625
  - id: varscan_indel_process
    outputSource:
      - s4_parse_varscan/varscan_indel_process
    type: File?
    'sbg:x': 314.1330871582031
    'sbg:y': 469.8093566894531
  - id: merged_vcf
    outputSource:
      - s8_merge_vcf/merged_vcf
    type: File
    'sbg:x': 1113.3892822265625
    'sbg:y': 226.17327880859375
steps:
  - id: s1_run_strelka
    in:
      - id: tumor_bam
        source:
          - tumor_bam
      - id: normal_bam
        source:
          - normal_bam
      - id: reference_fasta
        source:
          - reference_fasta
      - id: strelka_config
        source:
          - strelka_config
    out:
      - id: snvs_passed
      - id: indels_passed
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s1_run_strelka.cwl
    label: S1_run_strelka
    'sbg:x': -279.203125
    'sbg:y': -175
  - id: s3_parse_strelka
    in:
      - id: strelka_snv_raw
        source:
          - s1_run_strelka/snvs_passed
    out:
      - id: output
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': 90.94808972143605
    'sbg:y': -149.21955372092728
  - id: s2_run_varscan
    in:
      - id: tumor_bam
        source:
          - tumor_bam
      - id: normal_bam
        source:
          - normal_bam
      - id: reference_fasta
        source:
          - reference_fasta
      - id: varscan_config
        source:
          - varscan_config
    out:
      - id: varscan_indel_raw
      - id: varscan_snv_raw
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s2_run_varscan.cwl
    label: s2_run_varscan
    'sbg:x': -267.725830078125
    'sbg:y': 214.63746643066406
  - id: s4_parse_varscan
    in:
      - id: varscan_indel_raw
        source:
          - s2_run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source:
          - s2_run_varscan/varscan_snv_raw
    out:
      - id: varscan_snv_process
      - id: varscan_indel_process
      - id: varscan_snv_filtered
      - id: varscan_snv_dbsnp
      - id: varscan_indel_dbsnp
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s4_parse_varscan.cwl
    label: s4_parse_varscan
    'sbg:x': 104.47863006591797
    'sbg:y': 240.19656372070312
  - id: s5_run_pindel
    in:
      - id: tumor_bam
        source:
          - tumor_bam
      - id: normal_bam
        source:
          - normal_bam
      - id: reference_fasta
        source:
          - reference_fasta
    out:
      - id: pindel_raw
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s5_run_pindel.cwl
    label: s5_run_pindel
    'sbg:x': -286.8321228027344
    'sbg:y': 618.0151977539062
  - id: s7_parse_pindel
    in:
      - id: pindel_raw
        source:
          - s5_run_pindel/pindel_raw
      - id: reference_fasta
        source:
          - reference_fasta
      - id: pindel_config
        source:
          - pindel_config
    out:
      - id: pindel_dbsnp
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s7_parse_pindel.cwl
    label: s7_parse_pindel
    'sbg:x': 88.64346295092477
    'sbg:y': 755.9539184570312
  - id: s8_merge_vcf
    in:
      - id: strelka_snv_vcf
        source:
          - s3_parse_strelka/output
      - id: varscan_indel_vcf
        source:
          - s4_parse_varscan/varscan_indel_dbsnp
      - id: varscan_snv_vcf
        source:
          - s4_parse_varscan/varscan_snv_dbsnp
      - id: pindel_vcf
        source:
          - s7_parse_pindel/pindel_dbsnp
      - id: reference_fasta
        source:
          - reference_fasta
    out:
      - id: merged_vcf
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s8_merge_vcf.cwl
    label: s8_merge_vcf
    'sbg:x': 880.5654907226562
    'sbg:y': 255.0442657470703
