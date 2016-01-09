#!/bin/bash
#===============================================================================
# Define database login credentials and excluded databases
#===============================================================================
DATABASE_USERNAME="InsertYourUsernameHere"
DATABASE_PASSWORD="InsertYourPasswordHere"
DATABASE_EXCLUDED="(Database|mysql|information_schema|performance_schema)"

#===============================================================================
# Define backup directories and target filename
#===============================================================================
DIRECTORY_ROOT="/mnt/backups/databases/"
DIRECTORY_PATH="$(date +%Y-%m-%d-%Hh%Mm)/"
DIRECTORY_FILE="${DIRECTORY_ROOT}${DIRECTORY_PATH}%s.sql.bz2"

#===============================================================================
# Delete old backups in backup root directory
#===============================================================================
find "${DIRECTORY_ROOT}" -type d -mtime +30 -exec rm -r {} \;

#===============================================================================
# Create backup path directory if not exists
#===============================================================================
if [ ! -d "${DIRECTORY_ROOT}${DIRECTORY_PATH}" ]; then
	mkdir "${DIRECTORY_ROOT}${DIRECTORY_PATH}"
fi

#===============================================================================
# Fetch all databases from local MySQL server
#===============================================================================
DATABASES=`mysql --user="${DATABASE_USERNAME}" --password="${DATABASE_PASSWORD}" --execute "SHOW DATABASES;" | grep -Ev "${DATABASE_EXCLUDED}"`

#===============================================================================
# Loop through all databases and create compressed dump
#===============================================================================
for database in ${DATABASES}; do
	mysqldump --user="${DATABASE_USERNAME}" --password="${DATABASE_PASSWORD}" "${database}" | bzip2 > $(printf "${DIRECTORY_FILE}" "${database}")
done