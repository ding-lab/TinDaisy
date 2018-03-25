class: Workflow
cwlVersion: v1.0
id: somaticwapper_workflow_test_2_4
label: somaticwapper-workflow_test-2-4
inputs:
  - id: varscan_config
    type: File
    'sbg:x': -487.796875
    'sbg:y': -183
  - id: tumor_bam
    type: File
    'sbg:x': -589.4461035790382
    'sbg:y': -68.97402597402599
  - id: normal_bam
    type: File
    'sbg:x': -542.3162231445312
    'sbg:y': 154.18182373046875
  - id: reference_fasta
    type: File
    'sbg:x': -498.4850769042969
    'sbg:y': 30.805194854736328
outputs:
  - id: varscan_snv_process
    outputSource:
      - s4_parse_varscan/varscan_snv_process
    type: File
    'sbg:x': 209.30714416503906
    'sbg:y': -225.6883087158203
  - id: varscan_snv_filtered
    outputSource:
      - s4_parse_varscan/varscan_snv_filtered
    type: File
    'sbg:x': 256.38507080078125
    'sbg:y': -154.25973510742188
  - id: varscan_snv_dbsnp
    outputSource:
      - s4_parse_varscan/varscan_snv_dbsnp
    type: File
    'sbg:x': 306.7097473144531
    'sbg:y': -35.75324630737305
  - id: varscan_indel_process
    outputSource:
      - s4_parse_varscan/varscan_indel_process
    type: File
    'sbg:x': 227.16429138183594
    'sbg:y': 118.467529296875
  - id: varscan_indel_dbsnp
    outputSource:
      - s4_parse_varscan/varscan_indel_dbsnp
    type: File
    'sbg:x': 100.54090881347656
    'sbg:y': 194.7662353515625
steps:
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
    'sbg:x': -290.796875
    'sbg:y': -61
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
    'sbg:x': 39.203125
    'sbg:y': -60
