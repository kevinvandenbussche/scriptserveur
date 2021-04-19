#!/bin/bash
echo "installation paquets update"
apt udapte
apt install -y mariadb-client mariadb-server
apt install -y php apache2 libapache2-mod-php php-mysql php-xml
apt install -y composer vim git snapd

snap install core
snap refresh core
snap install --classic certbot

CERTBOT=$(ls /usr/bin | grep certbot)
if [ -z "$CERTBOT" ]
then
	echo "on creé le lien /usr/bin/certbot"
	ln -s /snap/bin/certbot /usr/bin/certbot
fi

mkdir -p /var/www/html

cd /var/www/html

echo "telechargement de git"
GIT_CMD=$(ls -lsa /var/www/html | grep .git)
if [ -z "$GIT_CMD" ]

then
	git init 
	git remote add origin https://github.com/kevinvandenbussche/maraudeurs.git
fi


 
cd /opt/scriptserveur

APACHE_CHECK=$(ls /etc/apache2/sites-available/ | grep 000-default.conf)
if [ -z "$APACHE_CHECK" ]

then
	touch /etc/apache2/sites-available/000-default.conf
fi


MD5_DEST=$(md5sum /etc/apache2/sites-available/000-default.conf | awk '{print $1}')
MD5_SRC=$(md5sum 000-default.conf | awk '{print $1}')

if [ "$MD5_DEST" != "$MD5_SRC" ]
then 
 	echo "on ecrase la conf apache"
	cp 000-default.conf /etc/apache2/sites-available/000-default.conf
	service apache2 restart
fi

echo "pull sources git"

cd /var/www/html
git pull origin develop
composer install
chown -R www-data:www-data /var/www/html/
source .env.dev
echo "penser a mettre la certif apache"
