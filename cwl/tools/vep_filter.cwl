class: CommandLineTool
cwlVersion: v1.0
id: vep_filter
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
  - id: af_filter_config
    type: File
    inputBinding:
      position: 0
      prefix: '--af_filter_config'
    label: Configuration file for af (allele frequency) filter
  - id: classification_filter_config
    type: File
    inputBinding:
      position: 0
      prefix: '--classification_filter_config'
    label: Configuration file for classification filter
  - id: bypass_af
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_af'
    label: Bypass AF filter by retaining all reads
  - id: bypass_classification
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_classification'
    label: Bypass Classification filter by retaining all reads
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--debug'
    label: print out processing details to STDERR
outputs:
  - id: output_vcf
    type: File
    outputBinding:
      glob: results/vep_filter/vep_filtered.vcf
label: vep_filter
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: vep_filter
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:20191108'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000

