FROM php:8.3-fpm-alpine

# Install system dependencies required for extensions
RUN apk add --no-cache \
    build-base zlib-dev mariadb-client curl git unzip icu-dev \
    libzip-dev libpq-dev freetype-dev libjpeg-turbo-dev libpng-dev \
    autoconf make g++ php8-pecl-dev

# Install PHP extensions
RUN docker-php-ext-install zip pdo_mysql pdo_pgsql pgsql intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install PECL extensions (Requires phpize dependencies)
RUN pecl install redis pcov && docker-php-ext-enable redis pcov

# Install Node.js & NPM from Alpine repositories
RUN apk add --no-cache nodejs npm && npm install -g npm@latest

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy configurations & entrypoint
COPY php.ini /usr/local/etc/php/
COPY docker.conf /usr/local/etc/php-fpm.d/docker.conf
COPY .bashrc /root/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

# Set Composer environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer \
    PATH="$PATH:/composer/vendor/bin"

WORKDIR /root

EXPOSE 5173
WORKDIR /var/www

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
