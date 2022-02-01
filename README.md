# Bedrock-Biz-docker


This is a Dockerfile to create an image of [bedrock-viz/bedrock-viz](https://github.com/bedrock-viz/bedrock-viz).

Image is extended by additional scripts for automatic regeneration of the map every 30 minutes.

It includes the installation of an nginx webserver on port 8080 to actually display the result of the generation.

This repo itself contains no code from bedrock-viz. The actual code is downloaded with the current version from github and then installed and compiled.