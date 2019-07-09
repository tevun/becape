#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting keys ............... ready"
START=$(date +%s)

openssl req -x509 -sha256 -nodes -newkey rsa:4096\
 -keyout ${BECAPE_DIR_VOLUME}/backup.private.pem\
 -out ${BECAPE_DIR_VOLUME}/backup.public.pem

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
