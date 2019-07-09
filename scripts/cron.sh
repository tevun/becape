#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting cron ............... ready"
START=$(date +%s)

# get the user input
if [[ ${BECAPE_LOGIN_PATH} = "" ]]; then
  BECAPE_LOGIN_PATH=${1}
fi

BECAPE_FILE_IDENTIFIER=$(date +"%Y_%m_%d_%H_%M_%S")
source ${BECAPE_SCRIPT_DIR}/backup.sh

BECAPE_UPLOAD_IDENTIFIER=${BECAPE_FILE_IDENTIFIER}
source ${BECAPE_SCRIPT_DIR}/upload.sh

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
