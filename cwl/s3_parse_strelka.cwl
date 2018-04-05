class: CommandLineTool
cwlVersion: v1.0
id: s3_parse_strelka
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: strelka_snv_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_snv_raw'
  - id: dbsnp_db
    type: File
    inputBinding:
      position: 0
      prefix: '--dbsnp_db'
    secondaryFiles:
      - .tbi
outputs:
  - id: strelka_snv_dbsnp
    type: File
    outputBinding:
      glob: strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.vcf
    secondaryFiles:
      - .tbi
label: s3_parse_strelka
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '3'
  - position: 0
    prefix: '--results_dir'
    valueFrom: .
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    strelka_snv_raw:
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
