class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: stagefile
baseCommand:
  - cp
inputs:
  - id: staged_file
    type: File
    inputBinding:
      position: 0
outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.staged_file.basename)
label: StageFile
arguments:
  - position: 98
    prefix: ''
    valueFrom: .
requirements:
  - class: ResourceRequirement
    ramMin: 100
  - class: DockerRequirement
    dockerPull: 'alpine:latest'
  - class: InlineJavascriptRequirement
