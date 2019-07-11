#!/bin/bash

BECAPE_ROOT_DIR=$(dirname $(dirname $(readlink -f ${0})))

docker run -d \
  --restart always\
  -p 80:80\
  --name becape-httpd \
  -v ${BECAPE_ROOT_DIR}/public:/usr/local/apache2/htdocs \
  httpd:2.4