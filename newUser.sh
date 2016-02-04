#!/bin/bash

set -eu

servn='clubisen.fr'

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root"
	exit 1
fi

if [ "$#" -ne 1 ]; then
	echo "Usage : ./newUser username"
	exit 1
fi

userDir='/home/'$1'/www/'

if id -u "$1" >/dev/null 2>&1; then
        echo "user already exists"
	exit 1
fi


echo "Creating user "$1"..."
useradd --create-home --skel=/etc/skel --shell=/bin/bash $1

echo "Creating home directory "$userDir" ..."
mkdir -p $userDir

read -p 'Clone git repo (optional): ' cloneUrl;

if [ ! -z "$cloneUrl" ]
then
	git clone $cloneUrl $userDir
else
	echo "Creating default index ..."
	echo $1 > $userDir/index.html
fi


chown -R $1:www-data $userDir
chmod -R '644' $userDir
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
</VirtualHost>" > /etc/apache2/sites-available/$1.$servn.conf

if [ ! -f /etc/apache2/sites-available/$1.$servn.conf ]
then
	echo "Virtual host wasn't created !"
	exit 1
else
	echo "Virtual host created !"
fi

echo "Creating symbolic link"

/bin/ln -s /etc/apache2/sites-available/$1.$servn.conf /etc/apache2/sites-enabled/$1.$servn.conf

echo "Restarting apache2 ..."

/etc/init.d/apache2 restart

apacheStatus=$(ps -ef | grep apache2 | grep -v grep)

if [ -z "$apacheStatus" ]
then
        echo "Apache2 is not started"
        exit 1
fi

echo "Apache 2 started !"

exit 0
