# Currently built on denali

source docker_image.sh

# Build needs to take place in root directory of project
cd ..

CMD=" docker build -t $DOCKER_IMAGE -f docker/Dockerfile ."
echo $CMD
eval $CMD
