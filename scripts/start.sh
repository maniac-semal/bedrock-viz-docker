#!/bin/bash

function echo_dockerlog() {
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] $@" > /proc/1/fd/1
}

function exec_dockerlog() {
        "$@"  | sed -e "s/^/[$(date '+%Y-%m-%d %H:%M:%S')]/" > /proc/1/fd/1
}

mkdir -p /appdata
mkdir -p /appdata/out
mkdir -p /appdata/world
mkdir -p /appdata/data
mkdir -p /input

echo_dockerlog "----------------------------------------------" 
echo_dockerlog "Copying config files to appdata if not present"
cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.cfg /appdata/data/bedrock_viz.cfg
cp -n /usr/local/share/bedrock-viz/data/bedrock_viz.xml /appdata/data/bedrock_viz.xml
echo_dockerlog "----------------------------------------------"

echo_dockerlog "----------------------------------------------"
echo_dockerlog "Setting up nginx and cron services"
# Implement settings for cron and nginx
crontab -u $(whoami) -r
line="*/"$TIMEFRAME" * * * * /opt/scripts/cron.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
cp /opt/scripts/bedrock_viz.conf /etc/nginx/conf.d/
echo_dockerlog "----------------------------------------------"

cp -R /appdata/out/* /usr/share/nginx/html

echo_dockerlog "----------------------------------------------"
echo_dockerlog "Starting nginx and cron services"
exec_dockerlog etc/init.d/nginx start
exec_dockerlog /etc/init.d/cron start
echo_dockerlog "----------------------------------------------"

/opt/scripts/cron.sh

tail -f /dev/null