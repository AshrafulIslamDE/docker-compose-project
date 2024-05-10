FROM php:7.4-apache

ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /var/www/html/contao

#Update package lists and install required packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
        default-mysql-client \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev 



# Install PHP extensions required by Contao
RUN set -eux; \
    docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo_mysql

RUN apt-get install -y git zip


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install unzip package
RUN apt-get update && apt-get install -y \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Copy the install script into the container
COPY install_contao.sh /usr/local/bin/install_contao.sh

# Enable Apache mod_rewrite
RUN a2enmod rewrite


# Set PHP configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Remove existing cache
RUN rm -rf /var/www/html/contao/var/cache/*


# Set execute permissions for the script
RUN chmod +x /usr/local/bin/install_contao.sh

# Run the install script and run php container
CMD ["bash", "-c", "/usr/local/bin/install_contao.sh && apache2-foreground"]


