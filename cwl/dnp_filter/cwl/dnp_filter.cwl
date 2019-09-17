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
  - id: tumor_bam
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
outputs:
  - id: filtered_VCF
    type: File
    outputBinding:
      glob: DNP_combined.vcf
label: DNP_filter
arguments:
    - position: 0
      prefix: '--output'
      valueFrom: DNP_combined.vcf
requirements:
  - class: DockerRequirement
    dockerPull: 'dinglab2/dnp_filter:20190916'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000

