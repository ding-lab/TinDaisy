class: CommandLineTool
cwlVersion: v1.0
id: snp_indel_proximity_filter
baseCommand:
  - /bin/bash
  - /opt/SnpIndelProximityFilter/src/run_SnpIndelProximityFilter.sh
inputs:
  - id: input
    type: File
    inputBinding:
      position: 10
    label: VCF file
  - id: debug
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-v'
  - id: distance
    type: int?
    inputBinding:
      position: 0
      prefix: '-D'
    doc: >-
      Minimum distance between snv and nearest indel required to retain snv
      call.  Default is 5
  - id: remove_filtered
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-N'
    doc: >-
      Remove filtered variants.  Default is to retain filtered variants with
      "proximity" in VCF FILTER field
outputs:
  - id: output
    type: File
    outputBinding:
      glob: output/ProximityFiltered.vcf
label: snp_indel_proximity_filter
arguments:
  - position: 0
    prefix: '-o'
    valueFrom: output/ProximityFiltered.vcf
requirements:
  - class: ResourceRequirement
    ramMin: 2000
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/snp_indel_proximity_filter:20200513'
  - class: InlineJavascriptRequirement
