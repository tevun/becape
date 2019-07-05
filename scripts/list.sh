#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting list .... .......... ready"
START=$(date +%s)

# ls -lah --color=always ${BECAPE_DIR_VOLUME}/data
ls -1 ${BECAPE_DIR_VOLUME}/data | sed -e 's/\..*$//'

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
