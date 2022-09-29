#!/usr/bin/env bash

echo "Building Image for $ARCH"
docker build -t robcole/crystal:latest-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.baseimage
docker push robcole/crystal:latest-$ARCH
docker manifest create robcole/crystal:latest --amend robcole/crystal:latest-amd64 --amend robcole/crystal:latest-arm64
docker manifest push --purge robcole/crystal:latest
