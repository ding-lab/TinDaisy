class: CommandLineTool
cwlVersion: v1.0
id: s7_parse_pindel
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: pindel_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_raw'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: pindel_config
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_config'
  - id: dbsnp_db
    type: File
    inputBinding:
      position: 0
      prefix: '--dbsnp_db'
    secondaryFiles:
      - .tbi
outputs:
  - id: pindel_dbsnp
    type: File
    outputBinding:
      glob: pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf
label: s7_parse_pindel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '7'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    pindel_raw:
      basename: p.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: p
      path: /path/to/p.ext
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
    pindel_config:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    dbsnp_db:
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
