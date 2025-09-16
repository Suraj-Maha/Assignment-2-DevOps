# Node.js Express Hello World – Local CI Pipeline

This project shows how to set up a local CI pipeline using Docker for a Node.js + Express app.
The pipeline will:

Build the Docker image

Install dependencies

Run linting (ESLint)

Run tests (Jest)

We are using the same Hello World Node.js app from Assignment-1 and extending it with a local pipeline.

node-express-hello-world/
│── app.js
│── package.json
│── package-lock.json
│── Dockerfile
│── pipeline.sh
│── .dockerignore
│── .eslintrc.json
│
├── routes/
│   └── route.js
│
├── views/
│   └── home.ejs
│
├── public/
│   └── images/
│
└── test/
    └── basic.test.js

# Steps to Run the Pipeline
git clone https://github.com/Suraj-Maha/Assignment-1-DevOps.git
cd Assignment-1

# Install dependencies
npm install --save-dev eslint@8 jest
npm list --depth=0

# Setup ESLint and Jest
Create .eslintrc.json for linting rules.
Create a test file (example: basic.test.js inside /test folder).

# pipeline setup

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

# Run the Pipeline Script
chmod +x pipeline.sh
./pipeline.sh

# Fix Errors and Re-run
If ESLint shows errors in app.js, fix them.
Run the pipeline again until all steps pass.

# Expected Output

When successful, the pipeline will:
Build the Docker image.
Install dependencies.
Lint the code.
Run tests.
Deploy the app in a Docker container.

 http://localhost:3000












```  
