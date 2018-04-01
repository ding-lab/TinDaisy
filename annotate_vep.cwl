class: CommandLineTool
cwlVersion: v1.0
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
  - id: vep_cache_dir
    type: Directory?
    inputBinding:
      position: 0
      prefix: '--vep_cache_dir'
    label: vep cache
  - id: output_vep
    type: string?
    inputBinding:
      position: 0
      prefix: '--output_vep'
  - id: use_vep_db
    type: int?
    inputBinding:
      position: 0
      prefix: '--use_vep_db'
    label: online db lookups
    doc: >-
      Use online database for VEP lookups.  Does not require cache, but is much
      slower
outputs:
  - id: output_dat
    type: File
    outputBinding:
      glob: output.*
label: annotate_vep
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '10'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    input_vcf:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
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
    assembly: assembly-string-value
    vep_cache_dir:
      basename: vep_cache_dir
      class: Directory
      path: /path/to/vep_cache_dir
    output_vep: output_vep-string-value
    use_vep_db: 6
  runtime:
    cores: 1
    ram: 1000
