FROM php:8.3-fpm-alpine

# Install required dependencies
RUN apk add --no-cache \
    build-base zlib-dev mariadb-client curl git unzip icu-dev \
    libzip-dev libpq-dev freetype-dev libjpeg-turbo-dev libpng-dev && \
    docker-php-ext-install zip pdo_mysql pdo_pgsql pgsql intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    pecl install redis pcov && docker-php-ext-enable redis pcov

# Install Node.js & NPM (use Alpine repository instead of external scripts)
RUN apk add --no-cache nodejs npm && \
    npm install -g npm@latest

# Install Composer directly using curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy configurations & entrypoint script
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
