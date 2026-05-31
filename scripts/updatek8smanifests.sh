#!/bin/bash

set -ex

REPO_URL="https://AzureTokenId@dev.azure.com/gobi123manu/voting-app/_git/voting-app"

git clone "$REPO_URL" /tmp/temp_repo

cd /tmp/temp_repo

git checkout main

git config --global user.email "pipeline@azure.com"
git config --global user.name "Azure Pipeline"

echo "Before update:"
cat k8s-specifications/$1-deployment.yaml

# Update image
sed -i "s|.*image:.*|        image: $2:$3|g" k8s-specifications/$1-deployment.yaml

echo "After update:"
cat k8s-specifications/$1-deployment.yaml

git status

git add .

git commit -m "Update Kubernetes manifest"

git push origin main

rm -rf /tmp/temp_repo