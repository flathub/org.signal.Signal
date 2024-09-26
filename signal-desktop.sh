#!/bin/bash

EXTRA_ARGS=()

declare -i SIGNAL_DISABLE_GPU="${SIGNAL_DISABLE_GPU:-0}"
declare -i SIGNAL_DISABLE_GPU_SANDBOX="${SIGNAL_DISABLE_GPU_SANDBOX:-0}"

# only kept for backward compatibility
if (( ${SIGNAL_USE_WAYLAND:-0} )); then
    export ELECTRON_OZONE_PLATFORM_HINT="${ELECTRON_OZONE_PLATFORM_HINT:-auto}"
fi

if [[ "${SIGNAL_DISABLE_GPU}" -eq 1 ]]; then
    EXTRA_ARGS+=(
        "--disable-gpu"
    )
fi

if [[ "${SIGNAL_DISABLE_GPU_SANDBOX}" -eq 1 ]]; then
    EXTRA_ARGS+=(
        "--disable-gpu-sandbox"
    )
fi

echo "Debug: Will run signal with the following arguments:" "${EXTRA_ARGS[@]}"
echo "Debug: Additionally, user gave: $*"

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"
exec zypak-wrapper "/app/Signal/signal-desktop" "${EXTRA_ARGS[@]}" "$@"
