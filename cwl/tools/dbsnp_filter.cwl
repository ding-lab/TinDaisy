class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
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
    secondaryFiles:
      - .tbi
outputs:
  - id: filtered_vcf
    type: File
    outputBinding:
      glob: results/dbsnp_filter/dbsnp_pass.vcf
label: dbsnp_filter
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: dbsnp_filter
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'm_wyczalkowski/tindaisy-core:mutect-shiso'
  - class: InlineJavascriptRequirement
