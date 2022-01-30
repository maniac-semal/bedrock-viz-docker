#!/bin/bash


cp -R /input/* /appdata/world

/usr/local/bin/bedrock-viz --cfg /appdata/data/bedrock_viz.cfg --xml /appdata/data/bedrock_viz.xml --db /appdata/world --out /appdata/out --html-all --quiet

cp -R /appdata/out/* /usr/share/nginx/html