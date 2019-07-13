### minio-multiarch

[![CircleCI][circleci-badge]][circleci-link]
[![MicroBadger Size][microbadger]][microbadger-link]
[![Docker Pulls][dockerhub-badge]][dockerhub-link]

Provides nightly builds of Minio server Docker images compatible with `arm64`,
`armhf`/`armv7`, and `amd64` architectures.

### Minio Server

[Minio][minio-home] is an OSS project offering a "high performance distributed
object storage server", with fabulous features like an S3-compliant API,
excellent documentation, and other great features out-of-the-box:

- Regularly updated Docker images — although the upstream provides builds for
  AMD64 only, unfortunately.

- An officially supported (in-tree) [Helm chart][minio-helm] for easy Kubernetes
  deployment.

* A pretty dope CLI client, [mc][mc-github], for interfacing with not just Minio
  but any S3-compliant API. I've got a [multi-arch image][mc-link] for that too!

However, there's currently no officially maintained Docker image compatible with
architectures other than amd64. And while they provide cross-compiled binaries
for ARM/ARM64, these releases often lag months behind the Darwin or Linux
AMD64 binaries.

This repo triggers a nightly job on CircleCI to build Docker images for all
three architectures, then updates the repository manifest accordingly. Just
`docker run --rm -it jessestuart/minio` on any platform, and you'll be on your
way to storage success.

### How can I use this?

You can run the following command to stand up a standalone instance of Minio
Server on Docker: (replace `/export/minio`)

```bash
docker run \
  -v /export/minio \
  -v /export/minio-config:/root/.minio \
  -p 9000:9000 \
  jessestuart/minio server /export
```

---

### Kubernetes

This image can also be used to deploy a Minio pod to a Kubernetes cluster. See
the [official docs][minio-k8s] on deploying Minio to Kubernetes for more detail,
or check out the Minio [Helm chart][minio-helm] documentation.

[circleci-badge]: https://circleci.com/gh/jessestuart/minio-multiarch/tree/master.svg?style=shield
[circleci-link]: https://circleci.com/gh/jessestuart/minio-multiarch/tree/master
[dockerhub-badge]: https://img.shields.io/docker/pulls/jessestuart/minio.svg?style=flat-square
[dockerhub-link]: https://hub.docker.com/r/jessestuart/minio/
[mc-github]: https://github.com/minio/mc
[mc-link]: https://github.com/jessestuart/mc-multiarch
[microbadger-link]: https://github.com/jessestuart/minio-multiarch
[microbadger]: https://images.microbadger.com/badges/image/jessestuart/minio.svg
[minio-helm]: https://github.com/kubernetes/charts/tree/master/stable/minio
[minio-home]: https://minio.io
[minio-k8s]: https://docs.minio.io/docs/deploy-minio-on-kubernetes
