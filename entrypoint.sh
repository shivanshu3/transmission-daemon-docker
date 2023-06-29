#!/bin/sh

exec gosu "$PUID":"$GUID" \
    ./build/daemon/transmission-daemon --foreground --log-level info \
    --config-dir /config

