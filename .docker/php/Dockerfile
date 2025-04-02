FROM php:8.3-fpm-alpine

COPY php.ini /usr/local/etc/php/
COPY docker.conf /usr/local/etc/php-fpm.d/docker.conf
COPY .bashrc /root/

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# mix
RUN apk update \
  && apk add --no-cache build-essential zlib1g-dev default-mysql-client curl gnupg procps git unzip libzip-dev libpq-dev \
  && docker-php-ext-install zip pdo_mysql pdo_pgsql pgsql

# intl
RUN apk add --no-cache libicu-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl

# gd
RUN apk add --no-cache libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
docker-php-ext-install gd

# redis
RUN pecl install redis && docker-php-ext-enable redis

# pcov
RUN pecl install pcov && docker-php-ext-enable pcov

# Xdebug
# RUN pecl install xdebug \
# && docker-php-ext-enable xdebug \
# && echo ";zend_extension=xdebug" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Node.js, NPM, Yarn
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN apk add --no-cache nodejs
RUN npm install npm@latest -g

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin
RUN composer config --global process-timeout 3600

WORKDIR /root

EXPOSE 5173
WORKDIR /var/www

#entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]