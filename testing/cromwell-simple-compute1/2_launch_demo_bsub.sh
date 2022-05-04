IMAGE="mwyczalkowski/cromwell-runner:v78"

PWD=$(pwd)
CWL_ROOT_H=$PWD/../..
START_DOCKER="$CWL_ROOT_H/submodules/WUDocker/start_docker.sh"


VOLUME_MAPPING=" \
/cache1/fs1/home1/Active/home/m.wyczalkowski/Projects \
/storage1/fs1/m.wyczalkowski/Active \
/storage1/fs1/dinglab/Active \
/scratch1/fs1/dinglab  \
/home/m.wyczalkowski/Projects/TinDaisy/dev/FFPE-filedb/TinDaisy
"

ARG="-q dinglab"

CMD="bash 1_run_cromwell_demo.sh"

CMD_DOCKER="bash $START_DOCKER $ARG -A -r -I $IMAGE -M compute1 -c \"$CMD\" $VOLUME_MAPPING"
echo Running: $CMD_DOCKER
eval $CMD_DOCKER
