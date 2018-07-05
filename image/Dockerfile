
FROM alpine:3.7


ARG IMAGE_ARG_ALPINE_MIRROR

ARG IMAGE_ARG_ENCODING
ARG IMAGE_ARG_LOCALE

ARG IMAGE_ARG_TZ
ARG IMAGE_ARG_TZ_AREA
ARG IMAGE_ARG_TZ_ZONE


COPY --chown=root:root docker /data


RUN set -ex \
    && echo ===== Set locale ===== \
    && echo "http://${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "http://${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}/alpine/v3.7/community" >> /etc/apk/repositories \
    && echo "http://${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add --update font-adobe-100dpi tzdata \
    && cp /usr/share/zoneinfo/${IMAGE_ARG_TZ_AREA:-Etc}/${IMAGE_ARG_TZ_ZONE:-UTC} /etc/localtime \
    && echo "${IMAGE_ARG_TZ_AREA:-Etc}/${IMAGE_ARG_TZ_ZONE:-UTC}" > /etc/timezone \
    && echo "${IMAGE_ARG_TZ:-UTC+0:00}" > /etc/TZ \
    && echo "export LANG=${IMAGE_ARG_LOCALE:-C}.${IMAGE_ARG_ENCODING:-UTF-8}" > /etc/profile.d/locale.sh \
    && apk del tzdata \
    && rm -rf /etc/apk/* /tmp/* /var/cache/apk/*
#    && rm -rf /lib/apk/db
