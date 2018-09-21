class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: parse_varscan_indel
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: varscan_indel_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_indel_raw'
  - id: varscan_config
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_config'
  - id: results_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--results_dir'
outputs:
  - id: varscan_indel_dbsnp
    doc: Final SNV output of parsing
    type: File
    outputBinding:
      glob: >-
        $(inputs.results_dir)/varscan/filter_out/varscan.out.som_indel.Somatic.hc.vcf
label: parse_varscan_indel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_varscan_indel
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl-dev'
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
    varscan_indel_raw:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    varscan_snv_raw:
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
