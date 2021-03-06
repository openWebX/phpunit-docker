FROM ubuntu:19.10

MAINTAINER jens@reinemuth.rocks

ENV TZ=UTC

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing
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

RUN apt install software-properties-common    
RUN add-apt-repository ppa:ondrej/php
RUN apt update 
# PHP
RUN LC_ALL=en_US.UTF-8 && apt-get install -y php7.4 
RUN apt-get install -y \
    php7.4-curl \
    php7.4-dev \
    php7.4-xml \  
    php7.4-bcmath \ 
    php7.4-mysql \     
    php7.4-mbstring \  
    php7.4-zip \       
    php7.4-bz2 \        
    php7.4-sqlite \         
    php7.4-json \         
    php7.4-intl \        
    php7.4-imap \     
    php7.4-yaml \    
    php7.4-xdebug \   
    php7.4-soap \     
    php7.4-redis \  
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
CMD service redis start 
