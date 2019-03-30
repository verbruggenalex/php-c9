ARG PHP_VERSION
ARG VARIANT
FROM verbral/php:${PHP_VERSION}-v2-${VARIANT}-node10
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

# Install C9 plugins and runners.
RUN mkdir -p ~/.c9/plugins/c9-walkatime \
&& git clone https://github.com/wakatime/c9-wakatime.git ~/.c9/plugins/c9-walkatime
ADD --chown=docker ./resources/c9/init.js /home/docker/.c9/
ADD --chown=docker ./resources/c9/user.settings /home/docker/.c9/
ADD --chown=docker ./resources/c9/runners /home/docker/.c9/runners

# Remove symfony autocomplete. Can't get it to work on Cloud9.
RUN sed -i '/symfony-autocomplete/d' ~/.bash_profile

# Install composer global packages
RUN composer global install

# Add .c9 to global .gitignore file.
ADD --chown=docker ./resources/git/.gitignore_global /home/docker/.gitignore_global
RUN git config --global core.excludesfile ~/.gitignore_global

# Start Cloud9 in /var/www/html as docker.
EXPOSE 8181
WORKDIR /var/www/html
ENV PHP_EXTENSION_XDEBUG=1
ENV XDEBUG_CONFIG="idekey=cloud9ide remote_connect_back=0 remote_host=localhost"
ENV PHP_EXTENSION_BLACKFIRE=1
ENV PHP_EXTENSION_GD=1
ENV PHP_INI_ERROR_REPORTING=E_ALL
ENV PHP_INI_MEMORY_LIMIT=2g
## TODO: Move runner into custom plugin.
ENV STARTUP_COMMAND_CLOUD9_1='sed -i "s/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX/$WAKATIME_API_KEY/g"  /home/docker/.c9/user.settings'
ENV STARTUP_COMMAND_CLOUD9_2='[ -z "$GIT_USER_NAME" ] || git config --global user.name "$GIT_USER_NAME"'
ENV STARTUP_COMMAND_CLOUD9_3='[ -z "$GIT_USER_EMAIL" ] || git config --global user.email "$GIT_USER_EMAIL"'
ENV STARTUP_COMMAND_CLOUD9_4='sed -i "s/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX/$WAKATIME_API_KEY/g"  /home/docker/.c9/user.settings'
ENV STARTUP_COMMAND_CLOUD9_5="mkdir -p \$PWD/.c9 && cp -Rf /home/docker/.c9/runners \$PWD/.c9 &"
ENV STARTUP_COMMAND_CLOUD9_6="/usr/bin/node /home/docker/cloud9/server.js -l 0.0.0.0 -p 8181 -w \$PWD -a : &"
