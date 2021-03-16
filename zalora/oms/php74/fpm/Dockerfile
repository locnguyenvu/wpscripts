FROM php:7.4.7-fpm

# Version constants
ENV MEMCACHE_VERSION    memcache-3.0.8
ENV MEMCACHED_VERSION   memcached-3.0.3
ENV XDEBUG_VERSION      xdebug-2.9.0
ENV AMQP_VERSION        amqp-1.10.2
ENV JAVA_VERSION        jdk-12.0.2

# Version constants

ENV GRAPHVIZ_VERSION    graphviz-2.38.0

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        librabbitmq-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmemcached-dev \
        wget \
        vim \
        nano \
        unzip \
        libzip-dev \
        git \
        python-pip \
        gnupg2 \
        procps \
        graphviz \
        telnet \
        libxml2-dev

# Install JDK directly via tar archive file, dues to Java Oracle changes permission download jdk
# Make sure you've download the JDK12 setup .tar file from Oracle site, then add it into extensions directory
ADD extensions/jdk* /usr/lib/jvm/jdk-12.0.2
ENV JAVA_HOME /usr/lib/jvm/jdk-12.0.2
# RUN mkdir /usr/lib/jvm/jdk-12.0.2/bin/java
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-12.0.2/bin/java" 1 \
    && update-alternatives --config java

# Configure Extensions
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && docker-php-ext-install gd

# Download extensions from pecl

#RUN git clone -b php7 https://github.com/websupport-sk/pecl-memcache.git /usr/src/php/ext/pecl-memcache
#Install Memcache for php 7.4
RUN git clone -b NON_BLOCKING_IO_php7 https://github.com/websupport-sk/pecl-memcache.git /usr/src/php/ext/pecl-memcache \
    && echo 'pecl-memcache' >> /usr/src/php-available-exts \
    && docker-php-ext-install pecl-memcache

# Install Memcached for php 7.4 [Status: OK]
RUN apt-get install -y libmemcached-dev && curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && echo 'memcached' >> /usr/src/php-available-exts \
    && docker-php-ext-configure memcached --enable-memcached-json \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

RUN curl -L https://xdebug.org/files/xdebug-2.9.0.tgz >> /tmp/xdebug.tgz && \
    mkdir -p /usr/src/php/ext/xdebug/ && \
    tar -xf /tmp/xdebug.tgz -C /usr/src/php/ext/xdebug/ --strip 1 && \
    echo 'xdebug' >> /usr/src/php-available-exts && \
    docker-php-ext-install xdebug && \
    rm /tmp/xdebug.tgz

RUN curl -L "http://pecl.php.net/get/$AMQP_VERSION.tgz" >> /tmp/amqp.tgz && \
    mkdir -p /usr/src/php/ext/amqp/ && \
    tar -xf /tmp/amqp.tgz -C /usr/src/php/ext/amqp/ --strip 1 && \
    echo 'amqp'   >> /usr/src/php-available-exts && \
    docker-php-ext-install amqp && \
    rm /tmp/amqp.tgz

# Install PHP Extensions
RUN echo gd                 >> /usr/src/php-available-exts

# Enable PHP Extensions
RUN docker-php-ext-install \
    bcmath \
    pdo_mysql \
    pcntl \
    zip \
    opcache \
    soap

# Blackfire profiling [Status: OK]
RUN wget -O - https://packagecloud.io/blackfire-io/stable/gpgkey | apt-key add -  && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    apt-get update && \
    apt-get install -y blackfire-agent blackfire-php

# Install YAML [Status: OK]
RUN apt-get install -y libyaml-dev && \
    pecl install yaml && \
    touch /usr/local/etc/php/conf.d/ext-yaml.ini && \
    echo "extension=yaml.so" > /usr/local/etc/php/conf.d/ext-yaml.ini

# Install phpunit
RUN curl -L https://phar.phpunit.de/phpunit-5.7.phar > /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# Uopz@6.0.1 for PHP@7.4
#RUN pecl channel-update pecl.php.net && pecl install -o -f uopz-6.1.0
#RUN touch /usr/local/etc/php/conf.d/ext-uopz.ini

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Configure xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_log=/var/www/oms/oms/data/logs/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 


# Configuration management
COPY config/php7/php-fpm.conf               /usr/local/etc/php-fpm.conf
COPY config/php7/www.conf                   /usr/local/etc/php-fpm.d/www.conf
COPY config/php7/zz-docker.conf             /usr/local/etc/php-fpm.d/zz-docker.conf
COPY blackfire/blackfire-agent.ini          /etc/blackfire/agent
COPY blackfire/blackfire-cli.ini            /root/.blackfire.ini
COPY blackfire/blackfire-php.ini            $PHP_INI_DIR/conf.d/zz-blackfire.ini

# Share socket to nginx
VOLUME ["/var/run"]
WORKDIR /var/www/oms
CMD ["php-fpm"]
