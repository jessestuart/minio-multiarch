#!/bin/sh
echo 'export VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest | jq -r ".tag_name")' >> $BASH_ENV
echo 'export IMAGE_ID="${REGISTRY}/${IMAGE}:${VERSION}-${TAG}"' >> $BASH_ENV
echo 'export DIR=`pwd`' >> $BASH_ENV
source $BASH_ENV

