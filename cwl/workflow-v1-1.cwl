class: Workflow
cwlVersion: v1.0
id: workflow_v1_1
label: workflow-v1.1
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': -439.796875
    'sbg:y': -112
  - id: strelka_config
    type: File
    'sbg:x': -373.796875
    'sbg:y': -313
  - id: reference_fasta
    type: File
    'sbg:x': -469.796875
    'sbg:y': 90
  - id: normal_bam
    type: File
    'sbg:x': -473.796875
    'sbg:y': 215
  - id: varscan_config
    type: File
    'sbg:x': -621.9358271640092
    'sbg:y': -14.89066059225513
  - id: pindel_config
    type: File
    'sbg:x': -227.84698486328125
    'sbg:y': 642.4647216796875
  - id: dbsnp_db
    type: File
    'sbg:x': -475.1688232421875
    'sbg:y': 602.2885131835938
  - id: assembly
    type: string
    'sbg:exposed': true
  - id: output_vep
    type: string?
    'sbg:exposed': true
  - id: centromere_bed
    type: File?
    'sbg:x': -522.3388671875
    'sbg:y': 475.5733642578125
  - id: no_delete_temp
    type: int?
    'sbg:exposed': true
  - id: vep_cache_gz
    type: File?
    'sbg:x': 98.81038665771484
    'sbg:y': -419.2463073730469
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
outputs:
  - id: output_dat
    outputSource:
      - annotate_vep/output_dat
    type: File
    'sbg:x': 507.6928405761719
    'sbg:y': -252.231201171875
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
    run: s1_run_strelka.cwl
    label: S1_run_strelka
    'sbg:x': -245.796875
    'sbg:y': -96
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
    run: s2_run_varscan.cwl
    label: s2_run_varscan
    'sbg:x': -244.796875
    'sbg:y': 122
  - id: s3_parse_strelka
    in:
      - id: strelka_snv_raw
        source:
          - s1_run_strelka/snvs_passed
      - id: dbsnp_db
        source:
          - dbsnp_db
    out:
      - id: strelka_snv_dbsnp
    run: s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': 112.203125
    'sbg:y': -97
  - id: s4_parse_varscan
    in:
      - id: varscan_indel_raw
        source:
          - s2_run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source:
          - s2_run_varscan/varscan_snv_raw
      - id: dbsnp_db
        source:
          - dbsnp_db
    out:
      - id: varscan_snv_dbsnp
      - id: varscan_indel_dbsnp
    run: s4_parse_varscan.cwl
    label: s4_parse_varscan
    'sbg:x': 128.203125
    'sbg:y': 128
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
      - id: centromere_bed
        source:
          - centromere_bed
      - id: no_delete_temp
        source:
          - no_delete_temp
    out:
      - id: pindel_raw
    run: s5_run_pindel.cwl
    label: s5_run_pindel
    'sbg:x': -235.796875
    'sbg:y': 377
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
      - id: dbsnp_db
        source:
          - dbsnp_db
    out:
      - id: pindel_dbsnp
    run: s7_parse_pindel.cwl
    label: s7_parse_pindel
    'sbg:x': 121.203125
    'sbg:y': 393
  - id: s8_merge_vcf
    in:
      - id: strelka_snv_vcf
        source:
          - s3_parse_strelka/strelka_snv_dbsnp
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
    run: s8_merge_vcf.cwl
    label: s8_merge_vcf
    'sbg:x': 450.203125
    'sbg:y': 151
  - id: annotate_vep
    in:
      - id: input_vcf
        source:
          - s8_merge_vcf/merged_vcf
      - id: reference_fasta
        source:
          - reference_fasta
      - id: assembly
        source:
          - assembly
      - id: output_vep
        source:
          - output_vep
      - id: vep_cache_gz
        source:
          - vep_cache_gz
      - id: vep_cache_version
        source:
          - vep_cache_version
    out:
      - id: output_dat
    run: s10_annotate_vep.cwl
    label: annotate_vep
    'sbg:x': 286.7515762749068
    'sbg:y': -244.10921975232046
