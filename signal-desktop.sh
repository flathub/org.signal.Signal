#!/bin/sh

EXTRA_ARGS=""

if [ -z "${DISPLAY}" ] && [ -n "${WAYLAND_DISPLAY}" ];
then
    EXTRA_ARGS="--enable-features=UseOzonePlatform --ozone-platform=wayland"
fi

exec zypak-wrapper /app/Signal/signal-desktop ${EXTRA_ARGS} "$@"
