class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: annotate_vep
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: assembly
    type: string
    inputBinding:
      position: 0
      prefix: '--assembly'
    label: assembly name for VEP annotation
    doc: Either GRCh37 or GRCh38 currently accepted
  - id: vep_output
    type: string?
    inputBinding:
      position: 0
      prefix: '--vep_output'
    label: Define output format after annotation.
    doc: 'Allowed values: vcf, vep.  vcf is default'
  - id: vep_cache_version
    type: string?
    inputBinding:
      position: 0
      prefix: '--vep_cache_version'
    label: 'VEP Cache Version (e.g., 90)'
    doc: 'This is required if VEP_CACHE_GZ is defined, and must match'
  - id: results_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--results_dir'
  - id: vep_cache_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--vep_cache_dir'
    label: location of VEP cache directory
    doc: >-
      * if vep_cache_dir is not defined, will perform online VEP DB lookups

      * If vep_cache_dir is a directory, it indicates location of VEP cache

      * If vep_cache_dir is a file ending in .tar.gz, will extract its contents
      into "./vep-cache" and use VEP cache
outputs:
  - id: output_dat
    type: File
    outputBinding:
      glob: $(inputs.results_dir)/vep/output.v*
label: s9_vep_annotate
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '9'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
  - class: InlineJavascriptRequirement
'sbg:job':
  inputs:
    assembly: assembly-string-value
    input_vcf:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    output_vep: output_vep-string-value
    reference_fasta:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    vep_cache_gz:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    vep_cache_version: vep_cache_version-string-value
  runtime:
    cores: 1
    ram: 1000
