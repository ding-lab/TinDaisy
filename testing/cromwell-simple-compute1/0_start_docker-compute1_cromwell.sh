IMAGE="mwyczalkowski/cromwell-runner:v78"

PWD=$(pwd)
CWL_ROOT_H=$PWD/../..
#CWL_ROOT_H=$PWD/TinDaisy

VOLUME_MAPPING=" \
$CWL_ROOT_H \
/storage1/fs1/m.wyczalkowski/Active \
/storage1/fs1/dinglab/Active \
/scratch1/fs1/dinglab
"

ARG="-q dinglab-interactive"

CMD="bash $CWL_ROOT_H/submodules/WUDocker/start_docker.sh $ARG -A -I $IMAGE -M compute1 $VOLUME_MAPPING"
echo Running: $CMD
eval $CMD
