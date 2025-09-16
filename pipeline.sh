#!/bin/bash
set -euo pipefail   
IMAGE_NAME="node-express-pipeline"
CONTAINER_NAME="node-express-app"
CI_IMAGE="node:20-alpine"   

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  PROJECT_PATH=$(pwd -W 2>/dev/null || pwd)   
  export MSYS_NO_PATHCONV=1                  
else
  PROJECT_PATH=$(pwd)                         
fi
echo ">>> Step 1: Build application Docker image"
docker build -t $IMAGE_NAME .
echo ">>> Step 2: Install dependencies (inside CI container)"
docker run --rm -v "$PROJECT_PATH:/app" -w /app $CI_IMAGE sh -c "npm install"
echo ">>> Step 3: Run lint (eslint)"
docker run --rm -v "$PROJECT_PATH:/app" -w /app $CI_IMAGE sh -c "npx eslint ."
echo ">>> Step 4: Run tests (npm test)"
docker run --rm -v "$PROJECT_PATH:/app" -w /app $CI_IMAGE sh -c "npm test"
echo ">>> Step 5: Deploy app container"
docker rm -f $CONTAINER_NAME 2>/dev/null || true
docker run -d --name $CONTAINER_NAME -p 3000:3000 $IMAGE_NAME
echo "Pipeline completed successfully.
App running at: http://localhost:3000"
