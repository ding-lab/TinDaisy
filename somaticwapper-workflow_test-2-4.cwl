class: Workflow
cwlVersion: v1.0
id: somaticwapper_workflow_test_2_4
label: somaticwapper-workflow_test-2-4
inputs:
  - id: varscan_config
    type: File
    'sbg:x': -623.9002075195312
    'sbg:y': -124.24745178222656
  - id: tumor_bam
    type: File
    'sbg:x': -719.7281494140625
    'sbg:y': -49.60250473022461
  - id: reference_fasta
    type: File
    'sbg:x': -698.545166015625
    'sbg:y': 70.43463897705078
  - id: normal_bam
    type: File
    'sbg:x': -632.9786376953125
    'sbg:y': 178.3671875
outputs:
  - id: varscan_snv_process
    outputSource:
      - s4_parse_varscan/varscan_snv_process
    type: File?
    'sbg:x': -30.450298309326172
    'sbg:y': -317.989990234375
  - id: varscan_snv_filtered
    outputSource:
      - s4_parse_varscan/varscan_snv_filtered
    type: File?
    'sbg:x': 73.44811248779297
    'sbg:y': -237.50531005859375
  - id: varscan_snv_dbsnp
    outputSource:
      - s4_parse_varscan/varscan_snv_dbsnp
    type: File
    'sbg:x': 184.66331481933594
    'sbg:y': -114.58324432373047
  - id: varscan_indel_process
    outputSource:
      - s4_parse_varscan/varscan_indel_process
    type: File?
    'sbg:x': 216.857177734375
    'sbg:y': 81.5067138671875
  - id: varscan_indel_dbsnp
    outputSource:
      - s4_parse_varscan/varscan_indel_dbsnp
    type: File
    'sbg:x': 66.1313247680664
    'sbg:y': 301.0104064941406
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
    'sbg:x': -465.5318603515625
    'sbg:y': -22.3671875
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
    'sbg:x': -94.32457733154297
    'sbg:y': 5.876845836639404
