class: CommandLineTool
cwlVersion: v1.0
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
outputs:
  - id: varscan_indel
    doc: Final SNV output of parsing
    type: File
    outputBinding:
      glob: >-
        results/varscan/filter_indel_out/varscan.out.som_indel.Somatic.hc.vcf
label: parse_varscan_indel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: parse_varscan_indel
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:20180926'
  - class: InlineJavascriptRequirement
