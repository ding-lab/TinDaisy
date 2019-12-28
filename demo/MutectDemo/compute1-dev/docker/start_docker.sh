# MGI launch command:
# /gscmnt/gc2560/core/env/v1/bin/gsub -m 32
# where -m Memory to reserve (in Gb). Default 2

# from /gscmnt/gc2560/core/env/v1/bin/gsub 
# selectString="select[mem>$(( mem * 1000 ))] rusage[mem=$(( mem * 1000 ))]";
# bsub -Is -J $jobname -M $(( $mem * 1000000 )) -n $nthreads -R "$selectString" -q $queue -a "$image" /bin/bash -l
# Tom Mooney writes: change the memory units in -M to match the ones in -R.

# NOTE: on compute1 this appears to map ./* to docker container, so to retain home directory for e.g. development,
# run this from home directory

mem=32

SELECT="select[mem>$(( mem * 1000 ))] rusage[mem=$(( mem * 1000 ))]";
QUEUE="general-interactive"
#IMAGE="docker(registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:22)"
IMAGE="docker(mwyczalkowski/cromwell-runner)"


#bsub -Is -q general-interactive -a 'docker(registry.gsc.wustl.edu/apipe-builder/genome_perl_environment:22)' /bin/bash

export LSF_DOCKER_VOLUMES="/storage1/fs1/m.wyczalkowski:/data /scratch1/fs1/lding:/scratch"
bsub -Is -M $(( $mem * 1000 )) -R "$SELECT" -q $QUEUE -a "$IMAGE" /bin/bash -l
