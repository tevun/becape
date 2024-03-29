#!/usr/bin/env bash

# check environment variables
if [[ ${BECAPE_MYSQL_DATABASE} = "" ]]; then
  echo "Missing required variables: 'BECAPE_MYSQL_DATABASE'"
  exit 1
fi
# check public certificate
if [[ ! -f ${BECAPE_DIR_VOLUME}/backup.public.pem ]]; then
  echo "Missing required certificate: '${BECAPE_DIR_VOLUME}/backup.public.pem'"
  exit 1
fi
# check if exists a BECAPE_FILE_IDENTIFIER
if [[ ${BECAPE_FILE_IDENTIFIER} = "" ]]; then
  BECAPE_FILE_IDENTIFIER=$(date +"%Y_%m_%d_%H_%M_%S")
fi

MYSQL_ACCESS_CREDENTIAL="--login-path=${BECAPE_LOGIN_PATH}"
if [[ ! -z ${BECAPE_MYSQL_LEGACY} ]]; then
  MYSQL_ACCESS_CREDENTIAL="--defaults-group-suffix=-${BECAPE_LOGIN_PATH}"
fi
if [[ -z ${BECAPE_DIR_DATA} ]]; then
  BECAPE_DIR_DATA=${BECAPE_DIR_VOLUME}/data
fi

echo "..................................."
echo $(date)
echo " - "

echo "Starting backup ............. ready"
START=$(date +%s)

# generate a unique name to generate scripts
UUID=$(cat /proc/sys/kernel/random/uuid)
# create the tmp dir
V_DIR_TEMP="${BECAPE_DIR_VOLUME}/tmp/${UUID}"
if [[ ! -d ${V_DIR_TEMP} ]]; then
  mkdir -p ${V_DIR_TEMP}
fi

echo -n "1/5 Dumping functions"
# check if FUNCTION file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/FUNCTION.sql ]]; then
  rm ${V_DIR_TEMP}/FUNCTION.sql
fi
# generate FUNCTION dump
mysqldump ${MYSQL_ACCESS_CREDENTIAL} --force --skip-opt --no-create-info --add-drop-table --no-data --routines\
 ${BECAPE_MYSQL_DATABASE} > ${V_DIR_TEMP}/FUNCTION.sql
# change file permissions
chmod 600 ${V_DIR_TEMP}/FUNCTION.sql
echo " ....... ready"

echo -n "2/5 Dumping views"
# check if VIEW file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/VIEW.sql ]]; then
  rm ${V_DIR_TEMP}/VIEW.sql
fi
# generate VIEW dump
mysql ${MYSQL_ACCESS_CREDENTIAL} --force INFORMATION_SCHEMA --skip-column-names --batch\
 -e "SELECT table_name FROM tables WHERE table_type = 'VIEW' AND table_schema = '${BECAPE_MYSQL_DATABASE}'"  |\
  xargs mysqldump ${MYSQL_ACCESS_CREDENTIAL} --force ${BECAPE_MYSQL_DATABASE} > ${V_DIR_TEMP}/VIEW.sql
# change file permissions
chmod 600 ${V_DIR_TEMP}/VIEW.sql
echo " ........... ready"

echo -n "3/5 Dumping tables"
# check if TABLE file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/TABLE.sql ]]; then
  rm ${V_DIR_TEMP}/TABLE.sql
fi
# generate TABLE dump
mysql ${MYSQL_ACCESS_CREDENTIAL} --force INFORMATION_SCHEMA --skip-column-names --batch\
 -e "SELECT table_name FROM tables WHERE table_type = 'BASE TABLE' AND table_schema = '${BECAPE_MYSQL_DATABASE}'"\
  | xargs mysqldump ${MYSQL_ACCESS_CREDENTIAL} --force ${BECAPE_MYSQL_DATABASE} > ${V_DIR_TEMP}/TABLE.sql
# change file permissions
chmod 600 ${V_DIR_TEMP}/TABLE.sql
echo " .......... ready"

echo -n "4/5 Encrypting files"
# create array with the files name
declare -a arr=("FUNCTION" "VIEW" "TABLE")

## now loop through the above array
for filename in "${arr[@]}"
do
  # check if encrypted file already exists and removes it if it exists
  if [[ -f ${V_DIR_TEMP}/${filename}.sql.encrypted ]]; then
    rm ${V_DIR_TEMP}/${filename}.sql.encrypted
  fi
  # encrypt
  openssl smime -encrypt -binary -text -aes256\
    -in ${V_DIR_TEMP}/${filename}.sql\
    -out ${V_DIR_TEMP}/${filename}.sql.encrypted\
    -outform DER ${BECAPE_DIR_VOLUME}/backup.public.pem
  rm ${V_DIR_TEMP}/${filename}.sql
done
echo " ........ ready"

echo -n "5/5 Compressing data"
# go to temp dir
cd ${V_DIR_TEMP}
# create the name of file
V_BACKUP_FILE=${BECAPE_FILE_IDENTIFIER}.backup.tgz
# create the backup file and remove the encrypted files
tar czf ${V_BACKUP_FILE} * --remove-files
# change file permissions
chmod 400 ${V_BACKUP_FILE}
# create the data dir if not exists
if [[ ! -d ${BECAPE_DIR_DATA} ]]; then
  mkdir -p ${BECAPE_DIR_DATA}
fi
# move the backup file data dir
mv ${V_BACKUP_FILE} ${BECAPE_DIR_DATA}
# go to backup dir
cd ${BECAPE_DIR_VOLUME}
# remove the temp dir
rm -rf ${V_DIR_TEMP}

echo " ........ ready"

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
