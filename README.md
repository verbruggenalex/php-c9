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

This docker-compose.yml example contains the correct environment variables to
use the dummy Cloud9 Runner shown below. This allows you to debug PHP code out
of the box using this docker image.

```yaml
version: '3'
services:
  web:
    image: verbral/php-c9:7.2-apache
    working_dir: /var/www/html
    volumes:
      - ${PWD}:/var/www/html
    ports:
      - 80:80
      - 8181:8181
```

## Dummy Cloud9 runner for xDebug

This dummy runner for xDebug simulates a runner to get Cloud9 to listen for
debug signals. To make use of this runner you are required to pass the xdebug
variables shown in the docker-compose.yml example above.

```json
// This file contains a dummy runner to switch on xdebug.
{
  "script": [
    "while true; do sleep 10;done"
  ],
  "selector": "^.*\\.(php|phar)$",
  "info": "Running PHP script $file",
  "working_dir": "$project_path",
  "debugger": "xdebug",
  "debugport": 9000,
  "env": {}
}
```

## Testing this image.

```
git clone https://github.com/verbruggenalex/php-c9.git
cd php-c9
docker-compose up -d
```

- Visit your container at port 8181 (Cloud9).
- In Cloud 9 open up index.php and put a debug breakpoint next to line 3.
- Press Run > Run With > PHP (xdebug)
- Visit your container at port 80 (index.php).

