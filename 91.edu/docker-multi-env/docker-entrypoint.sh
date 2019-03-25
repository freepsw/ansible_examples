#!/bin/bash -e
j2 /templates/nginx.conf.j2 > /etc/nginx/conf.d/default.conf
exec "$@"
