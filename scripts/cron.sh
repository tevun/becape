#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting cron ............... ready"
START=$(date +%s)

# get the user input
if [[ ! -z ${1} ]]; then
  BECAPE_LOGIN_PATH=${1}
fi

BECAPE_FILE_IDENTIFIER=$(date +"%Y_%m_%d_%H_%M_%S")
source ${BECAPE_SCRIPT_DIR}/backup.sh

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
