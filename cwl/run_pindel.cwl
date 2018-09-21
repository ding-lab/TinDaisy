class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: run_pindel
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
      - .fai
      - ^.dict
  - id: centromere_bed
    type: File?
    inputBinding:
      position: 0
      prefix: '--centromere_bed'
  - id: no_delete_temp
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--no_delete_temp'
    label: Don't delete temp files
    doc: 'If set, will not delete large temporary Pindel output'
  - id: results_dir
    type: string?
    inputBinding:
      position: 0
      prefix: '--results_dir'
  - id: pindel_config
    type: File
    inputBinding:
      position: 0
      prefix: '--pindel_config'
    label: pindel.ini
outputs:
  - id: pindel_raw
    type: File
    outputBinding:
      glob: |-
        ${
                return inputs.results_dir + '/pindel/pindel_out/pindel-raw.dat'

        }
label: run_pindel
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_pindel
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl-dev'
  - class: InlineJavascriptRequirement
'sbg:job':
  inputs:
    centromere_bed:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    no_delete_temp: 9
    normal_bam:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
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
    tumor_bam:
      basename: t.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: t
      path: /path/to/t.ext
      secondaryFiles: []
      size: 0
  runtime:
    cores: 1
    ram: 8000
