callRegions files are bgzip-compressed tabix-indexed BED file to restrict variant calling region for strelka2
    GRCh38.callRegions.bed.gz
    GRCh38.callRegions.bed.gz.tbi
See https://github.com/Illumina/strelka/blob/v2.9.x/docs/userGuide/README.md#extended-use-cases

To create call_regions file to use with Strelka2,
1) create BED file
2) bgzip -c file.bed > file.bed.gz
3) tabix -p bed file.bed.gz

GRCh38.callRegions.bed is an uncompressed version of the above.  It used for canonical filter,
which retains just the calls in the regions listed.

Files below used for pindel 
    GRCh38.d1.vd1.chrlist.txt
    hs37.chrlist.txt
