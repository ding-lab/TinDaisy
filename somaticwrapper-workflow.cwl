class: Workflow
cwlVersion: v1.0
id: somaticwrapper_workflow
label: somaticwrapper.workflow
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': -547.203125
    'sbg:y': -294
  - id: strelka_config
    type: File
    'sbg:x': -580.203125
    'sbg:y': -187
  - id: reference_fasta
    type: File
    'sbg:x': -593.203125
    'sbg:y': -62
  - id: normal_bam
    type: File
    'sbg:x': -515.203125
    'sbg:y': 66
outputs:
  - id: indels_passed
    outputSource:
      - s1_run_strelka/indels_passed
    type: File
    'sbg:x': -84.86779565868264
    'sbg:y': 100.63273453093811
  - id: output
    outputSource:
      - s3_parse_strelka/output
    type: File
    'sbg:x': 213.96791076660156
    'sbg:y': -144.2874298095703
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
      - id: reference_fasta
        source:
          - reference_fasta
      - id: strelka_snv_raw
        source:
          - s1_run_strelka/snvs_passed
    out:
      - id: output
    run: /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': 90.94808972143605
    'sbg:y': -149.21955372092728
