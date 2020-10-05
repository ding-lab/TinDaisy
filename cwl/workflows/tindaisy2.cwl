class: Workflow
cwlVersion: v1.0
id: tindaisy2
label: TinDaisy2
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: tumor_bam
    type: File
    'sbg:x': 0
    'sbg:y': 214
  - id: normal_bam
    type: File
    'sbg:x': 0
    'sbg:y': 749
  - id: reference_fasta
    type: File
    'sbg:x': 0
    'sbg:y': 535
  - id: pindel_config
    type: File
    'sbg:x': 0
    'sbg:y': 642
  - id: varscan_config
    type: File
    'sbg:x': 0
    'sbg:y': 107
  - id: assembly
    type: string?
    'sbg:x': 3077.1396484375
    'sbg:y': 702.5
  - id: centromere_bed
    type: File?
    'sbg:x': 0
    'sbg:y': 963
  - id: strelka_config
    type: File
    'sbg:x': 0
    'sbg:y': 428
  - id: chrlist
    type: File?
    'sbg:x': 0
    'sbg:y': 856
  - id: tumor_barcode
    type: string?
    'sbg:x': 3077.1396484375
    'sbg:y': 367.5
  - id: normal_barcode
    type: string?
    'sbg:x': 3077.1396484375
    'sbg:y': 474.5
  - id: canonical_BED
    type: File
    'sbg:x': 2905.7177734375
    'sbg:y': 588.5
  - id: call_regions
    type: File?
    'sbg:x': 0
    'sbg:y': 1070
  - id: af_config
    type: File
    'sbg:x': 2122.32080078125
    'sbg:y': 588.5
  - id: classification_config
    type: File
    'sbg:x': 2378.83203125
    'sbg:y': 474.5
  - id: custom_filename
    type: File?
    label: VEP custom annotation filename
    secondaryFiles:
      - .tbi
    'sbg:x': 1892.5865478515625
    'sbg:y': 588.5
outputs:
  - id: output_maf
    outputSource:
      - vcf2maf/output
    type: File?
    'sbg:x': 3547.4052734375
    'sbg:y': 535
  - id: output_vcf
    outputSource:
      - canonical_filter/output
    type: File
    'sbg:x': 3255.6552734375
    'sbg:y': 588.5
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
    'sbg:x': 247.28125
    'sbg:y': 549
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
    'sbg:x': 243.79010009765625
    'sbg:y': -300.6715393066406
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
    'sbg:x': 707.6153564453125
    'sbg:y': 227.45538330078125
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
    'sbg:x': 643.09033203125
    'sbg:y': -407.66192626953125
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
    'sbg:x': 636.1080322265625
    'sbg:y': -251.73277282714844
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
    'sbg:x': 247.28125
    'sbg:y': 812
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
    'sbg:x': 708.333740234375
    'sbg:y': 14.126938819885254
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
    'sbg:x': 2700.294677734375
    'sbg:y': -36.31415557861328
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
    'sbg:x': 4072.21630859375
    'sbg:y': 181.78408813476562
  - id: varscan_indel_vcf_remap
    in:
      - id: input
        source: parse_varscan_indel/varscan_indel
    out:
      - id: remapped_VCF
    run: ../../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_indel_vcf_remap
    'sbg:x': 959.7293701171875
    'sbg:y': -247.0338897705078
  - id: varscan_snv_vcf_remap
    in:
      - id: input
        source: parse_varscan_snv/varscan_snv
    out:
      - id: remapped_VCF
    run: ../../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_snv_vcf_remap
    'sbg:x': 963.2205200195312
    'sbg:y': -402.909912109375
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
    'sbg:x': 3840.68701171875
    'sbg:y': -13.314231872558594
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
    'sbg:x': 3654.412353515625
    'sbg:y': -16.82394790649414
  - id: af_filter
    in:
      - id: VCF
        source: vep_annotate/output_dat
      - id: config
        source: af_config
    out:
      - id: output
    run: ../../submodules/VEP_Filter/cwl/af_filter.cwl
    label: AF_Filter
    'sbg:x': 3132.765380859375
    'sbg:y': -27.588754653930664
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
    'sbg:x': 3266.82421875
    'sbg:y': -7.2945685386657715
  - id: dbsnp_filter
    in:
      - id: VCF
        source: classification_filter/output
    out:
      - id: output
    run: ../../submodules/VEP_Filter/cwl/dbsnp_filter.cwl
    label: DBSNP_Filter
    'sbg:x': 3479.43212890625
    'sbg:y': -19.922035217285156
  - id: vep_annotate
    in:
      - id: input_vcf
        source: mnp_filter/filtered_VCF
      - id: reference_fasta
        source: reference_fasta
      - id: custom_filename
        source: custom_filename
      - id: custom_args
        default: >-
          --hgvs --shift_hgvs 1 --no_escape --symbol --numbers --ccds --uniprot
          --xref_refseq --sift b --tsl --canonical --total_length
          --allele_number --variant_class --biotype --appris --flag_pick_allele
          --check_existing --failed 1 --minimal --pick_order
          biotype,rank,canonical --af --max_af --af_1kg --af_esp --af_gnomad
          --buffer_size 500  --fork 4
    out:
      - id: output_dat
    run: ../../submodules/VEP_annotate/cwl/vep_annotate.TinDaisy.cwl
    label: vep_annotate
    'sbg:x': 2935.647705078125
    'sbg:y': -37.96120834350586
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
    'sbg:x': 2309.96484375
    'sbg:y': -22.929224014282227
  - id: merge_filter_td
    in:
      - id: input_vcf
        source: merge_vcf_td/merged_vcf
    out:
      - id: merged_vcf
    run: ../../submodules/MergeFilterVCF/cwl/FilterVCF_TinDaisy.cwl
    label: Merge_Filter_TD
    'sbg:x': 2539.333984375
    'sbg:y': -25.274982452392578
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
    'sbg:x': 1264.035400390625
    'sbg:y': -398
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
    'sbg:x': 1522.6505126953125
    'sbg:y': -395.3494567871094
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
    'sbg:x': 1728.111083984375
    'sbg:y': -395.7697448730469
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
    'sbg:x': 1261.3985595703125
    'sbg:y': -249.64454650878906
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
    'sbg:x': 1503.8115234375
    'sbg:y': -238.44886779785156
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
    'sbg:x': 1740.6014404296875
    'sbg:y': -249.4919891357422
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
    'sbg:x': 1255.0533447265625
    'sbg:y': -83.0473403930664
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
    'sbg:x': 1532.716064453125
    'sbg:y': -85.08877563476562
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
    'sbg:x': 1759.2783203125
    'sbg:y': -86.35511016845703
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
    'sbg:x': 1258.6771240234375
    'sbg:y': 96.33328247070312
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
    'sbg:x': 1530.97314453125
    'sbg:y': 96.33328247070312
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
    'sbg:x': 1754.1329345703125
    'sbg:y': 118.85400390625
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
    'sbg:x': 1246.39306640625
    'sbg:y': 276.4990539550781
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
    'sbg:x': 1537.1151123046875
    'sbg:y': 305.16180419921875
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
    'sbg:x': 1754.1329345703125
    'sbg:y': 313.3511657714844
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
    'sbg:x': 1234.109130859375
    'sbg:y': 855.895751953125
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
    'sbg:x': 1526.87841796875
    'sbg:y': 888.6530151367188
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
    'sbg:x': 1762.932373046875
    'sbg:y': 755.5713500976562
requirements: []
