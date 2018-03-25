class: Workflow
cwlVersion: v1.0
id: somaticwrapper_workflow_test_5_7
label: somaticwrapper-workflow_test-5-7
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': -472.796875
    'sbg:y': -236
  - id: reference_fasta
    type: File
    'sbg:x': -560.203125
    'sbg:y': 171
  - id: normal_bam
    type: File
    'sbg:x': -543.796875
    'sbg:y': -98
  - id: pindel_config
    type: File
    'sbg:x': -56.796875
    'sbg:y': 174
outputs:
  - id: pindel_dbsnp
    outputSource:
      - s7_parse_pindel/pindel_dbsnp
    type: File
    'sbg:x': 238.203125
    'sbg:y': -101
steps:
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
    'sbg:x': -323.796875
    'sbg:y': -81
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
    'sbg:x': 46.203125
    'sbg:y': -57
