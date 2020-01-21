# NOTE: on compute1 this appears to map ./* to docker container, so to retain home directory for e.g. development,
# run this from home directory
# Note that we are not able to mount /scratch1/fs1/lding as /scratch

echo Current working directory:
pwd
cd

mem=32
SELECT="select[mem>$(( mem * 1000 ))] rusage[mem=$(( mem * 1000 ))]";
QUEUE="general-interactive"
IMAGE="docker(mwyczalkowski/cromwell-runner)"

#export LSF_DOCKER_VOLUMES="/storage1/fs1/m.wyczalkowski:/data /scratch1/fs1/lding:/scratch"
export LSF_DOCKER_VOLUMES="/storage1/fs1/m.wyczalkowski:/data"
bsub -Is -M $(( $mem * 1000 )) -R "$SELECT" -q $QUEUE -a "$IMAGE" /bin/bash -l
