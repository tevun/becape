#!/usr/bin/env bash

BECAPE_ROOT_DIR=$(dirname $(readlink -f ${0}))
BECAPE_SCRIPT_DIR=${BECAPE_ROOT_DIR}/scripts

if [[ -z ${BECAPE_DIR_VOLUME} ]]; then
  BECAPE_DIR_VOLUME=${BECAPE_ROOT_DIR}/app
fi

if [[ -f ${BECAPE_ROOT_DIR}/.env ]]; then
  source ${BECAPE_ROOT_DIR}/.env
fi

SOURCE_FILE=${BECAPE_SCRIPT_DIR}/${1}.sh

if [[ -f ${SOURCE_FILE} ]]; then
  source ${SOURCE_FILE}
else
  echo "[invalid command ${1}]"
fi
