#!/bin/sh
set -e

# Ensure Composer dependencies are installed
composer install --no-dev --optimize-autoloader

if ! grep -q "APP_KEY=" /var/www/.env || [ -z "$(grep 'APP_KEY=' /var/www/.env | cut -d '=' -f2)" ]; then
    php artisan key:generate
fi


attempts=0
max_attempts=2
while [ $attempts -lt $max_attempts ]; do
    if php artisan migrate:status > /dev/null 2>&1; then
        echo "✅ Database is ready. Running migrations..."
        php artisan migrate --force
        break
    fi
    attempts=$((attempts + 1))
    echo "⚠️ Database not ready (attempt $attempts of $max_attempts). Retrying in 5 seconds..."
    sleep 5
done

# If MySQL is still not ready, skip migration
if [ $attempts -eq $max_attempts ]; then
    echo "🚨 Skipping migrations: Database is not ready after $max_attempts attempts." | tee -a /var/www/storage/logs/error.log
fi

# Set permissions for Laravel directories
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Permissions for PHPMyAdmin
mkdir -p /sessions
chmod 777 /sessions

exec "$@"
