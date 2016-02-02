#!/bin/bash

set -eu

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root"
	exit 1
fi

if [ "$#" -ne 1 ]; then
	echo "Usage : ./newUser username"
	exit 1
fi

if id -u "$1" >/dev/null 2>&1; then
        echo "user already exists"
	exit 1
fi

echo "Creating user "$1"..."

useradd --create-home --skel=/etc/skel --shell=/bin/bash $1

mkdir -p /home/$1/www/

