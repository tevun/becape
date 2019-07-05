#!/usr/bin/env bash

source /var/www/app/.env

echo "..................................."
echo $(date)
echo " - "

echo "Starting configure .......... ready"
START=$(date +%s)

# openssl req -x509 -sha256 -nodes -newkey rsa:4096 -keyout mysqldump.priv.pem -out mysqldump.pub.pem
echo "Host: ${DB_HOST}"
echo "Port: ${DB_PORT}"
echo "User: ${DB_USERNAME}"

mysql_config_editor set --login-path=backup --host=${DB_HOST} --port=${DB_PORT} --user=${DB_USERNAME} --password

END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
