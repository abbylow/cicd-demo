FROM nginx:stable

# Maintainer
MAINTAINER "kaiwei.lim@bybit.com"

ARG ENV
ARG BUILD_APP
ENV ENV=$ENV
ENV BUILD_APP=$BUILD_APP

COPY ./dist/$ENV/apps/$BUILD_APP/exported/ /var/www/
COPY ./apps/$BUILD_APP/.kubernetes/server.conf /etc/nginx/conf.d/default.conf