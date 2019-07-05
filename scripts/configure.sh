#!/usr/bin/env bash

echo "..................................."
echo $(date)
echo " - "

echo "Starting configure .......... ready"
START=$(date +%s)

MUST_EXIT=0
# create array with the files name
declare -a arr=("BECAPE_HOST", "BECAPE_PORT", "BECAPE_DATABASE", "BECAPE_USER")
## now loop through the above array
for variables in "${arr[@]}"
do
  if [[ ! ${variables} ]]; then
    MUST_EXIT=1
    V_MISSING=", '${variables}'${V_MISSING}"
  fi
done

if [[ ${MUST_EXIT} = 1 ]]; then
  echo "Missing required environment variables: ${V_MISSING:2}"
  exit ${MUST_EXIT}
fi

echo "Environment variables"
echo "Host: ........${BECAPE_HOST}"
echo "Port: ....... ${BECAPE_PORT}"
echo "Database: ... ${BECAPE_DATABASE}"
echo "User: ........${BECAPE_USER}"

mysql_config_editor set --login-path=backup --host=${BECAPE_HOST} --port=${BECAPE_PORT} --user=${BECAPE_USER} --password

END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
