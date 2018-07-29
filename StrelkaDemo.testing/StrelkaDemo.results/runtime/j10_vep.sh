#!/bin/bash

export JAVA_OPTS="-Xms256m -Xmx512m"

 /usr/local/somaticwrapper/GenomeVIP/vep_annotator.pl ./results/vep/vep.merged.input

# Evaluate return value see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
rc=$? 
if [[ $rc != 0 ]]; then 
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc; 
fi

