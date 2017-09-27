FROM debian:8

ENV VERSION_APACHE 2.2.10
ENV VERSION_PHP 5.2.16

ENV PHP_INI_DIR /etc/php

RUN mkdir -p $PHP_INI_DIR/conf.d

RUN apt-get update
RUN apt-get install -y  dos2unix vim curl patch make wget gcc perl libxml2-dev autoconf \
                        bzip2 \
                        libcurl4-openssl-dev \
                        libjpeg-dev \
                        libmysqlclient-dev \
                        libpng12-dev \
                        libreadline6-dev \
                        libssl-dev \
                        pkg-config

RUN ln -s /usr/lib/x86_64-linux-gnu/libjpeg.a /usr/lib/libjpeg.a \
    && ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libpng.a /usr/lib/libpng.a \
    && ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.a /usr/lib/libmysqlclient.a


RUN cd /usr/src && \
    wget https://archive.apache.org/dist/httpd/httpd-$VERSION_APACHE.tar.gz && \
    tar -zxvf httpd-$VERSION_APACHE.tar.gz && \
    rm httpd-$VERSION_APACHE.tar.gz && \
    cd httpd-$VERSION_APACHE && \
    ./configure --enable-mods-shared="all" --enable-so --enable-rewrite --enable-headers  \
    --enable-log_config --enable-logio --enable-prefork --enable-http_core \
    --enable-so --enable-actions --enable-alias --enable-autoindex --enable-cache \
    --enable-cgi --enable-deflate --enable-dir --enable-env --enable-expires \
    --enable-geoip --enable-mime --enable-negotiation \
    --enable-setenvif  --enable-status --enable-authz_host && \
    make && make install

RUN cd /usr/src && \
    wget http://museum.php.net/php5/php-$VERSION_PHP.tar.gz && \
    tar -zxvf php-$VERSION_PHP.tar.gz && \
    rm php-$VERSION_PHP.tar.gz && \
    mv php-$VERSION_PHP php && \
    cd php && \
    curl -s https://mail.gnome.org/archives/xml/2012-August/txtbgxGXAvz4N.txt | patch -p0 && \
    ./configure  --with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		--with-fpm-conf="$PHP_INI_DIR/php-fpm.conf" \
    --with-apxs2=/usr/local/apache2/bin/apxs \
    --without-iconv && \
    make && make install

RUN mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20060613/
# Setup timezone to Etc/UTC and fix extension path
RUN cat /usr/src/php/php.ini-recommended | sed 's/^;\(date.timezone.*\)/\1 \"Etc\/UTC\"/' > $PHP_INI_DIR/php.ini \
	&& sed -i 's/\(extension_dir = \)\"\.\/\"/\1\"\/usr\/local\/lib\/php\/extensions\/no-debug-non-zts-20060613\/\"/' $PHP_INI_DIR/php.ini

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

COPY php.ini /etc/php/php.ini

RUN rm /usr/local/apache2/htdocs/*

COPY docker-php-ext-* /usr/local/bin/

RUN ln -s /usr/local/apache2/bin/apachectl /usr/local/bin/

COPY run.sh /bin/run.sh

COPY install_ext.sh /bin/install_ext.sh

RUN dos2unix /usr/local/bin/docker-php-ext-install /usr/local/bin/docker-php-ext-install

RUN dos2unix /usr/local/bin/docker-php-ext-configure /usr/local/bin/docker-php-ext-configure

RUN dos2unix /bin/run.sh /bin/run.sh

RUN dos2unix /bin/install_ext.sh /bin/install_ext.sh

WORKDIR /usr/local/apache2/htdocs

RUN install_ext.sh

CMD ["/bin/run.sh"]
