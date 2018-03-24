class: CommandLineTool
cwlVersion: v1.0
id: s2_run_varscan
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--tumor_bam'
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
  - id: varscan_config
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_config'
outputs:
  - id: varscan_indel_raw
    type: File
    outputBinding:
      glob: varscan/varscan_out/varscan.out.som_indel.vcf
  - id: varscan_snv_raw
    type: File
    outputBinding:
      glob: varscan/varscan_out/varscan.out.som_snv.vcf
label: s2_run_varscan
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '2'
  - position: 0
    prefix: '--results_dir'
    valueFrom: .
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    tumor_bam:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    normal_bam:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    reference_fasta:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    varscan_config:
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
