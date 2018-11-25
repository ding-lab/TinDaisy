class: CommandLineTool
cwlVersion: v1.0
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
      - .bai
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
    secondaryFiles:
      - .bai
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
  - id: manta_vcf
    type: File?
    inputBinding:
      position: 0
      prefix: '--manta_vcf'
    label: Output from Manta
    doc: Optional file for use with strelka2 processing
outputs:
  - id: strelka2_vcf
    type: File
    outputBinding:
      glob: |-
        ${
            return  'results/strelka/strelka_out/results/variants/somatic.snvs.vcf.gz'
        }
label: run_strelka
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: run_strelka2
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:latest'
  - class: InlineJavascriptRequirement
