#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo -n "Starting upload"
START=$(date +%s)

# get the user input
if [[ ${BECAPE_UPLOAD_IDENTIFIER} = "" ]]; then
  BECAPE_UPLOAD_IDENTIFIER=${1}
fi
TARGET="${BECAPE_UPLOAD_IDENTIFIER}.backup.tgz"

FRAGMENT=""
declare -a arr=("1" "2" "3")
for INDEX in "${arr[@]}"
do
  FRAGMENT="${FRAGMENT}/$(echo "${BECAPE_UPLOAD_IDENTIFIER}" | cut -d'_' -f${INDEX})"
done
FRAGMENT="${FRAGMENT:1}"

FILE="${BECAPE_DIR_DATA}/${TARGET}"

REQUEST_DATE=$(date +"%a, %d %b %Y %T %z")
REQUEST_CONTENT_TYPE='application/octet-stream'
REQUEST_BODY="PUT\n\n${REQUEST_CONTENT_TYPE}\n${REQUEST_DATE}\n/${BECAPE_MINIO_BUCKET}/${FRAGMENT}/${TARGET}"
REQUEST_SIGNATURE=$(echo -en "${REQUEST_BODY}" | openssl sha1 -hmac "${BECAPE_MINIO_SECRET}" -binary | base64)
curl -X PUT -T "${FILE}" \
  -H "Host: ${BECAPE_MINIO_HOST}:${BECAPE_MINIO_PORT}" \
  -H "Date: ${REQUEST_DATE}" \
  -H "Content-Type: ${REQUEST_CONTENT_TYPE}" \
  -H "Authorization: AWS ${BECAPE_MINIO_KEY}:${REQUEST_SIGNATURE}" \
  "${BECAPE_MINIO_PROTOCOL}://${BECAPE_MINIO_HOST}:${BECAPE_MINIO_PORT}/${BECAPE_MINIO_BUCKET}/${FRAGMENT}/${TARGET}"

echo " ............ ready"

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
