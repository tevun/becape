#!/usr/bin/env bash

# the base directory
BECAPE_DIR_VOLUME=/var/www/app

# import .env
source ${BECAPE_DIR_VOLUME}/.env

echo "..................................."
echo $(date)
echo " - "

echo "Starting configure .......... ready"
START=$(date +%s)

echo "Current '.env' settings"
echo "Host: ${DB_HOST}"
echo "Port: ${DB_PORT}"
echo "User: ${DB_USERNAME}"

mysql_config_editor set --login-path=backup --host=${DB_HOST} --port=${DB_PORT} --user=${DB_USERNAME} --password

END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
