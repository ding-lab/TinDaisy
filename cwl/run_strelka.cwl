class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: run_strelka
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--tumor_bam'
    secondaryFiles:
      - ^.bai
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
    secondaryFiles:
      - ^.bai
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - ^.dict
      - .fai
  - id: strelka_config
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_config'
  - id: results_dir
    type: string
    inputBinding:
      position: 0
      prefix: '--results_dir'
    label: Results directory name
    doc: Apparently should not have '.' in it
outputs:
  - id: snvs_passed
    type: File
    outputBinding:
      glob: |-
        ${
            
            return  inputs.results_dir + '/strelka/strelka_out/results/passed.somatic.snvs.vcf'
        }
label: run_strelka
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_strelka
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl-dev'
  - class: InlineJavascriptRequirement
'sbg:job':
  inputs:
    normal_bam:
      basename: n.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: 'n'
      path: /path/to/n.ext
      secondaryFiles: []
      size: 0
    reference_fasta:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    strelka_config:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    tumor_bam:
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
