ARG PHP_VERSION
ARG VARIANT
FROM thecodingmachine/php:${PHP_VERSION}-v2-${VARIANT}-node10
LABEL authors="Alex Verbruggen <verbruggenalex@gmail.com>"

USER root

# Install packages for use and setup of Cloud9 IDE as root.
RUN buildDeps='make build-essential g++ gcc python2.7' && softDeps="locales mysql-client tmux" \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y $buildDeps $softDeps --no-install-recommends \
&& locale-gen en_US.UTF-8 \
&& localedef -f UTF-8 -i en_US en_US.UTF-8 \

# Install PECL uploadprogress library for Drupal as root.
&& git clone https://github.com/php/pecl-php-uploadprogress/ /usr/src/php/ext/uploadprogress/ \
&& docker-php-ext-configure uploadprogress \
&& docker-php-ext-install uploadprogress \
&& rm -rf /usr/src/php/ext/uploadprogress

USER docker

# Install Cloud9 as docker.
RUN git clone --depth 1 https://github.com/c9/core.git /home/docker/cloud9 \
&& NO_PULL=1 /home/docker/cloud9/scripts/install-sdk.sh

USER root

# Cleanup after install as root.
RUN apt-get purge -y --auto-remove $buildDeps \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& apt-get clean -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& npm cache clean --force

USER docker

# Remove symfony autocomplete. Can't get it to work on Cloud9.
RUN sed -i '/symfony-autocomplete/d' ~/.bash_profile

# Start Cloud9 in /var/www/html as docker.
EXPOSE 8181
WORKDIR /var/www/html
ENV STARTUP_COMMAND_CLOUD9="/usr/bin/node /home/docker/cloud9/server.js -l 0.0.0.0 -p 8181 -w /var/www/html -a : &"
