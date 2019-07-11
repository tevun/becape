#!/bin/bash

BECAPE_ROOT_DIR=$(dirname $(dirname $(readlink -f ${0})))

if [[ -f ${BECAPE_ROOT_DIR}/.env ]]; then
  source ${BECAPE_ROOT_DIR}/.env
fi

docker run -d \
  --restart always\
  -p ${BECAPE_MINIO_PORT}:9000\
  --name becape-minio \
  -e "MINIO_ACCESS_KEY=${BECAPE_MINIO_KEY}" \
  -e "MINIO_SECRET_KEY=${BECAPE_MINIO_SECRET}" \
  -e "MINIO_USERNAME=${BECAPE_MINIO_USER}" \
  -e "MINIO_GROUPNAME=${BECAPE_MINIO_USER}" \
  -v /mnt/data:/data \
  -v /mnt/config:/root/.minio \
  minio/minio server /data
