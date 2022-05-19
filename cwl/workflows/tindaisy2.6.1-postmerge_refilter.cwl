class: Workflow
cwlVersion: v1.0
id: tindaisy2_6_ffpe
label: TinDaisy2.6.1-postmerge_refilter
inputs:
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
  - id: vep_cache_gz
    type: File?
  - id: vep_cache_version
    type: string?
  - id: rescue_cosmic
    type: boolean?
  - id: rescue_clinvar
    type: boolean?
  - id: bypass_classification
    type: boolean?
    doc: Bypass classification filter
  - id: input_vcf
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
      - id: bypass
        default: false
        source: bypass_classification
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
  - id: merge_filter_td
    in:
      - id: input_vcf
        source: input_vcf
    out:
      - id: merged_vcf
    run: ../../submodules/MergeFilterVCF/cwl/FilterVCF_TinDaisy.cwl
    label: Merge_Filter_TD
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
requirements: []
