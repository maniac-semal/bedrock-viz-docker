#!/bin/bash

mkdir -p /appdata
mkdir -p /appdata/out
mkdir -p /appdata/world
mkdir -p /appdata/data
mkdir -p /input

cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.cfg /appdata/data/bedrock_viz.cfg
cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.xml /appdata/data/bedrock_viz.xml

# Implement settings for cron and nginx
crontab -u $(whoami) -r
line="*/"$TIMEFRAME" * * * * /opt/scripts/cron.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
cp /opt/scripts/bedrock_viz.conf /etc/nginx/conf.d/

cp -R /appdata/out/* /usr/share/nginx/html

/etc/init.d/nginx start
/etc/init.d/cron start

/opt/scripts/cron.sh

tail -f /dev/null