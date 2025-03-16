#!/usr/bin/env bash

# VARIABLES
CONFIG_LOCATION="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME="$(hostname -f)"

source "${CONFIG_LOCATION}/.env"


# FUNCTIONS
send_notification() {
        local MESSAGE="$1"
        curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"${MESSAGE}\", \"username\":\"Backup\"}" "${WEBHOOK_URL}"
}

# Get the list of upgradable packages and count the lines, suppressing warnings
updates=$(/usr/bin/sudo /usr/bin/apt-get update >/dev/null && /usr/bin/sudo /usr/bin/apt list --upgradable 2>/dev/null | /usr/bin/grep -c "/")


# Check if there are updates available
if [[ ${updates} -ne 0 ]]; then
        send_notification "### HEALTH SERVICE \nStatus: :fire: \nHost: $HOSTNAME \nMessage: ${updates} updates available"
fi
