class: Workflow
cwlVersion: v1.0
id: tindaisy
label: TinDaisy
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': 343.3495178222656
    'sbg:y': 322.6915283203125
  - id: reference_fasta
    type: File
    'sbg:x': -234.35398864746094
    'sbg:y': 697.2159423828125
  - id: debug
    type: boolean?
    'sbg:x': 0
    'sbg:y': 963
  - id: bypass_merge
    type: boolean?
    'sbg:x': 0
    'sbg:y': 1070
  - id: bypass_dbsnp
    type: boolean?
    'sbg:x': 650.9874877929688
    'sbg:y': 702.5
  - id: dbsnp_db
    type: File?
    'sbg:x': 650.9874877929688
    'sbg:y': 595.5
  - id: assembly
    type: string?
    'sbg:x': 876.3108520507812
    'sbg:y': 670
  - id: vep_cache_version
    type: string?
    'sbg:x': 0
    'sbg:y': 0
  - id: vep_cache_gz
    type: File?
    'sbg:x': 0
    'sbg:y': 107
  - id: af_filter_config
    type: File
    'sbg:x': 1286.810791015625
    'sbg:y': 749
  - id: classification_filter_config
    type: File
    'sbg:x': 1286.810791015625
    'sbg:y': 428
  - id: bypass_af
    type: boolean?
    'sbg:x': 1286.810791015625
    'sbg:y': 642
  - id: bypass_classification
    type: boolean?
    'sbg:x': 1286.810791015625
    'sbg:y': 535
  - id: bypass_vcf2maf
    type: boolean?
    'sbg:x': 1655.10400390625
    'sbg:y': 588.5
  - id: pindel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 749
  - id: varscan_snv_vcf
    type: File
    'sbg:x': -204.03517150878906
    'sbg:y': 229.3574981689453
  - id: varscan_indel_vcf
    type: File
    'sbg:x': -206.22909545898438
    'sbg:y': 404.3692321777344
  - id: strelka_snv_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 535
  - id: strelka_indel_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 642
  - id: mutect_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 856
outputs:
  - id: output_maf
    outputSource:
      - vcf_2_maf/output_maf
    type: File
    'sbg:x': 2501.9580078125
    'sbg:y': 535
  - id: output_vcf
    outputSource:
      - vep_filter/output_vcf
    type: File
    'sbg:x': 2106.60400390625
    'sbg:y': 588.5
  - id: merged_vcf
    outputSource:
      - merge_vcf/merged_vcf
    type: File
    'sbg:x': 648.7935791015625
    'sbg:y': 306.070068359375
steps:
  - id: merge_vcf
    in:
      - id: strelka_snv_vcf
        source: strelka_snv_vcf
      - id: varscan_indel_vcf
        source: varscan_vcf_remap_1/remapped_VCF
      - id: varscan_snv_vcf
        source: varscan_vcf_remap/remapped_VCF
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
    'sbg:x': 203.8125
    'sbg:y': 479
  - id: dbsnp_filter
    in:
      - id: input_vcf
        source: mnp_filter/filtered_VCF
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
    'sbg:x': 876.3108520507812
    'sbg:y': 535
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
    'sbg:x': 1286.810791015625
    'sbg:y': 293
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
    'sbg:x': 1655.10400390625
    'sbg:y': 453.5
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
    'sbg:x': 2106.60400390625
    'sbg:y': 446.5
  - id: mnp_filter
    in:
      - id: input
        source: merge_vcf/merged_vcf
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_VCF
    run: ../mnp_filter/cwl/mnp_filter.cwl
    label: MNP_filter
    'sbg:x': 650.9874877929688
    'sbg:y': 481.5
  - id: varscan_vcf_remap
    in:
      - id: input
        source: varscan_snv_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
    'sbg:x': -14.501742362976074
    'sbg:y': 256.5477600097656
  - id: varscan_vcf_remap_1
    in:
      - id: input
        source: varscan_indel_vcf
    out:
      - id: remapped_VCF
    run: ../varscan_vcf_remap/varscan_vcf_remap.cwl
    label: varscan_vcf_remap
    'sbg:x': -56.355690002441406
    'sbg:y': 423.16510009765625
requirements: []
