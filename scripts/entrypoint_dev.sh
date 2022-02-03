#!/bin/sh

set -e # Any command which returns non-zero exit code will cause this shell script to exit immediately
set -x # Activate debugging to show execution details: all commands will be printed before execution

echo "[Operation] Symlink vscode-server (for developers that use it)"
mkdir -p /app/.tmp/.vscode-server \
    && ln -s /app/.tmp/.vscode-server /root/.vscode-server

echo "[Operation] Dependencies installation"
mix local.hex --force && mix local.rebar --force
mix deps.get || true

echo "[Success] Container Running"
exec "$@"