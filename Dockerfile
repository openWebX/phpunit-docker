FROM ubuntu:19.10

MAINTAINER jens@reinemuth.rocks

ENV TZ=UTC

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y \
    sudo \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    curl \
    rsync \
    ssh \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    nasm \
    libjpeg-dev \
    libpng-dev \
    libpng16-16 \
    nmap \
    redis-server

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# PHP
RUN LC_ALL=en_US.UTF-8 && apt-get update && apt-get install -y php7.3
RUN apt-get install -y \
    php7.3-curl \
    php7.3-dev \
    php7.3-xml \
    php7.3-bcmath \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-zip \
    php7.3-bz2 \
    php7.3-sqlite \
    php7.3-json \
    php7.3-intl \
    php7.3-imap \
    php7.3-yaml \
    php7.3-xdebug \
    php7.3-soap \
    php-memcached
RUN command -v php

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update --preview
RUN command -v composer

# Node.js
RUN sudo add-apt-repository -y -r ppa:chris-lea/node.js
RUN sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list
RUN sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
# The below command will set this correctly, but if lsb_release isn't available, you can set it manually:
# - For Debian distributions: jessie, sid, etc...
# - For Ubuntu distributions: xenial, bionic, etc...
# - For Debian or Ubuntu derived distributions your best option is to use the codename corresponding to the upstream release your distribution is based off. This is an advanced scenario and unsupported if your distribution is not listed as supported per earlier in this README.
RUN DISTRO="$(lsb_release -s -c)"
RUN echo "deb https://deb.nodesource.com/node_12.x disco main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_12.x disco main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
RUN sudo apt-get update
RUN sudo apt-get install nodejs -y
RUN npm install npm@6.9.0 -g
RUN command -v node
RUN command -v npm

# Other
RUN mkdir ~/.ssh
RUN touch ~/.ssh_config

# Display versions installed
RUN php -v
RUN composer --version
RUN node -v
RUN npm -v
