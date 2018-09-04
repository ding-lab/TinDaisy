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
  - id: centromere_bed
    type: File?
    'sbg:x': -522.3388671875
    'sbg:y': 475.5733642578125
  - id: no_delete_temp
    type: boolean?
    'sbg:exposed': true
  - id: tumor_bam
    type: File
    'sbg:x': -660.805908203125
    'sbg:y': 415.9395751953125
  - id: results_dir
    type: string
    'sbg:x': -699.0764770507812
    'sbg:y': -275.4281311035156
  - id: is_strelka2
    type: boolean?
    'sbg:exposed': true
  - id: pindel_vcf_filter_config
    type: File
    'sbg:x': -10.622802734375
    'sbg:y': 637
  - id: varscan_vcf_filter_config
    type: File
    'sbg:x': -202.622802734375
    'sbg:y': -397
  - id: strelka_vcf_filter_config
    type: File
    'sbg:x': -114.622802734375
    'sbg:y': -534.2361450195312
  - id: assembly
    type: string?
    'sbg:exposed': true
  - id: vep_cache_version
    type: string?
    'sbg:exposed': true
  - id: vep_cache_gz
    'sbg:fileTypes': .tar.gz
    type: File?
    'sbg:x': 404.1976318359375
    'sbg:y': -220.1764678955078
  - id: bypass_merge_vcf
    type: boolean?
    'sbg:exposed': true
  - id: classification_filter_config
    type: File
    'sbg:x': 883.6535034179688
    'sbg:y': 321.17333984375
  - id: af_filter_config
    type: File
    'sbg:x': 1154.0362548828125
    'sbg:y': 274.5126953125
  - id: bypass_vep_annotate
    type: boolean?
    'sbg:exposed': true
  - id: bypass_parse_pindel
    type: boolean?
    'sbg:exposed': true
outputs:
  - id: merged_maf
    outputSource:
      - vcf_2_maf/output_dat
    type: File
    'sbg:x': 2136.03369140625
    'sbg:y': -204.2615966796875
  - id: output_vcf
    outputSource:
      - vep_annotate/output_dat
    type: File
    label: Output VCF
    doc: Principal output of workflow in VCF format
    'sbg:x': 1454.6470947265625
    'sbg:y': 107.07058715820312
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
      - id: is_strelka2
        default: false
        source: is_strelka2
    out:
      - id: snvs_passed
    run: s1_run_strelka.cwl
    label: s1_run_strelka
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
      - id: strelka_vcf_filter_config
        source: strelka_vcf_filter_config
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
      - id: varscan_vcf_filter_config
        source: varscan_vcf_filter_config
    out:
      - id: varscan_snv_dbsnp
      - id: varscan_indel_dbsnp
    run: s4_parse_varscan.cwl
    label: s4_parse_varscan
    'sbg:x': 141
    'sbg:y': 148
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
        default: false
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
      - id: no_delete_temp
        default: false
        source: no_delete_temp
      - id: pindel_vcf_filter_config
        source: pindel_vcf_filter_config
      - id: bypass
        source: bypass_parse_pindel
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
      - id: bypass
        source: bypass_merge_vcf
    out:
      - id: merged_vcf
    run: s8_merge_vcf.cwl
    label: s8_merge_vcf
    'sbg:x': 450.203125
    'sbg:y': 151
  - id: vep_annotate
    in:
      - id: input_vcf
        source: s8_merge_vcf/merged_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: results_dir
        source: results_dir
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: bypass
        source: bypass_vep_annotate
      - id: af_filter_config
        source: af_filter_config
      - id: classification_filter_config
        source: classification_filter_config
    out:
      - id: output_dat
    run: ./s9_vep_annotate.cwl
    label: s9_vep_annotate
    'sbg:x': 1194.2918701171875
    'sbg:y': -24.863866806030273
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: vep_annotate/output_dat
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: results_dir
        source: results_dir
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_dat
    run: ./s10_vcf_2_maf.cwl
    label: s10_vcf_2_maf
    'sbg:x': 1599.6531982421875
    'sbg:y': -281.6700439453125
requirements: []
