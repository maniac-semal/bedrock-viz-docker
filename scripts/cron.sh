#!/bin/bash

function echo_dockerlog() {
        echo -e "[`date '+%Y-%m-%d %H:%M:%S'`] $@" > /proc/1/fd/1
}

function exec_dockerlog() {
        "$@"  | sed -e "s/^/[$(date '+%Y-%m-%d %H:%M:%S')]/" > /proc/1/fd/1
}

echo_dockerlog "\n----------------------------------------------"
echo_dockerlog "Copying current world to working folder"
# Copy current world to working folder
cp -R /input/* /appdata/world
echo_dockerlog "----------------------------------------------"

# Check logile size

#    File to consider
LOGFILE=/appdata/out/bedrock_viz.log

#    MAXSIZE is 50 MB
MAXSIZE=5000000

#    Get file size
FILESIZE=$(stat -c%s "$LOGFILE")

# Check filesize of Logfile and empty if too big.
if (( $FILESIZE > $MAXSIZE)); then
    echo "" > $LOGFILE
    echo_dockerlog "\n----------------------------------------------"
    echo_dockerlog "Max Logfile filesize reached, emptied"
    echo_dockerlog "----------------------------------------------"
fi

echo_dockerlog "\n----------------------------------------------"
echo_dockerlog "Starting new generation of Map"

exec_dockerlog /usr/local/bin/bedrock-viz --cfg /appdata/data/bedrock_viz.cfg --xml /appdata/data/bedrock_viz.xml --db /appdata/world --out /appdata/out --html-all --quiet
cp -R /appdata/out/* /usr/share/nginx/html

echo_dockerlog "New map generated and updated in WebUI"
echo_dockerlog "----------------------------------------------"