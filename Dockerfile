ARG target
FROM golang:1.12-alpine

ARG goarch
ENV GOARCH $goarch
ENV GOOS linux

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on

RUN \
  apk add --no-cache git && \
  git clone https://github.com/minio/minio && cd minio && \
  go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
  find /go/bin -name minio -exec cp -f {} /go/bin/minio \; && \
  cd dockerscripts && \
  go build -tags kqueue -ldflags "-s -w" -o /usr/bin/healthcheck healthcheck.go

FROM $target/alpine:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL \
  maintainer="Jesse Stuart <hi@jessestuart.com>" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.url="https://hub.docker.com/r/jessestuart/minio/" \
  org.label-schema.vcs-url="https://github.com/jessestuart/minio-multiarch" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

COPY qemu-* /usr/bin/

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

EXPOSE 9000

COPY --from=0 /go/bin/minio /usr/bin/
COPY --from=0 /usr/bin/healthcheck /usr/bin/healthcheck
COPY dockerscripts/docker-entrypoint.sh /usr/bin/

RUN \
  apk add --no-cache ca-certificates 'curl>7.61.0' && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

HEALTHCHECK --interval=1m CMD healthcheck

CMD ["minio"]
