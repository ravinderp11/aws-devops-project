#!/bin/bash

set -e

APP_HOST="$1"
IMAGE_URI="$2"
AWS_REGION="${AWS_REGION:-us-east-1}"

if [[ -z "$APP_HOST" || -z "$IMAGE_URI" ]]; then
    echo "Usage: ./scripts/deploy.sh <APP_HOST> <IMAGE_URI>"
    exit 1
fi

echo "===== STARTING APPLICATION DEPLOYMENT ====="

ssh -o StrictHostKeyChecking=accept-new \
    "ubuntu@$APP_HOST" \
    "AWS_REGION='$AWS_REGION' IMAGE_URI='$IMAGE_URI' bash -s" <<'REMOTE'

set -e

echo "Logging in to Amazon ECR"

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

aws ecr get-login-password --region "$AWS_REGION" |
docker login --username AWS --password-stdin "$ECR_URL"

echo "Pulling latest application image"

docker pull "$IMAGE_URI"

echo "Stopping old application"

docker rm -f aws-devops-app || true

echo "Starting new application"

docker run -d \
    --name aws-devops-app \
    --restart unless-stopped \
    -p 8080:8080 \
    "$IMAGE_URI"

echo "Deployment completed"

REMOTE

echo "===== APPLICATION DEPLOYMENT SUCCESSFUL ====="