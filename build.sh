#!/usr/bin/env bash

if [ -n "${CI_OPT_DOCKER_REGISTRY_PASS}" ] && [ -n "${CI_OPT_DOCKER_REGISTRY_USER}" ]; then
    echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io
fi

IMAGE_TAG=3.7_${IMAGE_ARG_LOCALE:-C}.${IMAGE_ARG_ENCODING:-UTF-8}_${IMAGE_ARG_TZ_AREA:-Etc}.${IMAGE_ARG_TZ_ZONE:-UTC}

TEMP_IMAGE_NAME=temp/temp
if [[ "$(docker images -q ${TEMP_IMAGE_NAME}:${IMAGE_TAG} 2> /dev/null)" == "" ]]; then
    docker build \
        --build-arg IMAGE_ARG_ALPINE_MIRROR=${IMAGE_ARG_ALPINE_MIRROR:-mirror.tuna.tsinghua.edu.cn} \
        --build-arg IMAGE_ARG_ENCODING=${IMAGE_ARG_ENCODING:-UTF-8} \
        --build-arg IMAGE_ARG_LOCALE=${IMAGE_ARG_LOCALE:-C} \
        --build-arg IMAGE_ARG_TZ=${IMAGE_ARG_TZ:-UTC+0:00} \
        --build-arg IMAGE_ARG_TZ_AREA=${IMAGE_ARG_TZ_AREA:-Etc} \
        --build-arg IMAGE_ARG_TZ_ZONE=${IMAGE_ARG_TZ_ZONE:-UTC} \
        -t ${TEMP_IMAGE_NAME}:${IMAGE_TAG} -f ./Dockerfile_temp_image .
fi

docker save ${TEMP_IMAGE_NAME}:${IMAGE_TAG} > /tmp/temp.tar
rm -rf /tmp/temp && mkdir -p /tmp/temp && tar -xf /tmp/temp.tar -C /tmp/temp
for layer in /tmp/temp/*/layer.tar; do
    echo ${layer}
    mkdir -p $(dirname ${layer})/layer && tar -xf ${layer} -C $(dirname ${layer})/layer
done

#LAST_DIFF_ID=$(docker image inspect -f '{{json .RootFS.Layers}}' ${TEMP_IMAGE_NAME}:${IMAGE_TAG} | jq -r 'last' | awk -F':' '{print $2}')
LAST_LAYER=$(find /tmp/temp -name "timezone" | grep "/etc/timezone" | awk -F'/' '{print $4}')
echo LAST_LAYER ${LAST_LAYER}

#tar cf $(pwd)/data/fonts_locale_tz.tar -C /tmp/temp/${LAST_LAYER}/layer .
cp -f /tmp/temp/${LAST_LAYER}/layer.tar data/fonts_locale_tz.tar
#mkdir -p data/fonts_locale_tz && tar xf data/fonts_locale_tz.tar -C data/fonts_locale_tz

IMAGE_NAME=${IMAGE_PREFIX:-cirepo}/alpine-locale
if [ "${TRAVIS_BRANCH}" != "master" ]; then IMAGE_TAG=${IMAGE_TAG}-SNAPSHOT; fi

docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker push ${IMAGE_NAME}:${IMAGE_TAG}
