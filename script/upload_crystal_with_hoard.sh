#!/usr/bin/env bash

ARCH=${ARCH:-arm64}
CRYSTAL_VERSION=${CRYSTAL:-1.6.0}

echo "Building Crystal ${CRYSTAL_VERSION} Image w/Hoard for $ARCH"

docker build -t robcole/crystal:hoard-$ARCH --build-arg ARCH=$ARCH - < Dockerfile.hoard
docker push robcole/crystal:hoard-$ARCH
docker manifest create robcole/crystal:hoard --amend robcole/crystal:hoard-amd64 --amend robcole/crystal:hoard-arm64
docker manifest push --purge robcole/crystal:hoard
