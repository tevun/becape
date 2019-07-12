#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting keys ............... ready"
START=$(date +%s)

openssl req -x509 -sha256 -nodes -newkey rsa:4096\
 -keyout ${BECAPE_DIR_VOLUME}/backup.private.pem\
 -out ${BECAPE_DIR_VOLUME}/backup.public.pem

if [[ ! -z ${BECAPE_PROJECT} ]]; then
  mkdir -p ${BECAPE_ROOT_DIR}/certificates/${BECAPE_PROJECT}
  mkdir -p ${BECAPE_ROOT_DIR}/public/${BECAPE_PROJECT}

  cp ${BECAPE_DIR_VOLUME}/backup.private.pem ${BECAPE_ROOT_DIR}/certificates/${BECAPE_PROJECT}
  cp ${BECAPE_DIR_VOLUME}/backup.public.pem ${BECAPE_ROOT_DIR}/certificates/${BECAPE_PROJECT}
  cp ${BECAPE_DIR_VOLUME}/backup.public.pem ${BECAPE_ROOT_DIR}/public/${BECAPE_PROJECT}
fi

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
