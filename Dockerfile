FROM ubuntu:22.04

# Require timezone build argument, but keep it configurable.
ARG TIMEZONE=Europe/Vienna

# Define apt to not ask questions
ENV DEBIAN_FRONTEND=noninteractive

# install PHP & mysql
RUN set -xe; \
    apt-get update -qq -y --fix-missing; \
    # install PHP and its modules
    apt-get install -qq -y --no-install-recommends \
        vim \
        nano \
        # Install just the CLI version.
        php-cli \
        php-mbstring \
        # --- PHP modules BEGIN ---
        php-bcmath \
        php-curl \
        php-gd \
        php-imagick \
        php-intl \
        php-mysql \
        php-opcache \
        php-readline \
        php-soap \
        php-xdebug \
        php-yaml \
        php-zip \
        php-xml \
        # --- PHP modules END ---
        mysql-server; \
    # stop the mysql service after installation
    service mysql stop;

# Allow to run composer as root
ENV COMPOSER_ALLOW_SUPERUSER="1"

# copy composer binary
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# install composer
RUN set -xe; \
    # Install git & unzip
    apt-get install -qq -y --no-install-recommends git unzip;

# Prepare working directory
RUN set -xe; \
    mkdir -p /app; \
    chmod g+w,o+w /app;

# Set the working directory inside the container
WORKDIR /app

# Copy the cake2 app template code to the working directory
COPY . .

# remove superfluous files & install composer dependencies
RUN set -xe; \
    rm -Rf .editorconfig .github .gitignore CHANGELOG.md Dockerfile README.md; \
    composer install --no-interaction

# run before and after command scripts
ENTRYPOINT ["/app/entrypoint.sh"]

# default command: start a shell
CMD ["/bin/bash", "-l"]
