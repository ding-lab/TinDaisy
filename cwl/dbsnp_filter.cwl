class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: dbsnp_filter
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
    label: VCF file to process.
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
  - id: bypass_dbsnp
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_dbsnp'
    label: Bypass dbSNP filter
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--debug'
    label: print out processing details to STDERR
  - id: dbsnp_db
    type: File?
    inputBinding:
      position: 0
      prefix: '--dbsnp_db'
    label: database for dbSNP filtering
    doc: Step will be skipped if not defined
outputs:
  - id: merged_vcf
    type: File
    outputBinding:
      glob: $(inputs.results_dir)/merged/merged.filtered.vcf
label: dbsnp_filter
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: dbsnp_filter
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl-dev'
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
