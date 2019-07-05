#!/usr/bin/env bash

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

#
V_RESTORE_FILE_NAME="2019_07_05_02_28_17" # ${1}
#
cp ${BECAPE_DIR_VOLUME}/data/${V_RESTORE_FILE_NAME}.backup.tgz ${V_DIR_TEMP}/
#
cd ${V_DIR_TEMP}
#
tar -xzf ${V_RESTORE_FILE_NAME}.backup.tgz
# openssl smime -decrypt -in encrypted.file -binary -inform DEM -inkey backup.private.pem -out decrypted.file

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
