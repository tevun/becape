#!/usr/bin/env bash

# the home directory
BECAPE_DIR_SAMPLE=${BECAPE_DIR_HOME}/sample

MUST_EXIT=0
V_MISSING=""

# create array with the files name
declare -a arr=("backup.private.pem" "backup.public.pem")
## now loop through the above array
for filename in "${arr[@]}"
do
  if [[ ! -f ${BECAPE_DIR_VOLUME}/${filename} ]]; then
    MUST_EXIT=1
    V_MISSING=", '${filename}'${V_MISSING}"
    cp ${BECAPE_DIR_SAMPLE}/${filename}.sample ${BECAPE_DIR_VOLUME}/
  fi
done

if [[ ${MUST_EXIT} = 1 ]]; then
  echo "Missing required files in volume '${BECAPE_DIR_VOLUME}': ${V_MISSING:2}"
  exit ${MUST_EXIT}
fi