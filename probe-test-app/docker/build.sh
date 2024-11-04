#!/bin/bash
docker buildx create --name mybuilder --bootstrap --use
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/probe-test-app:latest \
  .
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/probe-test-app:v1 \
  .
sed -i -e 's/1/2/g' version.json
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/probe-test-app:v2 \
  .
docker buildx rm mybuilder
sed -i -e 's/2/1/g' version.json