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

userDir='/home/'$1'/www/'

echo "Creating user "$1"..."

useradd --create-home --skel=/etc/skel --shell=/bin/bash $1

mkdir -p $userDir

read -p 'Clone git repo (optional): ' cloneUrl;

if [ ! -z "$cloneUrl" ]
then
	git clone $cloneUrl $userDir
else
	echo $1 > $userdir/index.html
fi

servn='clubisen.fr'

chown -R $1:www-data $userDir
chmod -R '755' $userDir
mkdir /var/log/apache2/$1/

echo "#### Virtual Host pour "$1.$servn"

<VirtualHost *:80>
	ServerName $servn
	ServerAlias $1.$servn
	DocumentRoot $userDir

	<Directory $userDir>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>
	CustomLog /var/log/apache2/$1/access.log combined
	ErrorLog /var/log/apache2/$1/error.log
</VirtualHost>" > /etc/apache2/site-available/$1.$servn.conf

if [ ! -f /etc/apache2/site-available/$1.$servn.conf ]
then
	echo "Virtual host wasn't created !"
else
	echo "Virtual host created !"
fi

