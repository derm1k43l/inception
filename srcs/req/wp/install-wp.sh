#!/bin/bash

# Check if .env file exists
if [ ! -f /var/www/html/.env ]; then
    echo ".env file not found!"
    exit 1
fi

# Load environment variables from .env file
export $(grep -v '^#' /var/www/html/.env | xargs)

cd /var/www/html

# Download the wp-cli.phar (WordPress Command Line Interface) file and allow to execute it
if ! curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; then
    echo "Failed to download wp-cli.phar."
    exit 1
fi
chmod +x wp-cli.phar

# if wp-includes directory does not exist, download WordPress core files
if [ ! -d "wp-includes" ]; then
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

# Create configuration file with some fields wp-config.php
if [ ! -f "wp-config.php" ]; then
    ./wp-cli.phar config create --dbname=$DB_NAME \
    --url=$WP_URL \
    --dbuser=$DB_USER \
    --dbpass=$DB_PASS \
    --dbhost=$DB_HOST \
    --allow-root
else
    echo "wp-config.php already exists. Skipping configuration."
fi

# Install WordPress if not already installed
if ! ./wp-cli.phar core is-installed --allow-root; then
    ./wp-cli.phar core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASS \
        --admin_email=$ADMIN_EMAIL \
        --allow-root
else
    echo "WordPress is already installed."
fi

# Change ownership of the WordPress files to the www-data user
mkdir -p /run/php
chown -R www-data:www-data /var/www/html/*

# Debugging: check if PHP-FPM is running
ps aux | grep php-fpm

# Clean up by removing the wp-cli.phar file
rm wp-cli.phar

# Start PHP-FPM 7.4
php-fpm7.4 -F