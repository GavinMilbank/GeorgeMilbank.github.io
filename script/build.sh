#!/bin/sh

rm -r public/*
hugo --debug  --themesDir themes -t hugo-xmin
