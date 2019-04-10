# Launch docker environment at MGI before running cromwell.

#IMAGE="registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:5"
#IMAGE="registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:20"
#bsub -Is -q research-hpc -a "docker($IMAGE)" /bin/bash

# currently, using gsub, which tends to point to recent cromwell versions
/gscmnt/gc2560/core/env/v1/bin/gsub -m 8
