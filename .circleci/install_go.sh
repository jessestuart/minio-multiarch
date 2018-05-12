#!/bin/sh
echo 'export GOROOT=/usr/local/go' >> $BASH_ENV
echo 'export GOPATH=~/go' >> $BASH_ENV
echo 'export PATH="/usr/local/go/bin:$PATH"' >> $BASH_ENV
echo 'export PATH="~/go/bin:$PATH"' >> $BASH_ENV
source $BASH_ENV

# @see https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker
mkdir /lib64 && ln -s \
    /lib/libc.musl-x86_64.so.1 \
    /lib64/ld-linux-x86-64.so.2

rm -rf /usr/local/go
curl -sL https://storage.googleapis.com/golang/go1.10.1.linux-amd64.tar.gz | tar xz
mv go/ /usr/local
go env && go version
