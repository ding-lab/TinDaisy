Mutect sometimes dies because it runs out of memory.
This is marked as "Killed" in the logs.
A diagnostic is that chromosomes are not well represented in the output mutect.vcf

The following parameter changes in the CWL file have been helpful in the past:
   envValue: -Xmx16g
   ramMin: 24000
