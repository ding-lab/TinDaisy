class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: stage_bam
baseCommand:
  - bash
  - /BICSEQ2/src/stage_file.sh
inputs:
  - id: BAM
    type: File
    inputBinding:
      position: 99
    secondaryFiles:
      - .bai
outputs:
  - id: output
    type: File
    outputBinding:
      glob: staged_data.bam
    secondaryFiles:
      - .bai
label: stage_bam
arguments:
  - position: 0
    prefix: '-s'
    valueFrom: .bai
  - position: 0
    prefix: '-p'
    valueFrom: hard
  - position: 0
    prefix: '-o'
    valueFrom: staged_data.bam
requirements:
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/bicseq2:20210625'
  - class: ResourceRequirement
    ramMin: 8000
