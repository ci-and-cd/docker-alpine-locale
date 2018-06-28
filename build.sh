#!/usr/bin/env bash

set -e

docker version
docker-compose version

WORK_DIR=$(pwd)

if [ -n "${CI_OPT_DOCKER_REGISTRY_PASS}" ] && [ -n "${CI_OPT_DOCKER_REGISTRY_USER}" ]; then
    echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io
fi

export IMAGE_TAG=3.7_${IMAGE_ARG_LOCALE:-C}.${IMAGE_ARG_ENCODING:-UTF-8}_${IMAGE_ARG_TZ_AREA:-Etc}.${IMAGE_ARG_TZ_ZONE:-UTC}
if [ "${TRAVIS_BRANCH}" != "master" ]; then export IMAGE_TAG=${IMAGE_TAG}-SNAPSHOT; fi

BUILDER_IMAGE_NAME=tmp/builder
if [[ "$(docker images -q ${BUILDER_IMAGE_NAME}:${IMAGE_TAG} 2> /dev/null)" == "" ]]; then
    docker-compose build builder
fi

docker save ${BUILDER_IMAGE_NAME}:${IMAGE_TAG} > /tmp/builder.tar
rm -rf /tmp/builder && mkdir -p /tmp/builder && tar -xf /tmp/builder.tar -C /tmp/builder
for layer in /tmp/builder/*/layer.tar; do
    echo ${layer}
    mkdir -p $(dirname ${layer})/layer && tar -xf ${layer} -C $(dirname ${layer})/layer
done

#LAST_DIFF_ID=$(docker image inspect -f '{{json .RootFS.Layers}}' ${BUILDER_IMAGE_NAME}:${IMAGE_TAG} | jq -r 'last' | awk -F':' '{print $2}')
LAST_LAYER=$(find /tmp/builder -name "timezone" | grep "/etc/timezone" | awk -F'/' '{print $4}')
echo LAST_LAYER ${LAST_LAYER}

#tar cf ${WORK_DIR}/data/fonts_locale_tz.tar -C /tmp/builder/${LAST_LAYER}/layer .
# ignore empty directories
#(cd /tmp/builder/${LAST_LAYER}/layer && find . -type f -print0 | sed -z 's#^.##' | sed -z 's#^/##' | xargs -0 tar --no-recursion -cvf ${WORK_DIR}/data/glibc.tar)
cp -f /tmp/builder/${LAST_LAYER}/layer.tar data/fonts_locale_tz.tar
#mkdir -p data/fonts_locale_tz && tar xf data/fonts_locale_tz.tar -C data/fonts_locale_tz

IMAGE_NAME=${IMAGE_PREFIX:-cirepo}/alpine-locale

docker-compose build alpine-locale
docker-compose push alpine-locale
