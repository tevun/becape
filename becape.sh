#!/usr/bin/env bash

BECAPE_ROOT_DIR=$(dirname $(readlink -f ${0}))
BECAPE_SCRIPT_DIR=${BECAPE_ROOT_DIR}/scripts

SOURCE_FILE=${BECAPE_SCRIPT_DIR}/${1}.sh

if [[ -f ${SOURCE_FILE} ]]; then
  source ${SOURCE_FILE}
else
  echo "[invalid command ${1}]"
fi