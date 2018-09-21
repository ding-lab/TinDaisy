class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: vaf_length_depth_filters
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: results_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--results_dir'
  - id: bypass
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass'
    label: bypass all filters
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
  - id: output_vcf
    type: string
    inputBinding:
      position: 0
      prefix: '--output_vcf'
    label: Name of output VCF file
    doc: written to results_dir/vaf_length_depth_filters/output_vcf
  - id: caller
    type: string
    inputBinding:
      position: 0
      prefix: '--caller'
    label: Variant caller
    doc: 'One of strelka, pindel, varscan'
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
      glob: |
        $(inputs.results_dir)/vaf_length_depth_filters/$(inputs.output_vcf)
label: vaf_length_depth_filters
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: vaf_length_depth_filters
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
    pindel_config:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
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
  runtime:
    cores: 1
    ram: 1000
