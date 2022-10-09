#!/usr/bin/env bash

ARCH=${ARCH:-arm64}

echo "Building Image for $ARCH"

docker build -t robcole/crystal:1.5.1-openssl-hoard-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.baseimage
docker push robcole/crystal:1.5.1-openssl-hoard-$ARCH
docker manifest create robcole/crystal:1.5.1-openssl-hoard --amend robcole/crystal:1.5.1-openssl-hoard-amd64 --amend robcole/crystal:1.5.1-openssl-hoard-arm64
docker manifest push --purge robcole/crystal:1.5.1-openssl-hoard
