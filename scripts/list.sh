#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting ls ...... .......... ready"
START=$(date +%s)

ls -lah --color=always ${BECAPE_DIR_VOLUME}/data

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
