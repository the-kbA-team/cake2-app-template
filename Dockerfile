FROM ubuntu:22.04

# install PHP & mysql
RUN set -xe; \
    apt-get update -qq -y --fix-missing; \
    # install PHP and its modules
    apt-get install -qq -y --no-install-recommends \
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
        # --- PHP modules END ---
        mysql-server;

# Allow to run composer as root
ENV COMPOSER_ALLOW_SUPERUSER="1"

# Download the composer installer.
ADD "https://getcomposer.org/installer" "/usr/local/bin/composer-setup.php"
ADD "https://composer.github.io/installer.sig" "/usr/local/bin/composer-setup.sig"

# install composer
RUN set -xe; \
    # validate the installer SHA384 checksum
    EXPECTED_CHECKSUM="$(cat '/usr/local/bin/composer-setup.sig')"; \
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', '/usr/local/bin/composer-setup.php');")"; \
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then (>&2 echo 'ERROR: Invalid installer checksum'); exit 1; fi; \
    # Install composer.
    php /usr/local/bin/composer-setup.php --${COMPOSER_VERSION} --no-ansi --install-dir=/usr/local/bin --filename=composer; \
    chmod 755 /usr/local/bin/composer; \
    # remove installer files
    rm -f "/usr/local/bin/composer-setup.php"; \
    rm -f "/usr/local/bin/composer-setup.sig"; \
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
