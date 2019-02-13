class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: merge_vcf
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: strelka_snv_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_snv_vcf'
  - id: varscan_indel_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_indel_vcf'
  - id: varscan_snv_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_snv_vcf'
  - id: pindel_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_vcf'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: bypass_merge
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_merge'
    label: Bypass merge filter
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--debug'
    label: print out processing details to STDERR
  - id: strelka_indel_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_indel_vcf'
  - id: mutect_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--mutect_vcf'
outputs:
  - id: merged_vcf
    type: File
    outputBinding:
      glob: results/merged/merged.filtered.vcf
label: merge_vcf
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: merge_vcf
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:20181126'
  - class: InlineJavascriptRequirement
