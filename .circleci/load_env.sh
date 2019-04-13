#!/bin/sh

echo 'export GITHUB_REPO=minio/minio' >>$BASH_ENV
echo 'export GOPATH=/go' >>$BASH_ENV
echo 'export GOROOT=/usr/local/go' >>$BASH_ENV
echo 'export IMAGE=minio' >>$BASH_ENV
echo 'export REGISTRY=jessestuart' >>$BASH_ENV

echo 'export VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest | jq -r ".tag_name")' >>$BASH_ENV
echo 'export IMAGE_ID="${REGISTRY}/${IMAGE}:${VERSION}-${TAG}"' >>$BASH_ENV
echo 'export DIR=`pwd`' >>$BASH_ENV
echo 'export QEMU_VERSION="v3.1.0-3"' >>$BASH_ENV

. $BASH_ENV
