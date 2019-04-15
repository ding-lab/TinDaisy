class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: vep_annotate
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: input_vcf
    type: File
    inputBinding:
      position: 0
      prefix: '--input_vcf'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
    secondaryFiles:
      - .fai
      - ^.dict
  - id: assembly
    type: string?
    inputBinding:
      position: 0
      prefix: '--assembly'
    label: assembly name for VEP annotation
    doc: Either GRCh37 or GRCh38 currently accepted
  - id: vep_cache_version
    type: string?
    inputBinding:
      position: 0
      prefix: '--vep_cache_version'
    label: 'VEP Cache Version (e.g., 93)'
  - id: vep_cache_gz
    type: File?
    inputBinding:
      position: 0
      prefix: '--vep_cache_gz'
    label: VEP Cache .tar.gz file
    doc: >-
      if defined, extract contents into "./vep-cache" and use VEP cache. 
      Otherwise, perform (much slower) online VEP DB lookups
outputs:
  - id: output_dat
    type: File
    outputBinding:
      glob: results/vep/output_vep.vcf
label: vep_annotate
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: vep_annotate
  - position: 0
    prefix: '--results_dir'
    valueFrom: results
  - position: 0
    prefix: '--vep_opts'
    valueFrom: '--hgvs --shift_hgvs 1 --no_escape --symbol --numbers --ccds --uniprot --xref_refseq --sift b --tsl --canonical --total_length --allele_number --variant_class --biotype --flag_pick_allele --pick_order tsl,biotype,rank,canonical,ccds,length'
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/tindaisy-core:20190415'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000



