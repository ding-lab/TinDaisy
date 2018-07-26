#!/bin/bash
export JAVA_OPTS="-Xmx2g"
 java $JAVA_OPTS -jar /usr/local/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar -R /data/demo20.fa -T CombineVariants -o ./results/merged/merged.vcf --variant:varscan ./results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.vcf --variant:strelka ./results/strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.vcf --variant:varindel ./results/varscan/filter_out/varscan.out.som_indel.Somatic.hc.vcf --variant:pindel ./results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf -genotypeMergeOptions PRIORITIZE -priority strelka,varscan,pindel,varindel


echo Written final result to ./results/merged/merged.vcf

