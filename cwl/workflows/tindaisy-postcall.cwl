class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': 1199.7630615234375
    'sbg:y': 602.19873046875
  - id: reference_fasta
    type: File
    'sbg:x': 759.9226684570312
    'sbg:y': 378.1288146972656
  - id: debug
    type: boolean?
    'sbg:x': 723.5888671875
    'sbg:y': 1618.1409912109375
  - id: bypass_merge
    type: boolean?
    'sbg:x': 1230.9559326171875
    'sbg:y': 1633.1541748046875
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 1991.1295166015625
    'sbg:y': 1077
  - id: dbsnp_db
    type: File?
    'sbg:x': 1991.1295166015625
    'sbg:y': 970
  - id: assembly
    type: string?
    'sbg:x': 2216.452880859375
    'sbg:y': 963
  - id: vep_cache_version
    type: string?
    'sbg:x': 1526.0789794921875
    'sbg:y': 144.75668334960938
  - id: vep_cache_gz
    type: File?
    'sbg:x': 1555.52099609375
    'sbg:y': 489.7464904785156
  - id: af_filter_config
    type: File
    'sbg:x': 2626.952880859375
    'sbg:y': 1123.5
  - id: classification_filter_config
    type: File
    'sbg:x': 2626.952880859375
    'sbg:y': 802.5
  - id: bypass_af
    type: boolean?
    'sbg:x': 2626.952880859375
    'sbg:y': 1016.5
  - id: bypass_classification
    type: boolean?
    'sbg:x': 2626.952880859375
    'sbg:y': 909.5
  - id: bypass_vcf2maf
    type: boolean?
    'sbg:x': 2995.24609375
    'sbg:y': 963
  - id: pindel_vcf
    type: File
    'sbg:x': 1224.373291015625
    'sbg:y': 1350.1845703125
  - id: varscan_snv_vcf
    type: File
    'sbg:x': 762.1574096679688
    'sbg:y': 536.4224243164062
  - id: varscan_indel_vcf
    type: File
    'sbg:x': 761.0368041992188
    'sbg:y': 681.7047729492188
  - id: strelka_snv_vcf
    type: File
    'sbg:x': 728.8028564453125
    'sbg:y': 855.7679443359375
  - id: strelka_indel_vcf
    type: File
    'sbg:x': 722.3560791015625
    'sbg:y': 1024.6737060546875
  - id: mutect_vcf
    type: File
    'sbg:x': 717.1986694335938
    'sbg:y': 1173.07666015625
outputs:
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File
    'sbg:x': 3842.10009765625
    'sbg:y': 909.5
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 3446.74609375
    'sbg:y': 963
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
    'sbg:x': 1991.1295166015625
    'sbg:y': 742
steps:
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_snv_vcf
      - id: varscan_indel_vcf
        source: varscan_indel_vcf
      - id: varscan_snv_vcf
        source: varscan_snv_vcf
      - id: pindel_vcf
        source: pindel_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_merge
        source: bypass_merge
      - id: debug
        source: debug
      - id: strelka_indel_vcf
        source: strelka_indel_vcf
      - id: mutect_vcf
        source: mutect_vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: merge_vcf
    'sbg:x': 1543.95458984375
    'sbg:y': 853.5
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: dnp_filter/filtered_VCF
      - id: reference_fasta
        source: reference_fasta
      - id: bypass_dbsnp
        source: bypass_dbsnp
      - id: debug
        source: debug
      - id: dbsnp_db
        source: dbsnp_db
    out:
      - id: filtered_vcf
    run: ../tools/dbsnp_filter.cwl
    label: dbsnp_filter
    'sbg:x': 2216.452880859375
    'sbg:y': 828
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
    'sbg:x': 2626.952880859375
    'sbg:y': 667.5
  - id: vep_filter
    in:
      - id: input_vcf
        source: vep_annotate/output_dat
      - id: af_filter_config
        source: af_filter_config
      - id: classification_filter_config
        source: classification_filter_config
      - id: bypass_af
        source: bypass_af
      - id: bypass_classification
        source: bypass_classification
    out:
      - id: output_vcf
    run: ../tools/vep_filter.cwl
    label: vep_filter
    'sbg:x': 2995.24609375
    'sbg:y': 828
  - id: vcf_2_maf
    in:
      - id: input_vcf
        source: vep_filter/output_vcf
      - id: reference_fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: bypass_vcf2maf
        source: bypass_vcf2maf
    out:
      - id: output_maf
    run: ../tools/vcf_2_maf.cwl
    label: vcf_2_maf
    'sbg:x': 3446.74609375
    'sbg:y': 821
  - id: dnp_filter
    in:
      - id: input
        source: merge_vcf/merged_vcf
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_VCF
    run: ../dnp_filter/cwl/dnp_filter.cwl
    label: DNP_filter
    'sbg:x': 1991.1295166015625
    'sbg:y': 856
requirements: []
