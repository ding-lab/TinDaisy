class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: vcf_2_maf
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
    type: string?
    inputBinding:
      position: 0
      prefix: '--assembly'
    label: assembly name for VEP annotation
    doc: Either GRCh37 or GRCh38 currently accepted
  - id: vep_cache_version
    type: string?
    inputBinding:
      position: 0
      prefix: '--vep_cache_version'
    label: 'VEP Cache Version (e.g., 90)'
  - id: vep_cache_gz
    type: File?
    inputBinding:
      position: 0
      prefix: '--vep_cache_gz'
    label: VEP Cache .tar.gz
    doc: >-
      if defined, extract contents into "./vep-cache" and use VEP cache. 
      Otherwise, skip this step entirely
  - id: exac
    type: File?
    inputBinding:
      position: 0
      prefix: '--exac'
    label: ExAC database for custom annotation
    doc: Passed to vcf_2_maf.pl as --filter-vcf
  - id: bypass_vcf2maf
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--skip'
      valueFrom: 'bypass_vcf2maf'
    label: Do not perform vcf2maf conversion
    doc: Necessary if vep_cache_gz not defined
outputs:
  - id: output_maf
    type: File?
    outputBinding:
      glob: results/maf/output.maf
label: vcf_2_maf
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: vcf_2_maf
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 2000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:20191108'
  - class: InlineJavascriptRequirement
