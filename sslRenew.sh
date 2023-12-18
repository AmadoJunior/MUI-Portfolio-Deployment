#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

cd /home/Pi4ServerSetUp/

$COMPOSE run certbot renew --dry-run && $COMPOSE kill -s SIGNUP nginx_proxy
$DOCKER system prune -af