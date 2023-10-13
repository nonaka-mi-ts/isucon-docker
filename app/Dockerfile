FROM amazonlinux

# Arguments
ARG APP_ENV
ARG GITHUB_TOKEN
ARG DEPLOY_DIR=/var/www/isucon

# Set environments
ENV APP_ENV="${APP_ENV:-local}"
ENV DEPLOY_DIR="${DEPLOY_DIR}"

# Set running environments
WORKDIR ${DEPLOY_DIR}

# Install dependencies of Laravel
# libxml2 (xml) libzip (zip) pcre (PHPで使用する正規表現) onigurum (Rubyで使用する正規表現)
RUN apk --no-cache add libxml2-dev libzip-dev pcre-dev oniguruma-dev
# PHPの拡張機能のインストールと有効化 (https://pecl.php.net/package-search.php)
RUN docker-php-ext-install pdo_mysql zip mbstring xml pcntl opcache

# Configure middlewares
RUN sed -i -e "s/pm.max_children = 5/pm.max_children = 48/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -e "s/pm.start_servers = 2/pm.start_servers = 10/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 8/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 16/g" /usr/local/etc/php-fpm.d/www.conf

RUN echo "php_admin_value[memory_limit] = 16M" >> /usr/local/etc/php-fpm.d/www.conf

RUN echo "access.format = \"%R - %t \\\"%m %r%{PATH_INFO}e%Q%q\\\" %s %{miliseconds}d\"" >> /usr/local/etc/php-fpm.d/www.conf

RUN sed -i -e "s/;log_limit = 4096/log_limit = 8192/g" /usr/local/etc/php-fpm.conf

# Deploy application
COPY ./src ${DEPLOY_DIR}/

# composer install && remove
RUN php composer.phar install --no-dev --optimize-autoloader

# Override command for initialization in running environment
COPY ./bootstrap.sh /root/
RUN chmod +x /root/bootstrap.sh

CMD ["/root/bootstrap.sh"]
