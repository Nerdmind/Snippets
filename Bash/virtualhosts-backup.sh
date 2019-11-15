#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
# Virtualhost backup script                  [Thomas Lange <code@nerdmind.de>] #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
#                                                                              #
# This script goes through the first level in the virtual host root directory  #
# and creates for each domain name within a compressed backup file. The script #
# is compatible with a directory structure like the following:                 #
#                                                                              #
# |--- bob                                                                     #
# |   |--- bobs-blog.tld                                                       #
# |        |--- config                                                         #
# |        |--- htdocs                                                         #
# |--- alice                                                                   #
# |   |--- alice-domain.tld                                                    #
# |        |--- config                                                         #
# |        |--- htdocs                                                         #
# |--- thomas                                                                  #
#     |--- sub1.thomas-blog.tld                                                #
#     |    |--- config                                                         #
#     |    |--- htdocs                                                         #
#     |--- sub2.thomas-blog.tld                                                #
#          |--- config                                                         #
#          |--- htdocs                                                         #
#                                                                              #
# OPTION [-q]: Enable quiet mode for use in crontab.                           #
#                                                                              #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#

#===============================================================================
# Parsing command-line arguments with the getopts shell builtin
#===============================================================================
while getopts :q option
do
	case $option in
		q) ARGUMENT_QUIETMODE=true ;;
	esac
done

#===============================================================================
# Define backup main directories
#===============================================================================
DIRECTORY_ROOT="/mnt/data/backups/virtualhosts/"
DIRECTORY_PATH="$(date +%Y-%m-%d-%Hh%Mm)/"
DIRECTORY_FROM="/var/www/"

#===============================================================================
# Delete old backups in backup root directory
#===============================================================================
if [ -d "${DIRECTORY_ROOT}" ]; then
	find "${DIRECTORY_ROOT}"* -maxdepth 0 -type d -mtime +90 -exec rm --recursive {} \;
else
	mkdir -p "${DIRECTORY_ROOT}"
fi

#===============================================================================
# Create backup path directory if not exists
#===============================================================================
if [ ! -d "${DIRECTORY_ROOT}${DIRECTORY_PATH}" ]; then
	mkdir "${DIRECTORY_ROOT}${DIRECTORY_PATH}"
fi

#===============================================================================
# Loop through all usernames within the source root directory
#===============================================================================
for username in $(find ${DIRECTORY_FROM}* -maxdepth 0 -type d -exec basename {} \;); do

	#===============================================================================
	# Define backup sub directories and target filename
	#===============================================================================
	DIRECTORY_USER="${DIRECTORY_ROOT}${DIRECTORY_PATH}${username}/"
	DIRECTORY_FILE="${DIRECTORY_USER}%s.tar.bz2"

	[ ! $ARGUMENT_QUIETMODE ] && echo "[INFO] Entering directory: ${DIRECTORY_FROM}${username}/:"

	#===============================================================================
	# Create backup sub path directory if not exists
	#===============================================================================
	if [ ! -d "${DIRECTORY_USER}" ]; then
		[ ! $ARGUMENT_QUIETMODE ] && echo "[INFO] Creating backup directory for user $username [...]"
		mkdir "${DIRECTORY_USER}"
	fi

	#===============================================================================
	# Loop through all virtualhosts within the user directory
	#===============================================================================
	for virtualhost in $(find ${DIRECTORY_FROM}${username}/* -maxdepth 0 -type d -exec basename {} \;); do
		[ ! $ARGUMENT_QUIETMODE ] && echo "[INFO] Creating compressed backup for virtualhost $virtualhost [...]"
		tar --create --bzip2 --file "$(printf "${DIRECTORY_FILE}" "${virtualhost}")" --directory "${DIRECTORY_FROM}${username}/" "${virtualhost}"
	done
done
