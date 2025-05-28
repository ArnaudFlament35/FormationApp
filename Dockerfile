# Dockerfile
FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

# Installe les extensions PHP nécessaires pour MariaDB
RUN apk add --no-cache \
    mysql-client \ 
    icu-dev \
    git \
    zip \
    unzip \
    # Ajoute curl et bash qui sont souvent utiles pour l'installation du CLI
    curl \
    bash \
&& docker-php-ext-install pdo_mysql intl

# Installe Composer dans le conteneur
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN curl -sSL https://github.com/symfony/cli/releases/latest/download/symfony-cli-linux-amd64 -o /usr/local/bin/symfony \
    && chmod +x /usr/local/bin/symfony
# Crée un dossier pour le cache de Composer et donne les bonnes permissions
RUN mkdir -p var/composer_cache && chmod -R 777 var/composer_cache
# Définit la variable d'environnement pour Composer
ENV COMPOSER_CACHE_DIR=/var/www/html/var/composer_cache
RUN chmod -R 777 var/
RUN mkdir -p var/symfony_home && chmod -R 777 var/symfony_home
EXPOSE 9000