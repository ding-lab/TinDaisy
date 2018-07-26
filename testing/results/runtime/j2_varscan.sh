#!/bin/bash
JAVA_OPTS="-Xms256m -Xmx512m"

#echo Log to ./results/varscan/varscan_out/varscan.out.som.log

SAMTOOLS_CMD="/usr/local/bin/samtools mpileup -q 1 -Q 13 -B -f /data/demo20.fa -b ./results/varscan/varscan_out/bamfilelist.inp "

JAVA_CMD="java $JAVA_OPTS -jar /usr/local/VarScan.jar somatic - varscan.out.som --mpileup 1 --p-value 0.99 --somatic-p-value 0.05 --min-coverage-normal 20 --min-coverage-tumor 20 --min-var-freq 0.05 --min-freq-for-hom 0.75 --normal-purity 1.00 --tumor-purity 1.00 --strand-filter 1 --min-avg-qual 15 --output-vcf 1 --output-snp ./results/varscan/varscan_out/varscan.out.som_snv --output-indel ./results/varscan/varscan_out/varscan.out.som_indel"

$SAMTOOLS_CMD | $JAVA_CMD # &> ./results/varscan/varscan_out/varscan.out.som.log

