class: Workflow
cwlVersion: v1.0
id: tindaisy2
doc: >-
  TinDaisy2 workflow with VAF Rescue, where min_vaf_tumor=0 in a region defined
  by a rescue BED file. Restart at VAF Filter step
label: TinDaisy2 VAF Rescue Restart
inputs:
  - id: tumor_bam
    type: File
  - id: reference_fasta
    type: File
  - id: assembly
    type: string?
  - id: tumor_barcode
    type: string?
  - id: normal_barcode
    type: string?
  - id: canonical_BED
    type: File
  - id: af_config
    type: File
  - id: classification_config
    type: File
  - id: clinvar_annotation
    type: File?
    doc: ClinVar VEP custom annotation file
  - id: vep_cache_gz
    type: File?
  - id: vep_cache_version
    type: string?
  - id: rescue_cosmic
    type: boolean?
  - id: rescue_clinvar
    type: boolean?
  - id: RescueBED
    type: File
  - id: Strelka_SNV_VCF
    type: File
  - id: Strelka_Indel_VCF
    type: File
  - id: Mutect_VCF
    type: File
  - id: Varscan_SNV_VCF
    type: File
  - id: VARSCAN_indel_VCF
    type: File
  - id: Pindel_VCF
    type: File
outputs:
  - id: output_maf_clean
    outputSource:
      vcf2maf/output
    type: File?
  - id: output_vcf_clean
    outputSource:
      canonical_filter/output
    type: File
  - id: output_vcf_all
    outputSource:
      snp_indel_proximity_filter/output
    type: File
steps:
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
      - id: rescue_cosmic
        default: true
        source: rescue_cosmic
      - id: rescue_clinvar
        default: false
        source: rescue_clinvar
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
  - id: length_filter_varscan_snv
    in:
      - id: VCF
        source: rescuevaffilter_varscan_snv/output
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
  - id: length_filter_varscan_indel
    in:
      - id: VCF
        source: rescuevaffilter_varscan_indel/output
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
  - id: length_filter_strelka_snv
    in:
      - id: VCF
        source: rescuevaffilter_strelka_snv/output
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
  - id: length_filter_strelka_indel
    in:
      - id: VCF
        source: rescuevaffilter_strelka_indel/output
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
  - id: length_filter_pindel
    in:
      - id: VCF
        source: rescuevaffilter_pindel/output
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
  - id: length_filter_mutect
    in:
      - id: VCF
        source: rescuevaffilter_mutect/output
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
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
      - id: custom_filename
        source: clinvar_annotation
    out:
      - id: output_dat
    run: ../../submodules/VEP_annotate/cwl/vep_annotate.TinDaisy.cwl
    label: vep_annotate TinDaisy
  - id: rescuevaffilter_strelka_snv
    in:
      - id: VCF
        source: Strelka_SNV_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: strelka
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Strelka SNV
  - id: rescuevaffilter_strelka_indel
    in:
      - id: VCF
        source: Strelka_Indel_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: strelka
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Strelka Indel
  - id: rescuevaffilter_mutect
    in:
      - id: VCF
        source: Mutect_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: mutect
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Mutect
  - id: rescuevaffilter_varscan_snv
    in:
      - id: VCF
        source: Varscan_SNV_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: varscan
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Varscan SNV
  - id: rescuevaffilter_varscan_indel
    in:
      - id: VCF
        source: VARSCAN_indel_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: varscan
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Varscan Indel
  - id: rescuevaffilter_pindel
    in:
      - id: VCF
        source: Pindel_VCF
      - id: BED
        source: RescueBED
      - id: caller
        default: pindel
    out:
      - id: output
    run: ./rescuevaffilter.cwl
    label: Rescue VAF Filter - Pindel
requirements:
  - class: SubworkflowFeatureRequirement
