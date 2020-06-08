class: CommandLineTool
cwlVersion: v1.0
id: varscan_vcf_remap
baseCommand:
  - /usr/local/bin/python
  - /opt/varscan_vcf_remap/src/varscan_vcf_remap.py
inputs:
  - id: input
    type: File
    inputBinding:
      position: 0
      prefix: '--input'
    label: VCF file
  - id: output
    type: string
    inputBinding:
      position: 0
      prefix: '--output'
    label: output VCF file name
outputs:
  - id: remapped_VCF
    type: File
    outputBinding:
      glob: $(inputs.output)
label: varscan_vcf_remap
requirements:
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/varscan_vcf_remap:20191228'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000

