FROM php:8.3-fpm

# Install system dependencies before Node.js & Composer for better caching
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential zlib1g-dev default-mysql-client curl gnupg procps git unzip \
    libzip-dev libpq-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    docker-php-ext-install zip pdo_mysql pdo_pgsql pgsql intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    pecl install redis pcov && docker-php-ext-enable redis pcov && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js, NPM in a single step
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g npm@latest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer directly with Curl (removes unnecessary temp files)
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
