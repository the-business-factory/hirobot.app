#!/usr/bin/env bash

ARCH=${ARCH:-arm64}
CRYSTAL_VERSION=${CRYSTAL:-1.5.1}

echo "Building Crystal ${CRYSTAL_VERSION} Image w/Hoard for $ARCH"

docker build -t robcole/crystal:1.5.1-hoard-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.hoard
docker push robcole/crystal:1.5.1-hoard-$ARCH
docker manifest create robcole/crystal:1.5.1-hoard --amend robcole/crystal:1.5.1-hoard-amd64 --amend robcole/crystal:1.5.1-hoard-arm64
docker manifest push --purge robcole/crystal:1.5.1-hoard
