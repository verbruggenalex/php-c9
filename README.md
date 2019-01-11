[![Build Status](https://travis-ci.org/verbruggenalex/php-c9.svg?branch=master)](https://travis-ci.org/verbruggenalex/php-c9)
# TheCodingMachine based fat PHP/Cloud9 Docker images

These images are based on the fat node10 images from TheCodingMachine. For
documentation on usage please read TheCodingMachine's [README.md](https://github.com/thecodingmachine/docker-images-php/blob/v2/README.md#general-purpose-php-images-for-docker)

## Images

| Name                                                                    | PHP version                  |Variant | NodeJS version  | Size 
|-------------------------------------------------------------------------|------------------------------|--------|-----------------|------
| [verbral/php-c9:7.3-apache](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.apache)   | `7.3.x` | apache  | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-apache.svg)](https://microbadger.com/images/verbral/php-c9:7.3-apache)
| [verbral/php-c9:7.3-cli](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.cli)         | `7.3.x` | cli     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-cli.svg)](https://microbadger.com/images/verbral/php-c9:7.3-cli)
| [verbral/php-c9:7.3-fpm](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.fpm)         | `7.3.x` | fpm     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-fpm.svg)](https://microbadger.com/images/verbral/php-c9:7.3-fpm)
| [verbral/php-c9:7.2-apache](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.apache)   | `7.2.x` | apache  | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-apache.svg)](https://microbadger.com/images/verbral/php-c9:7.3-apache)
| [verbral/php-c9:7.2-cli](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.cli)         | `7.2.x` | cli     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-cli.svg)](https://microbadger.com/images/verbral/php-c9:7.3-cli)
| [verbral/php-c9:7.2-fpm](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.fpm)         | `7.2.x` | fpm     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-fpm.svg)](https://microbadger.com/images/verbral/php-c9:7.3-fpm)
| [verbral/php-c9:7.1-apache](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.apache)   | `7.1.x` | apache  | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-apache.svg)](https://microbadger.com/images/verbral/php-c9:7.3-apache)
| [verbral/php-c9:7.1-cli](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.cli)         | `7.1.x` | cli     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-cli.svg)](https://microbadger.com/images/verbral/php-c9:7.3-cli)
| [verbral/php-c9:7.1-fpm](https://github.com/verbruggenalex/php-c9/blob/master/Dockerfile.fpm)         | `7.1.x` | fpm     | `10.x`| [![](https://images.microbadger.com/badges/image/verbral/php-c9:7.3-fpm.svg)](https://microbadger.com/images/verbral/php-c9:7.3-fpm)

## Docker-compose example

```yaml
version: '3'
services:
  web:
    image: verbral/php-c9:7.2-apache
    environment:
      APACHE_DOCUMENT_ROOT: web/
      PHP_INI_MEMORY_LIMIT: 1g
      PHP_INI_ERROR_REPORTING: E_ALL
      PHP_EXTENSION_XDEBUG: 1
      PHP_EXTENSION_GD: 1
      STARTUP_COMMAND_1: composer install
    working_dir: /var/www/html
    volumes:
      - ${PWD}:/var/www/html
      - ~/.ssh:/home/docker/.ssh
    ports:
      - 80:80
      - 8181:8181
  mysql:
    image: percona/percona-server:5.7
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
      - MYSQL_DATABASE=drupal
```