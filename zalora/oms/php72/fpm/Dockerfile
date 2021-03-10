# Latest testing on 2nd of June, 2019 [Status: OK]

FROM php:7.2.24-fpm

# Version constants
ENV MEMCACHE_VERSION    memcache-3.0.8
ENV MEMCACHED_VERSION   memcached-3.0.3
ENV AMQP_VERSION        amqp-1.7.0
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
        cron \
        vim \
        nano \
        unzip \
        git \
        python-pip \
        gnupg2 \
        procps \
        graphviz \
        libxml2-dev

# Install JDK directly via tar archive file, dues to Java Oracle changes permission download jdk
# Make sure you've download the JDK12 setup .tar file from Oracle site, then add it into extensions directory
ADD extensions/jdk* /usr/lib/jvm/jdk-12.0.2
ENV JAVA_VERSION    jdk-12.0.2
ENV JAVA_HOME /usr/lib/jvm/jdk-12.0.2
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-12.0.2/bin/java" 1 \
    && update-alternatives --config java

RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/

#Install Memcache for php 7
RUN git clone -b php7 https://github.com/websupport-sk/pecl-memcache.git /usr/src/php/ext/pecl-memcache \
    && echo 'pecl-memcache' >> /usr/src/php-available-exts \
    && docker-php-ext-configure pecl-memcache --enable-pecl-memcache-json \
    && docker-php-ext-install pecl-memcache

# Install Memcached for php 7
RUN apt-get install -y libmemcached-dev && curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && echo 'memcached' >> /usr/src/php-available-exts \
    && docker-php-ext-configure memcached --enable-memcached-json \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

#INSTALL XDEBUG PHP
RUN curl -L https://xdebug.org/files/xdebug-2.6.0.tgz >> /tmp/xdebug.tgz && \
mkdir -p /usr/src/php/ext/xdebug/ && \
tar -xf /tmp/xdebug.tgz -C /usr/src/php/ext/xdebug/ --strip 1 && \
echo 'xdebug' >> /usr/src/php-available-exts && \
docker-php-ext-install xdebug && \
rm /tmp/xdebug.tgz

# Install AMQP
RUN curl -L "http://pecl.php.net/get/$AMQP_VERSION.tgz" >> /usr/src/php/ext/amqp.tgz && \
    tar -xf /usr/src/php/ext/amqp.tgz -C /usr/src/php/ext/ && \
    rm /usr/src/php/ext/amqp.tgz

# Configure php extensions
RUN echo gd             >> /usr/src/php-available-exts
RUN echo $AMQP_VERSION  >> /usr/src/php-available-exts

# Install php extensions [Status: OK]
RUN docker-php-ext-install \
    bcmath \
    pdo_mysql \
    pcntl \
    $AMQP_VERSION \
    gd \
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

#REMOVE OLD PHP
RUN rm -f /usr/bin/php

#REMOVE unused data
RUN apt-get remove -y \
    libtool \
    pkg-config \
    automake

RUN apt-get clean autoclean && \
	apt-get autoremove -y && \
  	rm -rf /var/lib/{apt,dpkg,cache,log}/

# Replace php-fpm config files
COPY config/php-fpm.conf /usr/local/etc/php-fpm.conf

VOLUME ["/phpinfo"]

# Copy configuration files
COPY config/php7/php-fpm.conf               /usr/local/etc/php-fpm.conf
COPY config/php7/www.conf                   /usr/local/etc/php-fpm.d/www.conf
COPY config/php7/zz-docker.conf             /usr/local/etc/php-fpm.d/zz-docker.conf
COPY blackfire/blackfire-agent.ini          /etc/blackfire/agent
COPY blackfire/blackfire-cli.ini            /root/.blackfire.ini
COPY blackfire/blackfire-php.ini            $PHP_INI_DIR/conf.d/zz-blackfire.ini

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Share socket to nginx
VOLUME ["/var/run", "/var/www/oms"]
# Working dir
WORKDIR /var/www/oms
CMD ["php-fpm"]