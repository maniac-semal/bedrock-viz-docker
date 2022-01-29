#!/bin/bash

cp -R /appdata/out/* /usr/share/nginx/html

/etc/init.d/nginx start

/opt/scripts/cron.sh

tail -f /dev/null