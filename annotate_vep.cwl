class: CommandLineTool
cwlVersion: v1.0
id: annotate_vep
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
outputs:
  - id: output_dat
    type: File
    outputBinding:
      glob: output.*
label: annotate_vep
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '10'
  - position: 0
    prefix: '--use_vep_db'
  - position: 0
    prefix: '--assembly'
    valueFrom: GRCh37
  - position: 0
    prefix: '--output_vep'
  - position: 0
    prefix: '--output_vcf'
    valueFrom: output.vcf
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    input_vcf:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
  runtime:
    cores: 1
    ram: 1000
