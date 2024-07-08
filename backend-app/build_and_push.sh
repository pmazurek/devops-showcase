IMAGE_NAME="$ECR_BACKEND_REPO:latest"

docker build -t $IMAGE_NAME .
docker push $IMAGE_NAME

