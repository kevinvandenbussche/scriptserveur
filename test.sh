#!/bin/bash
MD5_DEST=$(md5sum /etc/apache2/sites-available/000-default.conf | awk '{print $1}')
MD5_SRC=$(md5sum 000-default.conf | awk '{print $1}')

if [ "$MD5_DEST" != "$MD5_SRC" ]
then
	echo "on ecrase la conf apache"
 cp 000-default.conf /etc/apache2/sites-avaibles/000-default.conf
 service apache2 restart
	fi

