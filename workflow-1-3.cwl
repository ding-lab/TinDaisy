class: Workflow
cwlVersion: v1.0
id: workflow_1_3
label: workflow-1-3
inputs:
  - id: normal_bam
    type: File
    'sbg:x': -551.796875
    'sbg:y': 56
  - id: reference_fasta
    type: File
    'sbg:x': -617.796875
    'sbg:y': -90
  - id: strelka_config
    type: File
    'sbg:x': -613.796875
    'sbg:y': -200
  - id: tumor_bam
    type: File
    'sbg:x': -507.796875
    'sbg:y': -290
outputs:
  - id: indels_passed
    outputSource:
      - s1_run_strelka/indels_passed
    type: File
    'sbg:x': -192.796875
    'sbg:y': 108
  - id: strelka_snv_dbsnp
    outputSource:
      - s3_parse_strelka/strelka_snv_dbsnp
    type: File
    'sbg:x': 131.203125
    'sbg:y': -112
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
    'sbg:x': -364.796875
    'sbg:y': -128
  - id: s3_parse_strelka
    in:
      - id: strelka_snv_raw
        source:
          - s1_run_strelka/snvs_passed
    out:
      - id: strelka_snv_dbsnp
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': -58.796875
    'sbg:y': -97
