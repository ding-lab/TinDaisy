class: CommandLineTool
cwlVersion: v1.0
id: parse_varscan_snv
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: varscan_indel_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_indel_raw'
  - id: varscan_snv_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_snv_raw'
  - id: varscan_config
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_config'
outputs:
  - id: varscan_snv
    doc: Final SNV output of parsing
    type: File
    outputBinding:
      glob: >-
        results/varscan/filter_snv_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf
label: parse_varscan_snv
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: parse_varscan_snv
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:mutect'
  - class: InlineJavascriptRequirement
