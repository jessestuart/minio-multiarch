FROM golang:1.10.1-alpine3.7

ARG arch
ENV ARCH=$arch

COPY qemu-$ARCH-static* /usr/bin/

LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV CGO_ENABLED 0
ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

WORKDIR /go/src/github.com/minio/

COPY dockerscripts/docker-entrypoint.sh dockerscripts/healthcheck.sh /usr/bin/
COPY . /go/src/github.com/minio/minio

RUN  \
     apk add --no-cache ca-certificates curl && \
     apk add --no-cache --virtual .build-deps git && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     cd /go/src/github.com/minio/minio && \
     go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
     rm -rf /go/pkg /go/src /usr/local/go && apk del .build-deps

# RUN \
#      apk add --no-cache ca-certificates && \
#      apk add --no-cache --virtual .build-deps curl && \
#      echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
#      chmod +x /usr/bin/minio  && \
#      chmod +x /usr/bin/docker-entrypoint.sh && \
#      chmod +x /usr/bin/healthcheck.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=5s \
    CMD /usr/bin/healthcheck.sh

VOLUME ["/data"]

CMD ["minio"]
