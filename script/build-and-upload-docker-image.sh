#!/usr/bin/env bash

# AMD64 taken care of locally for now.
docker build -t robcole/crystal:1.4.1-hoard-arm64 --build-arg ARCH=arm64 - < Dockerfile.baseimage
docker push robcole/crystal:1.4.1-hoard-arm64
docker manifest create robcole/crystal:1.4.1-hoard --amend robcole/crystal:1.4.1-hoard-amd64 --amend robcole/crystal:1.4.1-hoard-arm64
docker manifest push --purge robcole/crystal:1.4.1-hoard