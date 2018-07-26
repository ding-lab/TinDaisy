#!/bin/bash

export JAVA_OPTS="-Xms256m -Xmx10g"
export VARSCAN_DIR="/usr/local"

# step 5
/usr/bin/perl /usr/local/somaticwrapper/GenomeVIP/dbsnp_filter.pl ./results/strelka/filter_out/strelka_dbsnp_filter.snv.input

