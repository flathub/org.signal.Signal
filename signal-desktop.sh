#!/bin/bash

EXTRA_ARGS=()

# Additional args for tray icon
if [[ -n "${SIGNAL_USE_TRAY_ICON+x}" ]]; then
    EXTRA_ARGS+=(
        "--use-tray-icon"
    )
fi
if [[ -n "${SIGNAL_START_IN_TRAY+x}" ]]; then
    EXTRA_ARGS+=(
        "--start-in-tray"
    )
fi

if [[ -n "${SIGNAL_USE_WAYLAND+x}" && "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    EXTRA_ARGS+=(
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform=wayland"
    )
fi

if [[ -n "${SIGNAL_DISABLE_GPU+x}" ]]; then
    EXTRA_ARGS+=(
        "--disable-gpu"
    )
fi

if [[ -n "${SIGNAL_DISABLE_GPU_SANDBOX+x}" ]]; then
    EXTRA_ARGS+=(
        "--disable-gpu-sandbox"
    )
fi


echo "Debug: Will run signal with the following arguments: ${EXTRA_ARGS[@]}"
echo "Debug: Additionally, user gave: $@"

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper /app/Signal/signal-desktop "${EXTRA_ARGS[@]}" "$@"
