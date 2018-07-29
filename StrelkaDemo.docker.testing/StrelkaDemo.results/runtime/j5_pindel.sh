#!/bin/bash

/usr/local/pindel/pindel -f /data/demo20.fa -i ./results/pindel/pindel_out/pindel.config -o ./results/pindel/pindel_out/pindel  -T 4 -m 6 -w 1  -J /data/ucsc-centromere.GRCh37.bed

cd ./results/pindel/pindel_out 
grep ChrID pindel_D pindel_SI pindel_INV pindel_TD > pindel-raw.dat

if [[ 0 == 1 ]]; then

>&2 echo Not deleting intermediate pindel files

else

>&2 echo Deleting intermediate pindel files
rm -f pindel_*

fi


