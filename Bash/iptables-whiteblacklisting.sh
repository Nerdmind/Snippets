#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
# IPTables port whitelisting-/blacklisting   [Thomas Lange <code@nerdmind.de>] #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
#                                                                              #
# This script configures your firewall with whitelisting or blacklisting rules #
# and is compatible with IPv4 and IPv6. If you do not have IPv6 just uncomment #
# all lines which containing a "${IPTABLES_V6}". If you want to add additional #
# rules then you can do that at the end of the script. This makes sense if you #
# want allow or disallow internal network traffic from gateway or something.   #
#                                                                              #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#

#===============================================================================
# Set whitelisting or blacklisting mode
#===============================================================================
MODE='WHITELISTING' # This can only be "WHITELISTING" or "BLACKLISTING"

#===============================================================================
# Whitelisting matching rules: <protocol>:<port>
#===============================================================================
WHITELISTING=(
	# SSH
	'tcp:2200'

	# HTTP
	'tcp:80'
	'tcp:443'

	# XMPP
	'tcp:5222'
	'tcp:5269'

	# TeamSpeak
	'udp:9987'
	'tcp:30033'
	'tcp:10011'
	'tcp:41144'
)

#===============================================================================
# Blacklisting matching rules: <protocol>:<port>
#===============================================================================
BLACKLISTING=()

#===============================================================================
# Define IPTables commands for IPv4 and IPv6
#===============================================================================
IPTABLES_V4=$(which iptables)
IPTABLES_V6=$(which ip6tables)

#===============================================================================
# Define IPTables-save commands for IPv4 and IPv6
#===============================================================================
IPTABLES_SAVE_V4=$(which iptables-save)
IPTABLES_SAVE_V6=$(which ip6tables-save)

#===============================================================================
# Wrapper function for IPTables with IPv4 and IPv6
#===============================================================================
IPTABLES() {
	${IPTABLES_V4} $@ # Appends the given argument string to IPTables for IPv4
	${IPTABLES_V6} $@ # Appends the given argument string to IPTables for IPv6
}

#===============================================================================
# Set whitelisting and blacklisting chain names
#===============================================================================
WHITELIST_CHAIN='WHITELIST'
BLACKLIST_CHAIN='BLACKLIST'

#===============================================================================
# INPUT policy reset and flush
#===============================================================================
IPTABLES --policy INPUT ACCEPT
IPTABLES --flush INPUT

#===============================================================================
# Ping requests over ICMP and ICMPv6 protocol are always accepted
#===============================================================================
${IPTABLES_V4} --append INPUT --protocol icmp   --jump ACCEPT
${IPTABLES_V6} --append INPUT --protocol icmpv6 --jump ACCEPT

#===============================================================================
# Local loopback connections are also always accepted
#===============================================================================
IPTABLES --append INPUT -i lo --jump ACCEPT

#===============================================================================
# Accept all (already) related and established connections
#===============================================================================
IPTABLES --append INPUT --match state --state RELATED,ESTABLISHED --jump ACCEPT

#===============================================================================
# Flush whitelisting and blacklisting chains if exists
#===============================================================================
IPTABLES --flush "${WHITELIST_CHAIN}" &> /dev/null
IPTABLES --flush "${BLACKLIST_CHAIN}" &> /dev/null

#===============================================================================
# Delete references to whitelisting and blacklisting chains if exists
#===============================================================================
IPTABLES --delete INPUT --jump "${WHITELIST_CHAIN}" &> /dev/null
IPTABLES --delete INPUT --jump "${BLACKLIST_CHAIN}" &> /dev/null

#===============================================================================
# Delete whitelisting and blacklisting chains if exists
#===============================================================================
IPTABLES --delete-chain "${WHITELIST_CHAIN}" &> /dev/null
IPTABLES --delete-chain "${BLACKLIST_CHAIN}" &> /dev/null

#===============================================================================
# Create new whitelisting-/blacklisting chain
#===============================================================================
if [ ${MODE} == 'WHITELISTING' ]; then IPTABLES --new-chain "${WHITELIST_CHAIN}"; fi
if [ ${MODE} == 'BLACKLISTING' ]; then IPTABLES --new-chain "${BLACKLIST_CHAIN}"; fi

#===============================================================================
# Create reference to the whitelisting-/blacklisting chain
#===============================================================================
if [ ${MODE} == 'WHITELISTING' ]; then IPTABLES --table filter --append INPUT --jump "${WHITELIST_CHAIN}"; fi
if [ ${MODE} == 'BLACKLISTING' ]; then IPTABLES --table filter --append INPUT --jump "${BLACKLIST_CHAIN}"; fi

#===============================================================================
# Create IPTables matching rules for whitelisting
#===============================================================================
if [ ${MODE} == 'WHITELISTING' ]; then
	for rule in "${WHITELISTING[@]}"; do
		IPTABLES --append "${WHITELIST_CHAIN}" --protocol "${rule%%:*}" --destination-port "${rule##*:}" --jump ACCEPT
	done

	IPTABLES --policy INPUT DROP
fi

#===============================================================================
# Create IPTables matching rules for blacklisting
#===============================================================================
if [ ${MODE} == 'BLACKLISTING' ]; then
	for rule in "${BLACKLISTING[@]}"; do
		IPTABLES --append "${BLACKLIST_CHAIN}" --protocol "${rule%%:*}" --destination-port "${rule##*:}" --jump REJECT
	done

	IPTABLES --policy INPUT ACCEPT
fi

#===============================================================================
# ADDITIONAL RULES
#===============================================================================
${IPTABLES_V4} --append INPUT --source 192.168.1.0/24 --jump ACCEPT
${IPTABLES_V6} --append INPUT --source fe80::/64 --jump ACCEPT

#===============================================================================
# Save IPTables configuration permanent
#===============================================================================
if [ ${IPTABLES_SAVE_V4} ]; then ${IPTABLES_SAVE_V4} > /etc/iptables/rules.v4; fi
if [ ${IPTABLES_SAVE_V6} ]; then ${IPTABLES_SAVE_V6} > /etc/iptables/rules.v6; fi