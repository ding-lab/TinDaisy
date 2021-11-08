IMAGE="mwyczalkowski/cromwell-runner"

PWD=$(pwd)
CWL_ROOT_H=$PWD/../..

VOLUME_MAPPING=" \
$CWL_ROOT_H \
/storage1/fs1/m.wyczalkowski/Active \
/storage1/fs1/dinglab/Active \
/scratch1/fs1/dinglab
"

CMD="bash ../../submodules/WUDocker/start_docker.sh -A -I $IMAGE -M compute1 $VOLUME_MAPPING"
echo Running: $CMD
eval $CMD
