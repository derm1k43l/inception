#!/bin/bash

# Check if .env file exists
if [ ! -f /var/www/html/.env ]; then
    echo ".env file not found!"
    exit 1
fi

export $(cat /var/www/html/.env)

sleep 5

# Load sensitive variables from secrets
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASS=$(cat /run/secrets/db_root_pass)
ADMIN_USER=$(cat /run/secrets/wp_admin)
ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)
WP_USR=$(cat /run/secrets/wp_usr)
WP_USR_PASS=$(cat /run/secrets/wp_usr_pass)

# Wait for database to be ready
sleep 7

# Download the wp-cli.phar (WordPress Command Line Interface) file and allow to execute it
cd /var/www/html
if ! curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; then
    echo "Failed to download wp-cli.phar."
    exit 1
fi
chmod +x wp-cli.phar

# if wp-includes directory does not exist, download WordPress core files
if [ ! -d "wp-includes" ]; then
    echo "WordPress core downloading..."
    ./wp-cli.phar core download --allow-root
else
    echo "WordPress core files already exist!"
fi

# check if the database exists if not create it
if ! ./wp-cli.phar db query "SELECT 1;" --allow-root; then
    echo "Database does not exist, creating..."
    ./wp-cli.phar db create --allow-root
else
    echo "Database already exists!"
fi
# 3rd time ony, wokrs so i added sleep 5
sleep 5

# Create wp-config.php
if [ ! -f "wp-config.php" ]; then
    ./wp-cli.phar config create \
    --url=$WP_URL \
    --dbname=$DB_NAME \
    --dbuser=$DB_USER \
    --dbpass=$DB_PASS \
    --dbhost=$DB_HOST \
    --allow-root
else
    echo "wp-config.php already exists."
fi

# Install WordPress if not already installed
if ! ./wp-cli.phar core is-installed --allow-root; then
    ./wp-cli.phar core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASS" \
        --admin_email="$ADMIN_EMAIL" \
        --allow-root
else
    echo "WordPress is already installed."
fi

# Create second regular user
if ! ./wp-cli.phar user get "$WP_USR" --allow-root; then
    ./wp-cli.phar user create \
        "$WP_USR" \
        "$WP_REGULAR_EMAIL" \
        --role=author \
        --user_pass="$WP_USR_PASS" \
        --allow-root
else
    echo "User $WP_USR already exists."
fi

# Install and activate the Redis Object Cache plugin
./wp-cli.phar plugin install redis-cache --activate --allow-root
./wp-cli.phar redis enable --allow-root || echo "Could not enable Redis cache"

# Change ownership of the WordPress files to the www-data user
mkdir -p /run/php
chown -R www-data:www-data /var/www/html/*

# Clean up by removing the wp-cli.phar file
rm wp-cli.phar

# Start PHP-FPM 7.4 in the foreground
php-fpm7.4 -F