#!/bin/bash

echo Running pindel_filter.v0.5.pl
/usr/bin/perl /usr/local/somaticwrapper/GenomeVIP/pindel_filter.v0.5.pl ./results/pindel/filter_out/pindel_filter.input

export JAVA_OPTS="-Xms256m -Xmx10g"

echo Running dbsnp_filter.pl
/usr/bin/perl /usr/local/somaticwrapper/GenomeVIP/dbsnp_filter.pl ./results/pindel/filter_out/pindel_dbsnp_filter.indel.input

if [[ 0 == 1 ]]; then

>&2 echo Not deleting intermediate files

else

>&2 echo Deleting intermediate \"filter fail\" files
cd ./results/pindel/filter_out
rm -f *_fail*

fi

