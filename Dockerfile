FROM php:7.1-apache

COPY php.ini /usr/local/etc/php/conf.d/akeneo_pim.ini
COPY vhost.conf /etc/apache2/sites-available/akeneo_pim.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# PHP extensions
RUN apt-get update && \
    apt-get install -y git libicu-dev libmcrypt-dev libpng-dev libcurl3-dev libxml2-dev libjpeg-dev libpng-dev libssl-dev

RUN docker-php-ext-configure intl && \
    docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu && \
    docker-php-ext-install mbstring pdo_mysql intl mcrypt gd exif curl soap zip

# Install mongo
RUN pecl install -f mongo &&\
    echo "extension=mongo.so" > /usr/local/etc/php/conf.d/ext-mongo.ini

# Clean up
RUN apt-get autoremove -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Run Apache
RUN a2enmod rewrite && \
    a2ensite akeneo_pim && \
    a2dissite 000-default

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
