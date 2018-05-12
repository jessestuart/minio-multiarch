#!/bin/sh

mkdir -p $GOPATH/src/github.com/${IMAGE}
git clone https://github.com/${GITHUB_REPO} --depth=1 $GOPATH/src/github.com/${GITHUB_REPO} &>/dev/null
echo "Building repo: $GITHUB_REPO" && echo "Version: $VERSION" && echo "Architecture: $GOARCH"
cd $GOPATH/src/github.com/${GITHUB_REPO}
go get .
make
