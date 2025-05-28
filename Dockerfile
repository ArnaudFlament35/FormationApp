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

# Installe le CLI Symfony dans le conteneur
# Télécharge le binaire
RUN curl -sS https://get.symfony.com/cli/installer | bash

# Déplace le binaire dans un répertoire du PATH pour le rendre globalement disponible
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony