#!/usr/bin/env bash

V_DIR_RESTORE=/var/www/app

source ${V_DIR_RESTORE}.env

UUID=$(cat /proc/sys/kernel/random/uuid)

echo "..................................."
echo $(date)
echo " - "

echo "Starting restore ............ ready"
START=$(date +%s)

# openssl smime -decrypt -in encrypted.file -binary -inform DEM -inkey backup.private.pem -out decrypted.file

#V_DIR_TEMP="${V_DIR_RESTORE}/tmp/${UUID}"
#if [[ ! -d ${V_DIR_TEMP} ]]; then
#  mkdir -p ${V_DIR_TEMP}
#fi

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
