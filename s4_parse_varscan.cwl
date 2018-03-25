class: CommandLineTool
cwlVersion: v1.0
id: s4_parse_varscan
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: varscan_indel_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_indel_raw'
  - id: varscan_snv_raw
    type: File
    inputBinding:
      position: 0
      prefix: '--varscan_snv_raw'
outputs:
  - id: varscan_snv_process
    type: File?
    outputBinding:
      glob: varscan/filter_out/varscan.out.som_snv.Somatic.hc.vcf
  - id: varscan_indel_process
    type: File?
    outputBinding:
      glob: varscan/filter_out/varscan.out.som_indel.Somatic.hc.vcf
  - id: varscan_snv_filtered
    type: File?
    outputBinding:
      glob: varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf
  - id: varscan_snv_dbsnp
    doc: Final SNV output of parsing
    type: File
    outputBinding:
      glob: >-
        varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf
  - id: varscan_indel_dbsnp
    doc: Final SNV output of parsing
    type: File
    outputBinding:
      glob: varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf
label: s4_parse_varscan
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '4'
  - position: 0
    prefix: '--results_dir'
    valueFrom: .
  - position: 0
    prefix: '--dbsnp_db'
    valueFrom: /usr/local/StrelkaDemo/image/B_Filter/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    varscan_indel_raw:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    varscan_snv_raw:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
  runtime:
    cores: 1
    ram: 1000
