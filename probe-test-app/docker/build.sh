#!/bin/bash
docker buildx create --name mybuilder --bootstrap --use
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/probe-test-app:281024 \
  .
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/probe-test-app:latest \
  .
docker buildx rm mybuilder