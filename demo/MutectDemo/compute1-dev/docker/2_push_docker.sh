source docker_image.sh

CMD="docker push $DOCKER_IMAGE"
echo $CMD
eval $CMD

