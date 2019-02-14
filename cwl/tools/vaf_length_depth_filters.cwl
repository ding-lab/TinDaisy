class: CommandLineTool
cwlVersion: v1.0
id: vaf_length_depth_filters
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: bypass_vaf
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_vaf'
    label: skip VAF filter
  - id: bypass_length
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_length'
    label: skip length filter
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--debug'
    label: print out processing details to STDERR
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
    label: VCF file to process
  - id: vcf_filter_config
    type: File
    inputBinding:
      position: 0
      prefix: '--vcf_filter_config'
    label: Configuration file for VCF filtering
    doc: 'Filters for depth, VAF, read count'
  - id: bypass_depth
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_depth'
    label: skip depth filter
outputs:
  - id: filtered_vcf
    type: File
    outputBinding:
      glob: results/vaf_length_depth_filters/filtered.vcf
label: vaf_length_depth_filters
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: vaf_length_depth_filters
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
  - position: 0
    prefix: '--output_vcf'
    valueFrom: filtered.vcf
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:mutect'
  - class: InlineJavascriptRequirement
