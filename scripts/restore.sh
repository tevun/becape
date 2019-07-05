#!/usr/bin/env bash

# the base directory
BECAPE_DIR_VOLUME=/var/www/app

# import .env
source ${BECAPE_DIR_VOLUME}/.env

echo "..................................."
echo $(date)
echo " - "

echo "Starting restore ............ ready"
START=$(date +%s)

V_DIR_TEMP=${BECAPE_DIR_VOLUME}/tmp
# create the tmp dir
if [[ ! -d ${V_DIR_TEMP} ]]; then
  mkdir -p ${V_DIR_TEMP}
fi

cd ${V_DIR_TEMP}

V_RESTORE_FILE_NAME="2019_07_05_02_28_17" # ${1}
# openssl smime -decrypt -in encrypted.file -binary -inform DEM -inkey backup.private.pem -out decrypted.file
tar -xzf ${V_RESTORE_FILE_NAME}.backup.tgz


echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
