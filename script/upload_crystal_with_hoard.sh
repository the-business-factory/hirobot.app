#!/usr/bin/env bash

ARCH=${ARCH:-arm64}
CRYSTAL_VERSION=${CRYSTAL:-1.6.0}

echo "Building Crystal ${CRYSTAL_VERSION} Image w/Hoard for $ARCH"

docker build -t robcole/crystal:1.6.0-lucky-error-$ARCH --build-arg ARCH=$ARCH - < Dockerfile
docker push robcole/crystal:1.6.0-lucky-error-$ARCH
docker manifest create robcole/crystal:1.6.0-lucky-error --amend robcole/crystal:1.6.0-lucky-error-amd64 --amend robcole/crystal:1.6.0-lucky-error-arm64
docker manifest push --purge robcole/crystal:1.6.0-lucky-error
