ARG VARIANT=8.6-apache-trixie
FROM php:${VARIANT}

# Install xdebug
RUN if [ "$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')" = "8.6" ]; then \
        apt-get update \
        && apt-get install -y --no-install-recommends libtool \
        && mkdir -p /tmp/xdebug \
        && curl -fsSL https://github.com/xdebug/xdebug/archive/refs/tags/3.6.0alpha1.tar.gz | tar -xz --strip-components=1 -C /tmp/xdebug \
        && cd /tmp/xdebug \
        && phpize \
        && ./configure \
        && make -j"$(nproc)" \
        && make install \
        && rm -rf /tmp/xdebug \
        && cd / \
        && apt-get purge -y --auto-remove libtool \
        && rm -rf /var/lib/apt/lists/*; \
    else \
        yes | pecl install xdebug; \
    fi \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && rm -rf /tmp/pear

# Install composer
RUN curl -sSL https://getcomposer.org/installer | php \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer
# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
