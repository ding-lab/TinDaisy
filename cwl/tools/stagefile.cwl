class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: stagefile
baseCommand:
  - ln
  - '-s'
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
requirements:
  - class: ResourceRequirement
    ramMin: 100
  - class: DockerRequirement
    dockerPull: 'alpine:latest'
  - class: InlineJavascriptRequirement
