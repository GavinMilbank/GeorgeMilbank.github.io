#!/bin/sh

CONTAINER_HOME=/home/rstudio
docker run -it \
    -v "$(pwd):${CONTAINER_HOME}" \
    -e DISABLE_AUTH=true -p 8787 \
    rocker/verse:latest
