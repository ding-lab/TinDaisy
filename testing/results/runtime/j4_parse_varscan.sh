#!/bin/bash
export JAVA_OPTS="-Xms256m -Xmx10g"

echo 'APPLYING PROCESS FILTER TO SOMATIC SNVS:' # &> ./results/varscan/filter_out/varscan.out.som.log
# Script below creates the following in the same directory as the input data
# The inability to define output directory complicates things
    # varscan.out.som_snv.Somatic.hc.vcf      -> used for SNV SNP filter below and vep annotation
    # varscan.out.som_snv.Somatic.vcf        
    # varscan.out.som_snv.LOH.hc.vcf         
    # varscan.out.som_snv.LOH.vcf            
    # varscan.out.som_snv.Germline.hc.vcf    
    # varscan.out.som_snv.Germline.vcf       
java ${JAVA_OPTS} -jar /usr/local/VarScan.jar processSomatic ./results/varscan/filter_out/varscan.out.som_snv.vcf --min-tumor-freq 0.05 --max-normal-freq 0.05 --p-value 0.05 /varscan # &>> ./results/varscan/filter_out/varscan.out.som.log

echo 'APPLYING PROCESS FILTER TO SOMATIC INDELS:' # &>> ./results/varscan/filter_out/varscan.out.som.log
# Script below creates:
    # varscan.out.som_indel.Germline.hc.vcf    
    # varscan.out.som_indel.Germline.vcf       
    # varscan.out.som_indel.LOH.hc.vcf         
    # varscan.out.som_indel.LOH.vcf            
    # varscan.out.som_indel.Somatic.hc.vcf     -> used for Indel SnP Filter below and vep annotation
    # varscan.out.som_indel.Somatic.vcf        
java ${JAVA_OPTS} -jar /usr/local/VarScan.jar processSomatic ./results/varscan/filter_out/varscan.out.som_indel.vcf   --min-tumor-freq 0.05 --max-normal-freq 0.05 --p-value 0.05  # &>> ./results/varscan/filter_out/varscan.out.som.log


### Somatic Filter filters SNV based on indel
# http://varscan.sourceforge.net/using-varscan.html#v2.3_somaticFilter
echo 'APPLYING SOMATIC FILTER:' # &>> ./results/varscan/filter_out/varscan.out.som.log

# Script below creates:
    # varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf   -> used for SNV dbSnP and vep annotation
java ${JAVA_OPTS} -jar /usr/local/VarScan.jar somaticFilter  ./results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.vcf --min-coverage 20 --min-reads2 4 --min-strands2 1 --min-avg-qual 20 --min-var-freq 0.05 --p-value 0.05  --indel-file  ./results/varscan/filter_out/varscan.out.som_indel.vcf --output-file  ./results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf  # &>> ./results/varscan/filter_out/varscan.out.som.log   

### dbSnP Filter

# 1) SNV
# Script below reads:  
    # varscan.out.som_snv.Somatic.hc.somfilter_pass.vcf
# and generates:
    # varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_present.vcf  
    # varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf     -> used for merge_vcf
    # varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_anno.vcf   
/usr/bin/perl /usr/local/somaticwrapper/GenomeVIP/dbsnp_filter.pl  ./results/varscan/filter_out/vs_dbsnp_filter.snv.input

# 2) indel
# Script below reads
    # varscan.out.som_indel.Somatic.hc.vcf
# and generates:
    # varscan.out.som_indel.Somatic.hc.dbsnp_present.vcf 
    # varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf    -> used for merge_vcf
    # varscan.out.som_indel.Somatic.hc.dbsnp_anno.vcf    
/usr/bin/perl /usr/local/somaticwrapper/GenomeVIP/dbsnp_filter.pl ./results/varscan/filter_out/vs_dbsnp_filter.indel.input


