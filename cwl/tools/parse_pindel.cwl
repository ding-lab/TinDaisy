class: CommandLineTool
cwlVersion: v1.0
id: parse_pindel
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: pindel_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_raw'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: pindel_config
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_config'
  - id: no_delete_temp
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--no_delete_temp'
    doc: 'If set, do not delete large temporary files'
  - id: bypass_cvs
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_cvs'
    label: skip filtering for CvgVafStrand
  - id: bypass_homopolymer
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--bypass_homopolymer'
    label: skip filtering for Homopolymer
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--debug'
    label: print out processing details to STDERR
outputs:
  - id: pindel_vcf
    type: File
    outputBinding:
      glob: >-
        results/pindel/filter_out/pindel-raw.dat.CvgVafStrand_pass.Homopolymer_pass.vcf
label: parse_pindel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: parse_pindel
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:pindel-chrom'
  - class: InlineJavascriptRequirement
