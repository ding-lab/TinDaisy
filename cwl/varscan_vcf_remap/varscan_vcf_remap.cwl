class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
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
outputs:
  - id: remapped_VCF
    type: File
    outputBinding:
      glob: varscan-remapped.vcf
label: varscan_vcf_remap
arguments:
  - position: 0
    prefix: '--output'
    valueFrom: varscan-remapped.vcf
requirements:
  - class: ResourceRequirement
    ramMin: 2000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/varscan_vcf_remap:20191227'
  - class: InlineJavascriptRequirement
