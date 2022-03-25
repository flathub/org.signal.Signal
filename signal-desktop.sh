#!/bin/bash

EXTRA_ARGS=()

if [[ -z "${DISPLAY}" ]] && [[ -n "${WAYLAND_DISPLAY}" ]];
then
    EXTRA_ARGS+=(
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--disable-gpu"
    )
fi

if [[ "${XDG_SESSION_TYPE}" == "wayland" ]] && [[ -c /dev/nvidia0 ]];
then
    EXTRA_ARGS+=(
        "--disable-gpu-sandbox"
    )
fi

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper /app/Signal/signal-desktop "${EXTRA_ARGS[@]}" "$@"
