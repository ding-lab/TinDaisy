class: CommandLineTool
cwlVersion: v1.0
id: run_varscan
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--tumor_bam'
    secondaryFiles:
      - .bai
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
    secondaryFiles:
      - .bai
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: varscan_config
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_config'
outputs:
  - id: varscan_indel_raw
    type: File
    outputBinding:
      glob: results/varscan/varscan_out/varscan.out.som_indel.vcf
  - id: varscan_snv_raw
    type: File
    outputBinding:
      glob: results/varscan/varscan_out/varscan.out.som_snv.vcf
label: run_varscan
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_varscan
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:20190328'
  - class: InlineJavascriptRequirement
