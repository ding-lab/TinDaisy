class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: run_pindel
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--tumor_bam'
    secondaryFiles:
      - .bai
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
    secondaryFiles:
      - .bai
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: centromere_bed
    type: File?
    inputBinding:
      position: 0
      prefix: '--centromere_bed'
  - id: no_delete_temp
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--no_delete_temp'
    label: Don't delete temp files
    doc: 'If set, will not delete large temporary Pindel output'
  - id: pindel_config
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_config'
    label: pindel.ini
  - id: chrlist
    type: File?
    inputBinding:
      position: 0
      prefix: '--chrlist'
    label: chrom list
    doc: List of chromosomes for parallel processing
  - id: num_parallel_pindel
    type: int?
    inputBinding:
      position: 0
      prefix: '--num_parallel_pindel'
    label: Number chromosomes run in parallel
outputs:
  - id: pindel_raw
    type: File
    outputBinding:
      glob: |-
        ${
                return 'results/pindel/pindel_out/pindel-raw.dat'

        }
label: run_pindel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_pindel
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 16000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:20190415'
  - class: InlineJavascriptRequirement
