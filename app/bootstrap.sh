#!/bin/sh

php artisan config:cache
php artisan route:cache

php-fpm
