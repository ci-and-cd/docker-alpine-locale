# docker-alpine-locale

Alpine locale and timezone setting for multi-stage docker image build.

Dockerfile [ci-and-cd/docker-alpine-locale on Github](https://github.com/ci-and-cd/docker-alpine-locale)

[cirepo/locale on Docker Hub](https://hub.docker.com/r/cirepo/locale/)

## Use this image as a “stage” in multi-stage builds

```dockerfile

FROM alpine:3.9
COPY --from=cirepo/locale:C.UTF-8_Etc.UTC-alpine-3.9-archive /data/root /

```
