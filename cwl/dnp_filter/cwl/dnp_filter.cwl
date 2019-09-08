class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: dnp_filter
baseCommand:
  - python
  - /opt/dnp_filter/src/DNP_filter.py
inputs:
  - id: input
    type: File
    inputBinding:
      position: 0
      prefix: '--input'
    label: VCF file
  - id: bam
    type: File
    inputBinding:
      position: 0
      prefix: '--bam'
    label: tumor bam
    secondaryFiles:
      - .bai
  - id: threshold
    type: float?
    inputBinding:
      position: 0
      prefix: '--threshold'
    label: threshold
    doc: fraction of reads supporing DNP
  - id: output
    type: string
    inputBinding:
      position: 0
      prefix: '--output'
    label: output VCF file name
outputs:
  - id: filtered_VCF
    type: File
    outputBinding:
      glob: $(inputs.output)
label: DNP_filter
requirements:
  - class: DockerRequirement
    dockerPull: 'dinglab2/dnp_filter:20190905'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000

