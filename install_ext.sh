#! /bin/sh

# php -r "phpinfo();" | grep -A 5 bz2
set -e
set -u
# UPDATE
apt update

# # ZIP
# apt install zlib1g-dev

# BCMATH
docker-php-ext-install bcmath

#BZ2
apt-get install -y libbz2-dev
pecl install bz2
echo "extension=bz2.so" > /etc/php/conf.d/ext-bz2.ini

# CALENDAR
docker-php-ext-install calendar

# CURL
apt-get install -y libcurl4-openssl-dev
docker-php-ext-install curl


# EXIF
docker-php-ext-install exif

#FTP
docker-php-ext-install ftp

# GD
apt-get install -y libpng-dev
docker-php-ext-install gd

# GETTEXT
docker-php-ext-install gettext

# ICONV
docker-php-ext-install iconv

# IMAP
apt-get install -y libc-client-dev libkrb5-dev
docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
&& docker-php-ext-install imap

# MCRYPT
apt install -y libmcrypt-dev
docker-php-ext-install mcrypt

# mysql
apt-get install -y libmysqlclient-dev
docker-php-ext-install mysql
# openssl
cp /usr/src/php/ext/openssl/config0.m4 /usr/src/php/ext/openssl/config.m4
docker-php-ext-install openssl

# pdo_mysql
docker-php-ext-install pdo_mysql

# shmop
docker-php-ext-install shmop

# sockets
docker-php-ext-install sockets

# ssh2
apt-get install -y libssh2-1-dev
yes '' | pecl install ssh2-0.13
echo "extension=ssh2.so" > /etc/php/conf.d/ssh2.ini

# sysvmsg
docker-php-ext-install sysvmsg

# tidy
apt-get install -y libtidy-dev
docker-php-ext-install tidy

# WDDX
docker-php-ext-install wddx

# XLS
apt-get install -y libxslt-dev
docker-php-ext-install xsl

# ZIP
docker-php-ext-install zip

#ZLIB
cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4
docker-php-ext-install zlib

#MB_String
docker-php-ext-install mbstring

# MIME_MAGIC
docker-php-ext-install mime_magic
