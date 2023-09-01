#!/bin/sh

if [ -z "$PUID" ]; then
    echo "PUID must be defined"
    exit 1
fi

if [ -z "$PGID" ]; then
    echo "PGID must be defined"
    exit 1
fi

export TRANSMISSION_WEB_HOME=/transmission_build/transmission-4.0.4/web/public_html

exec gosu "$PUID:$PGID" \
    ./build/daemon/transmission-daemon --foreground --log-level info \
    --config-dir /config

