#!/bin/bash

EXTRA_ARGS=()

if [[ -z "${DISPLAY}" ]] && [[ -n "${WAYLAND_DISPLAY}" ]];
then
    EXTRA_ARGS+=(
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--disable-gpu"
        "--enable-features=WaylandWindowDecorations"
    )
fi

if [[ "${XDG_SESSION_TYPE}" == "wayland" ]] && [[ -c /dev/nvidia0 ]];
then
    EXTRA_ARGS+=(
        "--disable-gpu-sandbox"
    )
fi

# Additional args for tray icon
if [[ -n "${SIGNAL_USE_TRAY_ICON+x}" ]];
then
    EXTRA_ARGS+=(
        "--use-tray-icon"
    )
fi
if [[ -n "${SIGNAL_START_IN_TRAY+x}" ]];
then
    EXTRA_ARGS+=(
        "--start-in-tray"
    )
fi




export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper /app/Signal/signal-desktop "${EXTRA_ARGS[@]}" "$@"
