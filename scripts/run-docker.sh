#!/bin/sh

set -e # Any command which returns non-zero exit code will cause this shell script to exit immediately
set -x # Activate debugging to show execution details: all commands will be printed before execution

docker build \
    -f dev.Dockerfile \
    -t credo_jenkins:local .

docker run \
    -v $(pwd):/app \
    --name credo_jenkins \
    -it --rm credo_jenkins:local
