#!/bin/bash

set -e # Any command which returns non-zero exit code will cause this shell script to exit immediately
set -x # Activate debugging to show execution details: all commands will be printed before execution

# We ensure the .env file is present.
if [ ! -f .env ]; then
    cp .env.example .env
fi

# We source only the command to be used when running the image
ENTRYPOINT_CMD=sh
. <( grep "^ENTRYPOINT_CMD" .env )
echo "[Operation] Entrypoint command set to: $ENTRYPOINT_CMD"

docker build \
    -f dev.Dockerfile \
    -t credo_jenkins:local .

docker run \
    -v $(pwd):/app \
    --name credo_jenkins \
    -it --rm credo_jenkins:local \
    $ENTRYPOINT_CMD