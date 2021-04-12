#!/bin/bash
echo "installation paquets update"
apt udapte
apt install -y mariadb-client mariadb-server
apt install -y php apache2 libapache2-mod-php php-mysql php-xml
apt install -y composer
MD5_DEST=$(md5sum /etc/apache2/sites-available/000-default.conf | awk '{print $1}')
MD5_SRC=$(md5sum 000-default.conf | awk '{print $1}')

if [ "$MD5_DEST" != "$MD5_SRC" ]
then
	        echo "on ecrase la conf apache"
		 cp 000-default.conf /etc/apache2/sites-avaibles/000-default.conf
		  service apache2 restart
		          fi

echo 'pull sources git'
cd /var/www/html

composer install
chown -R www-data:www-data /var/www/html/
source .env.dev

git pull origin master
