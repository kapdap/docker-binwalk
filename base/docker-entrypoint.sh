#!/bin/sh

U_ID=${U_ID:-1000}
G_ID=${G_ID:-${U_ID}}

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
  /bin/run-parts "$DIR"
fi

gosu ${U_ID}:${G_ID} "$@"