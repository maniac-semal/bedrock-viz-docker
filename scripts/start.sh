#!/bin/bash

mkdir -p /appdata
mkdir -p /appdata/out
mkdir -p /appdata/world
mkdir -p /input

cp -R /appdata/out/* /usr/share/nginx/html

/etc/init.d/nginx start
/etc/init.d/cron start

/opt/scripts/cron.sh

tail -f /dev/null