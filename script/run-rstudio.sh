#!/bin/bash

PWD=$(pwd)
echo PWD=${PWD}

docker run -it \
-e DISABLE_AUTH=true \
-p 8787 \
-v $(pwd):/home/rstudio \
-v /Users/gavinmilbank/.ssh:/root/.ssh \
-v /Users/gavinmilbank/.ssh:/home/rstudio/.ssh \
portela-tech-rstudio-dev:latest

