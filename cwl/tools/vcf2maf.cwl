class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: vcf2maf
baseCommand:
  - /usr/local/bin/perl
  - /opt/vcf2maf.pl
inputs:
  - id: ref-fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--ref-fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: assembly
    type: string
    inputBinding:
      position: 0
      prefix: '--ncbi-build'
  - id: input-vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input-vcf'
outputs:
  - id: output
    type: File
    outputBinding:
      glob: result.maf
label: vcf2maf
arguments:
  - position: 0
    prefix: '--output-maf'
    valueFrom: result.maf
  - position: 0
    prefix: '--tumor-id'
    valueFrom: TUMOR
  - position: 0
    prefix: '--normal-id'
    valueFrom: NORMAL
  - position: 0
    prefix: ''
    valueFrom: '--inhibit-vep'
requirements:
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-vcf2maf:20200420'
  - class: ResourceRequirement
    ramMin: 2000
