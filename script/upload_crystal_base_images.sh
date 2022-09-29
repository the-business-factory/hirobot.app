#!/usr/bin/env bash

ARCH=${ARCH:-arm64}
CRYSTAL_VERSION=${CRYSTAL_VERSION:-1.5.1}

echo "Building Crystal ${CRYSTAL_VERSION} w/optional Hoard allocator for $ARCH"

docker build -t robcole/crystal:$CRYSTAL_VERSION-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.crystal
docker push robcole/crystal:$CRYSTAL_VERSION-$ARCH
docker manifest create robcole/crystal:$CRYSTAL_VERSION --amend robcole/crystal:$CRYSTAL_VERSION-amd64 --amend robcole/crystal:$CRYSTAL_VERSION-arm64
docker manifest push --purge robcole/crystal:$CRYSTAL_VERSION
