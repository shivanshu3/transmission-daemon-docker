#!/bin/sh

if [ -z "$PUID" ]; then
    echo "PUID must be defined"
    exit 1
fi

if [ -z "$PGID" ]; then
    echo "PGID must be defined"
    exit 1
fi

exec gosu "$PUID:$PGID" \
    ./build/daemon/transmission-daemon --foreground --log-level info \
    --config-dir /config

