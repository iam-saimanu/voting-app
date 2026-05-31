#!/bin/bash

set -ex

echo "DEBUG SCRIPT VERSION 999"

REPO_URL="https://AzuretokenId@dev.azure.com/gobi123manu/voting-app/_git/voting-app"

git clone "$REPO_URL" /tmp/temp_repo

cd /tmp/temp_repo

git checkout main

git config --global user.email "pipeline@azure.com"
git config --global user.name "Azure Pipeline"

echo "Before update:"
grep -n "image:" k8s-specifications/$1-deployment.yaml

echo "Application=$1"
echo "Repository=$2"
echo "Tag=$3"

# Update image
sed -i "s|image:.*|image: $2:$3|g" k8s-specifications/$1-deployment.yaml

echo "Image line after sed:"
grep -n "image:" k8s-specifications/$1-deployment.yaml

echo "Git diff:"

git diff

git status

git add .

git commit -m "Update Kubernetes manifest" || true

git push origin main

rm -rf /tmp/temp_repo
