ARG target
FROM golang:1.12-alpine

ARG arch
ENV ARCH=$arch

LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV CGO_ENABLED 0

ARG goarch
ENV GOARCH $goarch
ENV GOOS linux

WORKDIR /go/src/github.com/minio

RUN \
  apk add --no-cache git && \
  go get -v -d github.com/minio/minio && \
  cd $GOPATH/src/github.com/minio/minio && \
  go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
  go build -ldflags "-s -w" -o /usr/bin/healthcheck dockerscripts/healthcheck.go && \
  cp dockerscripts/docker-entrypoint.sh /usr/bin/ && \
  cp /go/bin/minio /usr/bin/ || cp /go/bin/linux_*/minio /usr/bin/

FROM $target/alpine:3.9

COPY qemu-* /usr/bin/

EXPOSE 9000

COPY --from=0 /usr/bin/minio /usr/bin/healthcheck /usr/bin/docker-entrypoint.sh /usr/bin/

RUN  \
  apk add --no-cache ca-certificates 'curl>7.61.0' && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

HEALTHCHECK --interval=1m CMD healthcheck

CMD ["minio"]
