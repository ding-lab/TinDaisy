class: Workflow
cwlVersion: v1.0
id: tindaisy2
label: TinDaisy2
inputs:
  - id: tumor_bam
    type: File
  - id: normal_bam
    type: File
  - id: reference_fasta
    type: File
  - id: pindel_config
    type: File
  - id: varscan_config
    type: File
  - id: assembly
    type: string?
  - id: centromere_bed
    type: File?
  - id: strelka_config
    type: File
  - id: chrlist
    type: File?
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: canonical_BED
    type: File
  - id: call_regions
    type: File?
  - id: af_config
    type: File
  - id: classification_config
    type: File
  - id: custom_filename
    type: File?
  - id: vep_cache_gz
    type: File?
outputs:
  - id: output_maf
    outputSource:
      vcf2maf/output
    type: File?
  - id: output_vcf
    outputSource:
      canonical_filter/output
    type: File
steps:
  - id: run_pindel
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: centromere_bed
        source: centromere_bed
      - id: pindel_config
        source: pindel_config
      - id: chrlist
        source: chrlist
      - id: num_parallel_pindel
        default: 5
    out:
      - id: pindel_raw
    run: ../tools/run_pindel.cwl
    label: run_pindel
  - id: run_varscan
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel_raw
      - id: varscan_snv_raw
    run: ../tools/run_varscan.cwl
    label: run_varscan
  - id: parse_pindel
    in:
      - id: pindel_raw
        source: run_pindel/pindel_raw
      - id: reference_fasta
        source: reference_fasta
      - id: pindel_config
        source: pindel_config
    out:
      - id: pindel_vcf
    run: ../tools/parse_pindel.cwl
    label: parse_pindel
  - id: parse_varscan_snv
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_snv_raw
        source: run_varscan/varscan_snv_raw
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_snv
    run: ../tools/parse_varscan_snv.cwl
    label: parse_varscan_snv
  - id: parse_varscan_indel
    in:
      - id: varscan_indel_raw
        source: run_varscan/varscan_indel_raw
      - id: varscan_config
        source: varscan_config
    out:
      - id: varscan_indel
    run: ../tools/parse_varscan_indel.cwl
    label: parse_varscan_indel
  - id: mutect
    in:
      - id: normal
        source: normal_bam
      - id: reference
        source: reference_fasta
      - id: tumor
        source: tumor_bam
    out:
      - id: call_stats
      - id: coverage
      - id: mutations
    run: ../../submodules/mutect-tool/cwl/mutect.cwl
    label: MuTect
  - id: run_strelka2
    in:
      - id: tumor_bam
        source: tumor_bam
      - id: normal_bam
        source: normal_bam
      - id: reference_fasta
        source: reference_fasta
      - id: strelka_config
        source: strelka_config
      - id: call_regions
        source: call_regions
      - id: num_parallel_strelka2
        default: 4
    out:
      - id: strelka2_snv_vcf
      - id: strelka2_indel_vcf
    run: ../tools/run_strelka2.cwl
    label: run_strelka2
  - id: mnp_filter
    in:
      - id: input
        source: merge_filter_td/merged_vcf
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_VCF
    run: ../../submodules/mnp_filter/cwl/mnp_filter.cwl
    label: MNP_filter
  - id: vcf2maf
    in:
      - id: ref-fasta
        source: reference_fasta
      - id: assembly
        source: assembly
      - id: input-vcf
        source: canonical_filter/output
      - id: tumor_barcode
        source: tumor_barcode
      - id: normal_barcode
        source: normal_barcode
    out:
      - id: output
    run: ../../submodules/vcf2maf-CWL/cwl/vcf2maf.cwl
    label: vcf2maf
  - id: varscan_indel_vcf_remap
    in:
      - id: input
        source: parse_varscan_indel/varscan_indel
    out:
      - id: remapped_VCF
    run: ../../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_indel_vcf_remap
  - id: varscan_snv_vcf_remap
    in:
      - id: input
        source: parse_varscan_snv/varscan_snv
    out:
      - id: remapped_VCF
    run: ../../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_snv_vcf_remap
  - id: canonical_filter
    in:
      - id: VCF_A
        source: snp_indel_proximity_filter/output
      - id: BED
        source: canonical_BED
      - id: keep_only_pass
        default: true
      - id: filter_name
        default: canonical
    out:
      - id: output
    run: ../../submodules/HotspotFilter/cwl/hotspotfilter.cwl
    label: CanonicalFilter
  - id: snp_indel_proximity_filter
    in:
      - id: input
        source: dbsnp_filter/output
      - id: distance
        default: 5
    out:
      - id: output
    run: >-
      ../../submodules/SnpIndelProximityFilter/cwl/snp_indel_proximity_filter.cwl
    label: snp_indel_proximity_filter
  - id: af_filter
    in:
      - id: VCF
        source: vep_annotate__tin_daisy/output_dat
      - id: config
        source: af_config
    out:
      - id: output
    run: ../../submodules/VEP_Filter/cwl/af_filter.cwl
    label: AF_Filter
  - id: classification_filter
    in:
      - id: VCF
        source: af_filter/output
      - id: config
        source: classification_config
    out:
      - id: output
    run: ../../submodules/VEP_Filter/cwl/classification_filter.cwl
    label: Classification_Filter
  - id: dbsnp_filter
    in:
      - id: VCF
        source: classification_filter/output
    out:
      - id: output
    run: ../../submodules/VEP_Filter/cwl/dbsnp_filter.cwl
    label: DBSNP_Filter
  - id: merge_vcf_td
    in:
      - id: reference
        source: reference_fasta
      - id: strelka_snv_vcf
        source: depth_filter_strelka_snv/output
      - id: strelka_indel_vcf
        source: depth_filter_strelka_indel/output
      - id: varscan_snv_vcf
        source: depth_filter_varscan_snv/output
      - id: varscan_indel_vcf
        source: depth_filter_varscan_indel/output
      - id: mutect_vcf
        source: depth_filter_mutect/output
      - id: pindel_vcf
        source: depth_filter_pindel/output
    out:
      - id: merged_vcf
    run: ../../submodules/MergeFilterVCF/cwl/MergeVCF_TinDaisy.cwl
    label: Merge_VCF_TD
  - id: merge_filter_td
    in:
      - id: input_vcf
        source: merge_vcf_td/merged_vcf
    out:
      - id: merged_vcf
    run: ../../submodules/MergeFilterVCF/cwl/FilterVCF_TinDaisy.cwl
    label: Merge_Filter_TD
  - id: somatic_vaf_filter_varscan_snv
    in:
      - id: VCF
        source: varscan_snv_vcf_remap/remapped_VCF
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        default: varscan
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF varscan snv
  - id: length_filter_varscan_snv
    in:
      - id: VCF
        source: somatic_vaf_filter_varscan_snv/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length varscan snv
  - id: depth_filter_varscan_snv
    in:
      - id: VCF
        source: length_filter_varscan_snv/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: varscan
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth Filter varscan snv
  - id: somatic_vaf_filter_varscan_indel
    in:
      - id: VCF
        source: varscan_indel_vcf_remap/remapped_VCF
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: -20
      - id: caller
        default: varscan
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF varscan indel
  - id: length_filter_varscan_indel
    in:
      - id: VCF
        source: somatic_vaf_filter_varscan_indel/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length Filter varscan indel
  - id: depth_filter_varscan_indel
    in:
      - id: VCF
        source: length_filter_varscan_indel/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: varscan
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth Filter varscan indel
  - id: somatic_vaf_filter_strelka_snv
    in:
      - id: VCF
        source: run_strelka2/strelka2_snv_vcf
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        default: strelka
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF strelka snv
  - id: length_filter_strelka_snv
    in:
      - id: VCF
        source: somatic_vaf_filter_strelka_snv/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length Filter strelka snv
  - id: depth_filter_strelka_snv
    in:
      - id: VCF
        source: length_filter_strelka_snv/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: strelka
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth Filter strelka snv
  - id: somatic_vaf_filter_strelka_indel
    in:
      - id: VCF
        source: run_strelka2/strelka2_indel_vcf
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        default: strelka
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF strelka indel
  - id: length_filter_strelka_indel
    in:
      - id: VCF
        source: somatic_vaf_filter_strelka_indel/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length stelka indel
  - id: depth_filter_strelka_indel
    in:
      - id: VCF
        source: length_filter_strelka_indel/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: strelka
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth strelka indel
  - id: somatic_vaf_filter_pindel
    in:
      - id: VCF
        source: parse_pindel/pindel_vcf
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        default: pindel
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF pindel
  - id: length_filter_pindel
    in:
      - id: VCF
        source: somatic_vaf_filter_pindel/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length Pindel
  - id: depth_filter_pindel
    in:
      - id: VCF
        source: length_filter_pindel/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: pindel
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth Pindel
  - id: somatic_vaf_filter_mutect
    in:
      - id: VCF
        source: mutect/mutations
      - id: min_vaf_tumor
        default: 0.05
      - id: max_vaf_normal
        default: 0.02
      - id: caller
        default: mutect
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_vaf_filter.cwl
    label: Somatic VAF Mutect
  - id: length_filter_mutect
    in:
      - id: VCF
        source: somatic_vaf_filter_mutect/output
      - id: min_length
        default: 0
      - id: max_length
        default: 100
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/length_filter.cwl
    label: Length Mutect
  - id: depth_filter_mutect
    in:
      - id: VCF
        source: length_filter_mutect/output
      - id: min_depth_tumor
        default: 14
      - id: min_depth_normal
        default: 8
      - id: caller
        default: mutect
    out:
      - id: output
    run: ../../submodules/VLD_FilterVCF/cwl/somatic_depth_filter.cwl
    label: Depth Mutect
  - id: vep_annotate__tin_daisy
    in:
      - id: input_vcf
        source: mnp_filter/filtered_VCF
      - id: reference_fasta
        source: reference_fasta
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: custom_filename
        source: custom_filename
    out:
      - id: output_dat
    run: ../../submodules/VEP_annotate/cwl/vep_annotate.TinDaisy.cwl
    label: vep_annotate TinDaisy
requirements: []
