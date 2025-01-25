#!/usr/bin/env bash

# Source .env file
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" &&
    source .env

# FUNCTIONS
send_email() {
        local message="Updates available \n\n ${1}"
        echo -e "Subject: HEALTH: Updates available - $(hostname -f)\n\n ${message}" | /usr/sbin/sendmail "$EMAIL_ADDRESS"
}

# Get the list of upgradable packages and count the lines, suppressing warnings
updates=$(/usr/bin/sudo /usr/bin/apt-get update >/dev/null && /usr/bin/sudo /usr/bin/apt list --upgradable 2>/dev/null | /usr/bin/grep -c "/")

# Check if there are updates available
if [[ ${updates} -ne 0 ]]; then
        # Send mail to the mail adress from .env-file if updates are available
        send_email "${updates} updates available"
fi
