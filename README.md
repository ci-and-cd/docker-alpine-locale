# docker-alpine-locale

Alpine locale and timezone setting for multi-stage docker image build.

Dockerfile [ci-and-cd/docker-alpine-locale on Github](https://github.com/ci-and-cd/docker-alpine-locale)

[cirepo/alpine-locale on Docker Hub](https://hub.docker.com/r/cirepo/alpine-locale/)

## Use this image as a “stage” in multi-stage builds

```dockerfile
FROM alpine:3.7
COPY --from=cirepo/alpine-locale:3.7_C.UTF-8_Etc.UTC /data/fonts_locale_tz.tar /data/fonts_locale_tz.tar
RUN tar xf /data/fonts_locale_tz.tar -C /
```
