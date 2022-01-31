#!/bin/bash


echo "----------------------------------------------"
echo "Copying current world to working folder"
# Copy current world to working folder
cp -R /input/* /appdata/world
echo "----------------------------------------------"

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
    echo "----------------------------------------------"
    echo "Max Logfile filesize reached, emptied"
    echo "----------------------------------------------"
fi

echo "----------------------------------------------"
echo "Starting new generation of Map"
/usr/local/bin/bedrock-viz --cfg /appdata/data/bedrock_viz.cfg --xml /appdata/data/bedrock_viz.xml --db /appdata/world --out /appdata/out --html-all --quiet

cp -R /appdata/out/* /usr/share/nginx/html
echo "New map generated and updated in WebUi"
echo "----------------------------------------------"