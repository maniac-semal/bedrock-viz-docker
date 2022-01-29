#!/bin/bash


cp -R /input/* /world

/usr/local/bin/bedrock-viz --db /world --out /out --html-all