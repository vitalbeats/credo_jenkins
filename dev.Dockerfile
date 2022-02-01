FROM elixir:1.13-alpine

WORKDIR /app

# Directs mix to use project folder for config
ENV MIX_ENV=dev \
  XDG_DATA_HOME=/app/.tmp \
  MIX_XDG=true

RUN apk update && \
  apk add --no-cache \
  git \
  inotify-tools

ENTRYPOINT ["/app/scripts/entrypoint_dev.sh"]