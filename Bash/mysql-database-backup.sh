#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
# MySQL database backup script                 [Thomas Lange <tl@nerdmind.de>] #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
#                                                                              #
# This database backup script goes through each database (except the excluded  #
# databases in DATABASE_EXCLUDED) and creates a bzip2 compressed backup file.  #
#                                                                              #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#

#===============================================================================
# Define database login credentials and excluded databases
#===============================================================================
DATABASE_USERNAME="InsertYourUsernameHere"
DATABASE_PASSWORD="InsertYourPasswordHere"
DATABASE_EXCLUDED="(Database|mysql|information_schema|performance_schema)"

#===============================================================================
# Define backup directories and target filename
#===============================================================================
DIRECTORY_ROOT="/mnt/data/backups/databases/"
DIRECTORY_PATH="$(date +%Y-%m-%d-%Hh%Mm)/"
DIRECTORY_FILE="${DIRECTORY_ROOT}${DIRECTORY_PATH}%s.sql.bz2"

#===============================================================================
# Delete old backups in backup root directory
#===============================================================================
find "${DIRECTORY_ROOT}" -type d -mtime +30 -exec rm --recursive {} \;

#===============================================================================
# Create backup path directory if not exists
#===============================================================================
if [ ! -d "${DIRECTORY_ROOT}${DIRECTORY_PATH}" ]; then
	mkdir "${DIRECTORY_ROOT}${DIRECTORY_PATH}"
fi

#===============================================================================
# Fetch all database names from local MySQL server
#===============================================================================
DATABASES=`mysql --user="${DATABASE_USERNAME}" --password="${DATABASE_PASSWORD}" --execute="SHOW DATABASES;" | grep -Ev "${DATABASE_EXCLUDED}"`

#===============================================================================
# Loop through all database names and create compressed database backup
#===============================================================================
for database in ${DATABASES}; do
	echo "[INFO] Creating compressed backup for database ${database} [...]"
	mysqldump --lock-all-tables --user="${DATABASE_USERNAME}" --password="${DATABASE_PASSWORD}" "${database}" | bzip2 > $(printf "${DIRECTORY_FILE}" "${database}")
done