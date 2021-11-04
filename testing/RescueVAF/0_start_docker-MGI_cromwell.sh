IMAGE="mwyczalkowski/cromwell-runner"

./TinDaisy/testing/WUDocker/start_docker.sh
bash ../../WUDocker/start_docker.sh -I $IMAGE -M MGI
