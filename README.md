### minio-multiarch

[![CircleCI][circleci-badge]][circleci-link]
[![Docker Pulls][dockerhub-badge]][dockerhub-link]

Provides daily builds of Minio server Docker images compatible with both arm64
and armhf architectures.

### Minio Server

[Minio][minio-home] is an OSS project offering a "high performance distributed
object storage server", with fabulous features like an S3-compliant API,
excellent documentation, and other great features out-of-the-box:

* Regularly updated Docker images (for AMD64 only, unfortunately)
* An officially supported [Helm chart][minio-helm] for easy Kubernetes
* deployment.
- A pretty dope CLI client, [mc][mc-github], for interfacing with not just Minio
  but any S3-compliant API.

However, there's currently no officially maintained multi-arch Docker image.
And while they provide cross-compiled binaries for ARM/ARM64, these releases
often lag months behind the Darwin x86_64 or Linux AMD64 binaries.

This repo triggers a nightly job on CircleCI to build a multi-arch image
supporting armhf and amd64 architectures, and push the appropriate manifest
to Docker Hub.

### How can I use this?

You can run the following command on an ARM-based system to stand up a
standalone instance of Minio Server on Docker:

```bash
docker run \
  -v /export/minio \
  -v /export/minio-config:/root/.minio \
  -p 9000:9000 \
  jessestuart/minio server /export
```

Alternatively, you can build locally to ensure you're pulling the latest stable
binary:

```
git clone https://github.com/jessestuart/minio
cd minio
docker build -t minio .
# ---------------------------------------
# Or to push to your Docker Hub (or quay.io, etc) account to make the image
# publicly accessible:
docker build -t {your_username}/minio .
docker push {your_username}/minio .
```

-------------------------

### Kubernetes

This image can also be used to deploy a Minio pod to a Kubernetes cluster. See
the [official docs][minio-k8s] on deploying Minio to Kubernetes for more detail,
or check out the Minio [Helm chart][minio-helm] documentation.

[minio-home]: https://minio.io
[minio-k8s]: https://docs.minio.io/docs/deploy-minio-on-kubernetes
[minio-helm]: https://github.com/kubernetes/charts/tree/master/stable/minio
[circleci-badge]: https://circleci.com/gh/jessestuart/minio-multiarch/tree/master.svg?style=shield
[circleci-link]: https://circleci.com/gh/jessestuart/minio-multiarch/tree/master
[dockerhub-badge]: https://img.shields.io/docker/pulls/jessestuart/minio.svg?style=flat-square
[dockerhub-link]: https://hub.docker.com/r/jessestuart/minio/
