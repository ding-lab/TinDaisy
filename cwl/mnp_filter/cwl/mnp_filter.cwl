class: CommandLineTool
cwlVersion: v1.0
id: mnp_filter
baseCommand:
  - /usr/local/bin/python
  - /opt/mnp_filter/src/mnp_filter.py
inputs:
  - id: input
    type: File
    inputBinding:
      position: 0
      prefix: '--input'
    label: VCF file
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--bam'
    label: tumor bam
    secondaryFiles:
      - .bai
outputs:
  - id: filtered_VCF
    type: File
    outputBinding:
      glob: MNP_combined.vcf
label: MNP_filter
arguments:
  - position: 0
    prefix: '--output'
    valueFrom: MNP_combined.vcf
requirements:
  - class: ResourceRequirement
    ramMin: 2000
  - class: DockerRequirement
    dockerPull: 'dinglab2/mnp_filter:20191211'
  - class: InlineJavascriptRequirement
