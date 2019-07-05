#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo -n "Starting upload"
START=$(date +%s)

TARGET="${1}.backup.tgz"

FRAGMENT=""
declare -a arr=("1" "2" "3")
for INDEX in "${arr[@]}"
do
  FRAGMENT="${FRAGMENT}/$(echo "${1}" | cut -d'_' -f${INDEX})"
done
FRAGMENT="${FRAGMENT:1}"

FILE="${BECAPE_DIR_DATA}/${TARGET}"

DATE=$(date +"%a, %d %b %Y %T %z")
CONTENT_TYPE='application/octet-stream'
BODY="PUT\n\n${CONTENT_TYPE}\n${DATE}\n/${BECAPE_MINIO_BUCKET}/${FRAGMENT}/${TARGET}"
SIGNATURE=$(echo -en "${BODY}" | openssl sha1 -hmac "${BECAPE_MINIO_SECRET}" -binary | base64)
curl -X PUT -T "${FILE}" \
  -H "Host: ${BECAPE_MINIO_HOST}:${BECAPE_MINIO_PORT}" \
  -H "Date: ${DATE}" \
  -H "Content-Type: ${CONTENT_TYPE}" \
  -H "Authorization: AWS ${BECAPE_MINIO_KEY}:${SIGNATURE}" \
  "${BECAPE_MINIO_PROTOCOL}://${BECAPE_MINIO_HOST}:${BECAPE_MINIO_PORT}/${BECAPE_MINIO_BUCKET}/${FRAGMENT}/${TARGET}"

echo " ............ ready"

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
