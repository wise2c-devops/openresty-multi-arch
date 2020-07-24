#!/bin/bash

# kudos https://dev.to/zeerorg/build-multi-arch-docker-images-on-travis-5428

docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

# Build for amd64 and push
buildctl build --frontend dockerfile.v0 \
            --local dockerfile=. \
            --local context=. \
            --output type=image,name=wise2c/python-openresty:1.17.8-amd64,push=true \
            --opt platform=linux/amd64 \
            --opt filename=./Dockerfile


# Build for arm64 and push
buildctl build --frontend dockerfile.v0 \
            --local dockerfile=. \
            --local context=. \
            --output type=image,name=wise2c/python-openresty:1.17.8-arm64,push=true \
            --opt platform=linux/arm64 \
            --opt filename=./Dockerfile


export DOCKER_CLI_EXPERIMENTAL=enabled

# Create manifest list and push that
# 1.17.8
docker manifest create wise2c/python-openresty:1.17.8 \
            wise2c/python-openresty:1.17.8-amd64 \
            wise2c/python-openresty:1.17.8-arm64

docker manifest annotate wise2c/python-openresty:1.17.8 wise2c/python-openresty:1.17.8-arm64 --arch arm64
docker manifest annotate wise2c/python-openresty:1.17.8 wise2c/python-openresty:1.17.8-amd64 --arch amd64

docker manifest push wise2c/python-openresty:1.17.8

# latest
docker pull wise2c/python-openresty:1.17.8
docker pull wise2c/python-openresty:1.17.8-amd64
docker pull wise2c/python-openresty:1.17.8-arm64
docker tag wise2c/python-openresty:1.17.8 fragaria/python-openresty:latest
docker tag wise2c/python-openresty:1.17.8-amd64 fragaria/python-openresty:latest-amd64
docker tag wise2c/python-openresty:1.17.8-arm64 fragaria/python-openresty:latest-arm64
docker push wise2c/python-openresty:latest
docker push wise2c/python-openresty:latest-arm64
docker push wise2c/python-openresty:latest-amd64

docker manifest create wise2c/python-openresty:latest \
            wise2c/python-openresty:latest-amd64 \
            wise2c/python-openresty:latest-arm64

docker manifest annotate wise2c/python-openresty:latest wise2c/python-openresty:latest-arm64 --arch arm64
docker manifest annotate wise2c/python-openresty:latest wise2c/python-openresty:latest-amd64 --arch amd64

docker manifest push wise2c/python-openresty:latest
