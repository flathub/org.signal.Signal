#!/bin/bash

EXTRA_ARGS=()

# Special treatment for Wayland
if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    EXTRA_ARGS+=(
        "--ozone-platform=wayland"
        "--enable-features=WaylandWindowDecorations"
    )
fi

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

echo "Debug: Will run signal with the following arguments: ${EXTRA_ARGS[@]}"
echo "Debug: Additionally, user gave: $@"

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper /app/Signal/signal-desktop "${EXTRA_ARGS[@]}" "$@"
