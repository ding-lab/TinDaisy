class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: stage_reference
baseCommand:
  - bash
  - /BICSEQ2/src/stage_file.sh
inputs:
  - id: FA
    type: File
    inputBinding:
      position: 99
    secondaryFiles:
      - .fai
outputs:
  - id: output
    type: File
    outputBinding:
      glob: staged_reference.fa
    secondaryFiles:
      - .fai
doc: >-
  Not working.  Also need to stage .dict secondary files, which isn't
  implemented here
label: stage_reference
arguments:
  - position: 0
    prefix: '-s'
    valueFrom: .fai
  - position: 0
    prefix: '-p'
    valueFrom: hard
  - position: 0
    prefix: '-o'
    valueFrom: staged_reference.fa
requirements:
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/bicseq2:20210625'
