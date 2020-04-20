Mutect sometimes dies because it runs out of memory.
A diagnostic is that chromosomes are not well represented in the intermediate VCF files

The following parameter changes in the CWL file have been helpful in the past:
   envValue: -Xmx16g
   ramMin: 24000
