#!/usr/bin/env bash

# check environment variables
if [[ ${BECAPE_MYSQL_DATABASE} = "" ]]; then
  echo "Missing required variables: 'BECAPE_MYSQL_DATABASE'"
  exit 1
fi
# check backup filename
V_RESTORE_FILE_NAME=${1} #"2019_07_05_02_28_17"
if [[ ${V_RESTORE_FILE_NAME} = "" ]]; then
  echo "Missing required parameter: 'RESTORE_FILE_NAME'"
  exit 1
fi

echo "..................................."
echo $(date)
echo " - "

echo "Starting restore ............ ready"
START=$(date +%s)

# create array with the files name
declare -a arr=("FUNCTION" "VIEW" "TABLE")

echo -n "1/4 Unpacking backup file"
V_DIR_TEMP=${BECAPE_DIR_VOLUME}/tmp
# create the tmp dir
if [[ ! -d ${V_DIR_TEMP} ]]; then
  mkdir -p ${V_DIR_TEMP}
fi
cp ${BECAPE_DIR_DATA}/${V_RESTORE_FILE_NAME}.backup.tgz ${V_DIR_TEMP}/
cd ${V_DIR_TEMP}
tar -xzf ${V_RESTORE_FILE_NAME}.backup.tgz
rm ${V_RESTORE_FILE_NAME}.backup.tgz
echo " ... ready"

echo -n "2/4 Decrypting files "
## now loop through the above array
for filename in "${arr[@]}"
do
  #
  if [[ -f ${V_DIR_TEMP}/${filename}.sql.encrypted ]]; then
    # decrypt
    openssl smime -decrypt -binary -inform DEM\
      -in ${V_DIR_TEMP}/${filename}.sql.encrypted\
      -out ${V_DIR_TEMP}/${filename}.sql\
      -inform DEM -inkey ${BECAPE_DIR_VOLUME}/backup.private.pem
    # openssl smime -decrypt -in encrypted.file -binary -inform DEM -inkey backup.private.pem -out decrypted.file
    rm ${V_DIR_TEMP}/${filename}.sql.encrypted
  fi
done
echo " ....... ready"

echo -n "3/4 Defining database"
echo "DROP DATABASE IF EXISTS \`${BECAPE_MYSQL_DATABASE}\`" | mysql --login-path=backup --force
echo "CREATE DATABASE \`${BECAPE_MYSQL_DATABASE}\`" | mysql --login-path=backup --force
# echo "GRANT ALL PRIVILEGES ON *.* TO 'database'@'%' WITH GRANT OPTION" | mysql --login-path=backup --force
# sed -ie 's/ROW_FORMAT=FIXED//g' ${project_data}/${database_name}/TABLE.sql
echo " ....... ready"

echo -n "4/4 Restoring resources"
## now loop through the above array
for filename in "${arr[@]}"
do
  mysql --login-path=backup --force ${BECAPE_MYSQL_DATABASE} < ${V_DIR_TEMP}/${filename}.sql
  rm ${V_DIR_TEMP}/${filename}.sql
done
echo " ..... ready"

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
