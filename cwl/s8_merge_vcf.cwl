class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: s8_merge_vcf
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: strelka_snv_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_snv_vcf'
  - id: varscan_indel_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_indel_vcf'
  - id: varscan_snv_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_snv_vcf'
  - id: pindel_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_vcf'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
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
    label: Bypass filter by retaining all reads
outputs:
  - id: merged_vcf
    type: File
    outputBinding:
      glob: $(inputs.results_dir)/merged/merged.filtered.vcf
label: s8_merge_vcf
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '8'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
  - class: InlineJavascriptRequirement
'sbg:job':
  inputs:
    pindel_vcf:
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
    strelka_snv_vcf:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    varscan_indel_vcf:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    varscan_snv_vcf:
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
