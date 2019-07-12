#!/usr/bin/env bash

MUST_EXIT=0
# create array with the files name
declare -a arr=("BECAPE_MYSQL_HOST", "BECAPE_MYSQL_PORT", "BECAPE_MYSQL_DATABASE", "BECAPE_MYSQL_USER")
## now loop through the above array
for variable in "${arr[@]}"
do
  if [[ ! ${variable} ]]; then
    MUST_EXIT=1
    V_MISSING=", '${variable}'${V_MISSING}"
  fi
done

if [[ ${MUST_EXIT} = 1 ]]; then
  echo "Missing required environment variables: ${V_MISSING:2}"
  exit ${MUST_EXIT}
fi

# get the user input
if [[ ${BECAPE_LOGIN_PATH} = "" ]]; then
  BECAPE_LOGIN_PATH=${1}
fi

echo "..................................."
echo $(date)
echo " - "

echo "Starting configure .......... ready"
START=$(date +%s)

echo "Environment variables"
echo "Login Path: ... ${BECAPE_LOGIN_PATH}"
echo "Host: ......... ${BECAPE_MYSQL_HOST}"
echo "Port: ......... ${BECAPE_MYSQL_PORT}"
echo "Database: ..... ${BECAPE_MYSQL_DATABASE}"
echo "User: ......... ${BECAPE_MYSQL_USER}"

if [[ ! -z ${BECAPE_MYSQL_LEGACY} ]]; then
  # write ~/.my.cnf
  read V_PASSWORD
  V_CNF="[client-${BECAPE_LOGIN_PATH}]\n
  host=${BECAPE_MYSQL_HOST}\n
  user=${BECAPE_MYSQL_USER}\n
  password=${V_PASSWORD}\n"
  echo -e "${V_CNF}" >> ~/.my.cnf
  echo "Coping current credentials .. ready"
  cp ~/.my.cnf ${BECAPE_DIR_VOLUME}/.my.cnf.$(date +"%Y_%m_%d_%H_%M_%S")
else
  # write ~/.mylogin.cnf
  MYSQL_ACCESS_CREDENTIAL="--login-path=${BECAPE_LOGIN_PATH}"
  mysql_config_editor set ${MYSQL_ACCESS_CREDENTIAL} --host=${BECAPE_MYSQL_HOST} --port=${BECAPE_MYSQL_PORT} --user=${BECAPE_MYSQL_USER} --password

  echo "Coping current credentials .. ready"
  cp ~/.mylogin.cnf ${BECAPE_DIR_VOLUME}/.mylogin.cnf.$(date +"%Y_%m_%d_%H_%M_%S")
fi

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
