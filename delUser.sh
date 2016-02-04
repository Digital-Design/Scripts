#!/bin/bash

set -eu

servn='clubisen.fr'

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root"
	exit 1
fi

if [ "$#" -ne 1 ]; then
	echo "Usage : ./delUser username"
	exit 1
fi

userDir='/home/'$1'/'

if ! id -u "$1" >/dev/null 2>&1; then
        echo "user doesn't exists"
	exit 1
fi

userdel $1
rm -rf $userDir
rm -rf /var/log/apache2/$1/
rm -f /etc/apache2/sites-available/$1.$servn.conf
rm -f /etc/apache2/sites-enabled/$1.$servn.conf

/etc/init.d/apache2 restart
