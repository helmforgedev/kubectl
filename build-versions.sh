#!/bin/bash

set -e

# Versions to build
VERSIONS=(
  "v1.34.6"
  "v1.33.10"
  "v1.32.13"
  "v1.31.13"
  "v1.30.14"
)

# Docker repository
REPO="docker.io/helmforge/kubectl"

echo "========================================"
echo "Building kubectl images for versions:"
printf '%s\n' "${VERSIONS[@]}"
echo "========================================"
echo ""

# Login to Docker Hub
echo "Logging in to Docker Hub..."
docker login

# Create buildx builder if not exists
if ! docker buildx ls | grep -q kubectl-builder; then
  echo "Creating buildx builder..."
  docker buildx create --name kubectl-builder --use
else
  echo "Using existing kubectl-builder..."
  docker buildx use kubectl-builder
fi

# Inspect builder
docker buildx inspect --bootstrap

# Build and push each version
for VERSION in "${VERSIONS[@]}"; do
  VERSION_SHORT="${VERSION#v}"

  echo ""
  echo "========================================"
  echo "Building kubectl ${VERSION}"
  echo "========================================"

  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --build-arg KUBECTL_VERSION="${VERSION}" \
    --tag "${REPO}:${VERSION_SHORT}" \
    --push \
    .

  echo "✅ Pushed ${REPO}:${VERSION_SHORT}"
done

echo ""
echo "========================================"
echo "All versions built and pushed!"
echo "========================================"
echo ""
echo "Images:"
for VERSION in "${VERSIONS[@]}"; do
  VERSION_SHORT="${VERSION#v}"
  echo "  - ${REPO}:${VERSION_SHORT}"
done
