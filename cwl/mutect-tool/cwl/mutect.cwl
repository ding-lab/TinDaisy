cwlVersion: v1.0
class: CommandLineTool
label: MuTect
baseCommand: ["python", "/opt/mutect-tool/src/mutect-tool.py", "--workdir", "."]
requirements:
  - class: DockerRequirement
    dockerPull: dinglab2/mutect-tool:20190313
  - class: EnvVarRequirement
    envDef:
      - envName: JAVA_OPTS
        envValue: -Xmx1g

inputs:
  tumor:
    type: File
    inputBinding:
      prefix: --input_file:tumor
    secondaryFiles:
      - .bai
  normal:
    type: File
    inputBinding:
      prefix: --input_file:normal
    secondaryFiles:
      - .bai
  reference:
    type: File
    inputBinding:
      prefix: --reference_sequence
    secondaryFiles:
      - .fai
      - ^.dict
  cosmic:
    type: File?
    inputBinding:
      prefix: --cosmic
    secondaryFiles: .tbi
  dbsnp:
    type: File?
    inputBinding:
      prefix: --dbsnp
    secondaryFiles: .tbi
  tumor_lod:
    type: float?
    default: 6.3
    inputBinding:
      prefix: --tumor_lod
  initial_tumor_lod:
    type: float?
    default: 4.0
    inputBinding:
      prefix: --initial_tumor_lod
  out:
    type: string?
    default: mutect_call_stats.txt
    inputBinding:
      prefix: --out
  coverage_file:
    type: string?
    default: mutect_coverage.wig.txt
    inputBinding:
      prefix: --coverage_file
  vcf:
    type: string
    default: mutect.vcf
    inputBinding:
      prefix: --vcf
  ncpus:
    type: int?
    default: 8
    inputBinding:
      prefix: "--ncpus"
  keep_filtered:
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--keep_filtered'
    label: Retain REJECT variants

outputs:
  coverage:
    type: File?
    outputBinding:
      glob: $(inputs.coverage_file)
  call_stats:
    type: File?
    outputBinding:
      glob: $(inputs.out)
  mutations:
    type: File
    outputBinding:
      glob: $(inputs.vcf)
