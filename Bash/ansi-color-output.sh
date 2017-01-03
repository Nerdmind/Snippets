#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
# ANSI color output                          [Thomas Lange <code@nerdmind.de>] #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
#                                                                              #
# This function uses ANSI escape sequences to output colored strings. See here #
# [https://en.wikipedia.org/wiki/ANSI_escape_code] for more information.       #
#                                                                              #
# Parameter 030: Black                                                         #
# Parameter 031: Red                                                           #
# Parameter 032: Green                                                         #
# Parameter 033: Brown                                                         #
# Parameter 034: Blue                                                          #
# Parameter 035: Purple                                                        #
# Parameter 036: Cyan                                                          #
# Parameter 037: Gray                                                          #
# Parameter 130: Dark Gray                                                     #
# Parameter 131: Light Red                                                     #
# Parameter 132: Light Green                                                   #
# Parameter 133: Yellow                                                        #
# Parameter 134: Light Blue                                                    #
# Parameter 135: Light Purple                                                  #
# Parameter 136: Light Cyan                                                    #
# Parameter 137: White                                                         #
#                                                                              #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#

function color() {
	case $1 in
		030) printf '\033[0;30m%s\033[0m' "$2") ;;
		031) printf '\033[0;31m%s\033[0m' "$2") ;;
		032) printf '\033[0;32m%s\033[0m' "$2") ;;
		033) printf '\033[0;33m%s\033[0m' "$2") ;;
		034) printf '\033[0;34m%s\033[0m' "$2") ;;
		035) printf '\033[0;35m%s\033[0m' "$2") ;;
		036) printf '\033[0;36m%s\033[0m' "$2") ;;
		037) printf '\033[0;37m%s\033[0m' "$2") ;;
		130) printf '\033[1;30m%s\033[0m' "$2") ;;
		131) printf '\033[1;31m%s\033[0m' "$2") ;;
		132) printf '\033[1;32m%s\033[0m' "$2") ;;
		133) printf '\033[1;33m%s\033[0m' "$2") ;;
		134) printf '\033[1;34m%s\033[0m' "$2") ;;
		135) printf '\033[1;35m%s\033[0m' "$2") ;;
		136) printf '\033[1;36m%s\033[0m' "$2") ;;
		137) printf '\033[1;37m%s\033[0m' "$2") ;;
	esac
}

echo "Example: $(color 134 "Hello World")!"