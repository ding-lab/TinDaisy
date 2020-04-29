class: CommandLineTool
cwlVersion: v1.0
id: hotspotfilter
baseCommand:
  - /bin/bash
  - /opt/HotspotFilter/src/hotspot_filter.sh
inputs:
  - id: VCF_A
    type: File
    inputBinding:
      position: 0
      prefix: '-A'
  - id: VCF_B
    type: File?
    inputBinding:
      position: 0
      prefix: '-B'
  - id: BED
    type: File
    inputBinding:
      position: 0
      prefix: '-D'
outputs:
  - id: output
    type: File
    outputBinding:
      glob: output/HotspotFiltered.vcf
label: HotspotFilter
arguments:
  - position: 0
    prefix: '-o'
    valueFrom: output/HotspotFiltered.vcf
requirements:
  - class: ResourceRequirement
    ramMin: 1000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/hotspot_filter:20200428'
