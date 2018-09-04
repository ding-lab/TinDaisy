class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
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
  - id: strelka_config
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_config'
  - id: results_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--results_dir'
  - id: strelka_vcf_filter_config
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_vcf_filter_config'
    label: VCF filter configuration file
    doc: 'Configuration file for VCF filtering (depth, VAF, read count)'
outputs:
  - id: strelka_snv_dbsnp
    type: File
    outputBinding:
      glob: >-
        $(inputs.results_dir)/strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.filtered.vcf
    secondaryFiles:
      - .tbi
label: s3_parse_strelka
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '3'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:20180904'
  - class: InlineJavascriptRequirement
'sbg:job':
  inputs:
    dbsnp_db:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
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
