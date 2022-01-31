#!/bin/bash

mkdir -p /appdata
mkdir -p /appdata/out
mkdir -p /appdata/world
mkdir -p /appdata/data
mkdir -p /input

echo "----------------------------------------------"
echo "Copying config files to appdata if not present"
cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.cfg /appdata/data/bedrock_viz.cfg
cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.xml /appdata/data/bedrock_viz.xml
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Setting up nginx and cron services"
# Implement settings for cron and nginx
crontab -u $(whoami) -r
line="*/"$TIMEFRAME" * * * * /opt/scripts/cron.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
cp /opt/scripts/bedrock_viz.conf /etc/nginx/conf.d/
echo "----------------------------------------------"

cp -R /appdata/out/* /usr/share/nginx/html

echo "----------------------------------------------"
echo "Starting nginx and cron services"
/etc/init.d/nginx start
/etc/init.d/cron start
echo "----------------------------------------------"

/opt/scripts/cron.sh

tail -f /dev/null