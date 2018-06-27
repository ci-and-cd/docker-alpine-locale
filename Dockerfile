
FROM alpine:3.7

MAINTAINER haolun

COPY data/fonts_locale_tz.tar /data/fonts_locale_tz.tar

RUN tar xf /data/fonts_locale_tz.tar -C /
