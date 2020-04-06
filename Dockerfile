FROM php:7.4-cli

# Update & instal software
RUN apt-get update > /dev/null 2>&1 && \
    apt-get upgrade -y > /dev/null 2>&1 && \
    apt-get install -y zip unzip gnupg apt-transport-https lsb-release cron git > /dev/null 2>&1

# Copy composer files
COPY composer.json /app/
COPY composer.lock /app/

WORKDIR /app

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer \
    --install-dir=/usr/bin && \
    chmod +x /usr/bin/composer

# Install prestissimo
RUN composer global require hirak/prestissimo

# Install composer dependecies
RUN composer install --no-interaction --no-progress --prefer-dist --no-dev --no-autoloader --ansi --no-scripts

# Copy sources
COPY ./src /app/src
COPY bootstrap.php /app/
COPY run.php /app/

# Finish composer
RUN composer dump-autoload --no-scripts --no-dev --optimize --quiet

EXPOSE 8080

CMD [ "php", "./run.php" ]
