class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: run_strelka2
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
  - id: strelka2_snv_vcf
    type: File
    outputBinding:
      glob: |-
        ${
            return  'results/strelka2/strelka_out/results/variants/somatic.snvs.vcf.gz'
        }
  - id: strelka2_indel_vcf
    type: File
    outputBinding:
      glob: |-
        ${
            return  'results/strelka2/strelka_out/results/variants/somatic.indels.vcf.gz'
        }
label: run_strelka2
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
    dockerPull: 'm_wyczalkowski/tindaisy-core:mutect'
  - class: InlineJavascriptRequirement
