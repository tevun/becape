#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting list .... .......... ready"
START=$(date +%s)

# ls -lah --color=always ${BECAPE_DIR_DATA}
ls -1 ${BECAPE_DIR_DATA} | sed -e 's/\..*$//'

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
