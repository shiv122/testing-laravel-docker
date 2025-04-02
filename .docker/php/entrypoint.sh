#!/bin/sh
set -e

# Ensure Composer dependencies are installed
composer install --no-dev --optimize-autoloader

if ! grep -q "APP_KEY=" /var/www/.env || [ -z "$(grep 'APP_KEY=' /var/www/.env | cut -d '=' -f2)" ]; then
    php artisan key:generate
    echo "app key generated"
fi

# Set permissions for Laravel directories
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Permissions for PHPMyAdmin
mkdir -p /sessions
chmod 777 /sessions

exec "$@"
