ARG PHP_VERSION
ARG VARIANT
FROM verbral/php:${PHP_VERSION}-v3-${VARIANT}-node10
LABEL authors="Alex Verbruggen <verbruggenalex@gmail.com>"

USER root

# Install packages for use and setup of Cloud9 IDE as root.
RUN buildDeps='make build-essential g++ gcc python2.7' && softDeps="locales mysql-client rsync tmux" \
&& apt-get update || apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y $buildDeps $softDeps --no-install-recommends \
&& locale-gen en_US.UTF-8 \
&& localedef -f UTF-8 -i en_US en_US.UTF-8 \

# Install PECL uploadprogress library for Drupal as root.
&& git clone https://github.com/php/pecl-php-uploadprogress/ /usr/src/php/ext/uploadprogress/ \
&& docker-php-ext-configure uploadprogress \
&& docker-php-ext-install uploadprogress \
&& rm -rf /usr/src/php/ext/uploadprogress

USER web

# Install Cloud9 as docker.
RUN git clone --depth 1 https://github.com/c9/core.git /home/web/cloud9 \
&& NO_PULL=1 /home/web/cloud9/scripts/install-sdk.sh

USER root

# Cleanup after install as root.
RUN apt-get purge -y --auto-remove $buildDeps \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& apt-get clean -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& npm cache clean --force

USER web

# Install docker CLI.
ENV DOCKERVERSION=18.06.1-ce
RUN sudo curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
&& sudo tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
&& sudo rm docker-${DOCKERVERSION}.tgz \
## TODO: make GID match host system.
&& sudo groupadd docker -g 999 \
&& sudo usermod -aG docker web \
# Install docker-compose.
&& sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose

# Install C9 plugins and runners.
RUN mkdir -p ~/.c9/plugins/c9-walkatime \
&& git clone https://github.com/wakatime/c9-wakatime.git ~/.c9/plugins/c9-walkatime
ADD --chown=web ./resources/c9/init.js /home/web/.c9/
ADD --chown=web ./resources/c9/user.settings /home/web/.c9/
ADD --chown=web ./resources/c9/runners /home/web/.c9/runners

# Remove symfony autocomplete. Can't get it to work on Cloud9.
RUN sed -i '/symfony-autocomplete/d' ~/.bash_profile

# Start Cloud9 in /var/www/html as docker.
EXPOSE 8181
WORKDIR /var/www/html
ENV PHP_EXTENSION_XDEBUG=1
ENV XDEBUG_CONFIG="idekey=cloud9ide remote_connect_back=0 remote_host=localhost"
## TODO: Move runner into custom plugin.
ENV STARTUP_COMMAND_CLOUD9_1='sed -i "s/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX/$WAKATIME_API_KEY/g"  /home/web/.c9/user.settings'
ENV STARTUP_COMMAND_CLOUD9_2="mkdir -p \$PWD/.c9 && cp -Rf /home/web/.c9/runners \$PWD/.c9 &"
ENV STARTUP_COMMAND_CLOUD9_3="/usr/bin/node /home/web/cloud9/server.js -l 0.0.0.0 -p 8181 -w \$PWD -a : &"
