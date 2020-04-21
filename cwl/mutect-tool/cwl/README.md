Mutect sometimes dies because it runs out of memory.
This is marked as "Killed" in the logs.
A diagnostic is that chromosomes are not well represented in the output mutect.vcf

The following parameter changes in the CWL and YAML seem relevant
   envValue: -Xmx?g
   ramMin: ?000

ncpu (can be selected in YAML, default to 8 in cwl)

The hypothesis is that NCPU * Xmx <= RamMin, on the thinking that each thread requires Xmx and there will be NCPU of them,
so at least RamMin must be provided

Will run with Xmx2g, RamMin 18, NCPU 8
