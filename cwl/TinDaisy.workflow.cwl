class: Workflow
cwlVersion: v1.0
id: workflow_v1_1
label: TinDaisy Workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: strelka_config
    type: File
    'sbg:x': -373.796875
    'sbg:y': -313
  - id: reference_fasta
    type: File
    'sbg:x': -642.2354736328125
    'sbg:y': 123.93272399902344
  - id: normal_bam
    type: File
    'sbg:x': -619.4464721679688
    'sbg:y': 270.3639221191406
  - id: varscan_config
    type: File
    'sbg:x': -681.7217407226562
    'sbg:y': -46.14678955078125
  - id: pindel_config
    type: File
    'sbg:x': -227.84698486328125
    'sbg:y': 642.4647216796875
  - id: dbsnp_db
    type: File
    'sbg:x': -475.1688232421875
    'sbg:y': 602.2885131835938
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
  - id: tumor_bam
    type: File
    'sbg:x': -660.805908203125
    'sbg:y': 415.9395751953125
  - id: assembly
    type: string
    'sbg:exposed': true
  - id: results_dir
    type: string?
    'sbg:x': -658.08203125
    'sbg:y': -279.7426452636719
outputs:
  - id: output_dat
    outputSource:
      - annotate_vep/output_dat
    type: File
    label: Output VCF
    'sbg:x': 507.6928405761719
    'sbg:y': -252.231201171875
steps:
  - id: s1_run_strelka
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_config
        source: strelka_config
      - id: results_dir
        source: results_dir
    out:
      - id: snvs_passed
    run: s1_run_strelka.cwl
    label: S1_run_strelka
    'sbg:x': -245.796875
    'sbg:y': -96
  - id: s2_run_varscan
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: varscan_config
        source: varscan_config
      - id: results_dir
        source: results_dir
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
        source: s1_run_strelka/snvs_passed
      - id: dbsnp_db
        source: dbsnp_db
      - id: strelka_config
        source: strelka_config
      - id: results_dir
        source: results_dir
    out:
      - id: strelka_snv_dbsnp
    run: s3_parse_strelka.cwl
    label: s3_parse_strelka
    'sbg:x': 112.203125
    'sbg:y': -97
  - id: s4_parse_varscan
    in:
      - id: varscan_indel_raw
        source: s2_run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source: s2_run_varscan/varscan_snv_raw
      - id: dbsnp_db
        source: dbsnp_db
      - id: varscan_config
        source: varscan_config
      - id: results_dir
        source: results_dir
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
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: centromere_bed
        source: centromere_bed
      - id: no_delete_temp
        source: no_delete_temp
      - id: results_dir
        source: results_dir
    out:
      - id: pindel_raw
    run: s5_run_pindel.cwl
    label: s5_run_pindel
    'sbg:x': -235.796875
    'sbg:y': 377
  - id: s7_parse_pindel
    in:
      - id: pindel_raw
        source: s5_run_pindel/pindel_raw
      - id: reference_fasta
        source: reference_fasta
      - id: pindel_config
        source: pindel_config
      - id: dbsnp_db
        source: dbsnp_db
      - id: results_dir
        source: results_dir
    out:
      - id: pindel_dbsnp
    run: s7_parse_pindel.cwl
    label: s7_parse_pindel
    'sbg:x': 121.203125
    'sbg:y': 393
  - id: s8_merge_vcf
    in:
      - id: strelka_snv_vcf
        source: s3_parse_strelka/strelka_snv_dbsnp
      - id: varscan_indel_vcf
        source: s4_parse_varscan/varscan_indel_dbsnp
      - id: varscan_snv_vcf
        source: s4_parse_varscan/varscan_snv_dbsnp
      - id: pindel_vcf
        source: s7_parse_pindel/pindel_dbsnp
      - id: reference_fasta
        source: reference_fasta
      - id: results_dir
        source: results_dir
    out:
      - id: merged_vcf
    run: s8_merge_vcf.cwl
    label: s8_merge_vcf
    'sbg:x': 450.203125
    'sbg:y': 151
  - id: annotate_vep
    in:
      - id: input_vcf
        source: s8_merge_vcf/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: output_vep
        source: output_vep
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: results_dir
        source: results_dir
    out:
      - id: output_dat
    run: s10_annotate_vep.cwl
    label: annotate_vep
    'sbg:x': 286.7515762749068
    'sbg:y': -244.10921975232046
requirements: []
