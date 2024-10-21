FROM php:8.3-fpm
ARG user
ARG uid
RUN apt update && apt install -y \
    build-essential \
    locales \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip



# Clear cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

#RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
#RUN docker-php-ext-configure gd --with-external-gd
#RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer.lock and composer.json
COPY composer.json /var/www/html
COPY composer.json /var/www
#RUN composer update --no-scirpts
RUN composer install --no-scripts
#RUN npm install
#RUN composer dump-autoload

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user
WORKDIR /var/www

COPY --chown=www:www . /var/www
USER $user
