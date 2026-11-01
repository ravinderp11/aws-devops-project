#!/bin/bash

set -e

AWS_REGION="${AWS_REGION:-us-east-1}"
ECR_REPOSITORY="aws-devops-app"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

IMAGE_TAG="${IMAGE_TAG:-v1}"

ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "===== ECR LOGIN ====="

aws ecr get-login-password --region "$AWS_REGION" |
docker login --username AWS --password-stdin "$ECR_URL"

echo "===== DOCKER BUILD ====="

docker build -t "${ECR_REPOSITORY}:${IMAGE_TAG}" \
    -f docker/Dockerfile .

echo "===== DOCKER TAG ====="

docker tag "${ECR_REPOSITORY}:${IMAGE_TAG}" \
    "${ECR_URL}/${ECR_REPOSITORY}:${IMAGE_TAG}"

echo "===== PUSHING IMAGE TO ECR ====="

docker push "${ECR_URL}/${ECR_REPOSITORY}:${IMAGE_TAG}"

echo "===== IMAGE PUSH COMPLETED ====="