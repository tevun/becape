#!/usr/bin/env bash
# the base directory
V_DIR_BACKUP=/var/www/app

# import .env
if [[ -f ${V_DIR_BACKUP}.env ]]; then
  source ${V_DIR_BACKUP}.env
fi

echo "..................................."
echo $(date)
echo " - "

echo "Starting backup ............. ready"
START=$(date +%s)

# generate a unique name to generate scripts
UUID=$(cat /proc/sys/kernel/random/uuid)
# create the tmp dir
V_DIR_TEMP="${V_DIR_BACKUP}/tmp/${UUID}"
if [[ ! -d ${V_DIR_TEMP} ]]; then
  mkdir -p ${V_DIR_TEMP}
fi

echo -n "1/5 Dumping functions"
# check if FUNCTION file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/FUNCTION.sql ]]; then
  rm ${V_DIR_TEMP}/FUNCTION.sql
fi
# generate FUNCTION dump
mysqldump --login-path=backup --skip-opt --no-create-info --add-drop-table --no-data --routines\
 ${DB_DATABASE} > ${V_DIR_TEMP}/FUNCTION.sql
echo " ....... ready"

echo -n "2/5 Dumping views"
# check if VIEW file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/VIEW.sql ]]; then
  rm ${V_DIR_TEMP}/VIEW.sql
fi
# generate VIEW dump
mysql --login-path=backup INFORMATION_SCHEMA --skip-column-names --batch\
 -e "SELECT table_name FROM tables WHERE table_type = 'VIEW' AND table_schema = '${DB_DATABASE}'"  |\
  xargs mysqldump --login-path=backup ${DB_DATABASE} > ${V_DIR_TEMP}/VIEW.sql
echo " ........... ready"

echo -n "3/5 Dumping tables"
# check if TABLE file already exists and removes it if it exists
if [[ -f ${V_DIR_TEMP}/TABLE.sql ]]; then
  rm ${V_DIR_TEMP}/TABLE.sql
fi
# generate TABLE dump
mysql --login-path=backup INFORMATION_SCHEMA --skip-column-names --batch\
 -e "SELECT table_name FROM tables WHERE table_type = 'BASE TABLE' AND table_schema = '${DB_DATABASE}'"\
  | xargs mysqldump --login-path=backup ${DB_DATABASE} > ${V_DIR_TEMP}/TABLE.sql
echo " .......... ready"

echo -n "4/5 Encrypt files "
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
   -outform DER /var/www/app/backup.public.pem
  rm ${V_DIR_TEMP}/${filename}.sql
done
echo " .......... ready"

echo -n "5/5 Compress data "
# go to temp dir
cd ${V_DIR_TEMP}
# create the name of file
V_BACKUP_FILE=$(date +"%Y_%m_%d-%H_%M_%S").backup.tgz
# create the backup file and remove the encrypted files
tar czf ${V_BACKUP_FILE} * --remove-files
# create the data dir if not exists
if [[ ! -d ${V_DIR_BACKUP}/data ]]; then
  mkdir -p ${V_DIR_BACKUP}/data
fi
# move the backup file data dir
mv ${V_BACKUP_FILE} ${V_DIR_BACKUP}/data
# go to backup dir
cd ${V_DIR_BACKUP}
# remove the temp dir
rm -rf ${V_DIR_TEMP}

echo " .......... ready"

echo " - "
END=$(date +%s)
TIME=$(( $END - $START ))

echo "..................................."
echo "time: ${TIME}s"
