#!/bin/bash

if [ -d ./results/strelka/strelka_out ] ; then
    rm -rf ./results/strelka/strelka_out
fi

/usr/local/strelka2/bin/configureStrelkaSomaticWorkflow.py --exome --normalBam /data/StrelkaDemoCase.N.bam --tumorBam /data/StrelkaDemoCase.T.bam --referenceFasta /data/demo20.fa --config /data/strelka.WES.ini --runDir ./results/strelka/strelka_out

cd ./results/strelka/strelka_out
ls
./runWorkflow.py -m local -j 8 -g 4
