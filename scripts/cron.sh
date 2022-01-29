#!/bin/bash


cp -R /input/* /appdata/world

/usr/local/bin/bedrock-viz --db /appdata/world --out /appdata/out --html-all

cp -R /appdata/out/* /usr/share/nginx/html