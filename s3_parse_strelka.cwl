class: CommandLineTool
cwlVersion: v1.0
id: s3_parse_strelka
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
  - id: reference_dict
    type: File?
    inputBinding:
      position: 0
      prefix: '--reference_dict'
  - id: strelka_snv_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_snv_raw'
outputs:
  - id: output
    type: File
    outputBinding:
      glob: strelka/filter_out/strelka.somatic.snv.all.gvip.dbsnp_pass.vcf
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
  - position: 0
    prefix: '--dbsnp_db'
    valueFrom: /usr/local/StrelkaDemo/image/B_Filter/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    reference_fasta:
      basename: '-.ext'
      class: File
      contents: file contents
      nameext: .ext
      nameroot: '-'
      path: /path/to/-.ext
      secondaryFiles: []
      size: 0
    reference_dict:
      basename: r.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: r
      path: /path/to/r.ext
      secondaryFiles: []
      size: 0
    strelka_snv_raw:
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
