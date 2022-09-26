#!/usr/bin/env bash

echo "Building Image for $ARCH"
docker build -t robcole/crystal:lucky-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.baseimage
docker push robcole/crystal:lucky-$ARCH
docker manifest create robcole/crystal:lucky --amend robcole/crystal:lucky-amd64 --amend robcole/crystal:lucky-arm64
docker manifest push --purge robcole/crystal:lucky
