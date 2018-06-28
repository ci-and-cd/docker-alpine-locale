
FROM alpine:3.7

MAINTAINER haolun

COPY data/layer.tar /data/layer.tar
RUN tar xf /data/layer.tar -C /
