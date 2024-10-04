#!/bin/bash

show_encryption_warning() {
    read -r -d '|' MESSAGE <<EOF
Signal is being launched with the <b>plaintext password store</b> by
default due to database corruption bugs when using the encrypted backends.
This will leave your keys <b>unencrypted</b> on disk as it did in all previous versions.

If you wish to experiment with the encrypted backend, set the environment variable
<tt>SIGNAL_PASSWORD_STORE</tt> to <tt>gnome-libsecret</tt>, <tt>kwallet</tt>,
<tt>kwallet5</tt> or <tt>kwallet6</tt> depending on your desktop environment using
Flatseal or the following command:

<tt>flatpak override --env=SIGNAL_PASSWORD_STORE=gnome-libsecret org.signal.Signal</tt>

Note that the encrypted backends are <b>experimental</b> and may cause data loss on some systems.

Press <b>Yes</b> to proceed with <b>plaintext password store</b> or
<b>No</b> to <b>exit</b>. |
EOF
    zenity --question --no-wrap --default-cancel --icon-name=dialog-warning --title "Warning" --text "$MESSAGE"

    if [ "$?" -eq "1" ]; then
        echo "Debug: Abort as user pressed no"
        exit 1
    fi
}

EXTRA_ARGS=()

declare -i SIGNAL_DISABLE_GPU="${SIGNAL_DISABLE_GPU:-0}"
declare -i SIGNAL_DISABLE_GPU_SANDBOX="${SIGNAL_DISABLE_GPU_SANDBOX:-0}"

# only kept for backward compatibility
if ((${SIGNAL_USE_WAYLAND:-0})); then
    export ELECTRON_OZONE_PLATFORM_HINT="${ELECTRON_OZONE_PLATFORM_HINT:-auto}"
fi

declare -r SIGNAL_PASSWORD_STORE="${SIGNAL_PASSWORD_STORE:-basic}"

case "${SIGNAL_PASSWORD_STORE}" in
    basic | gnome-libsecret | kwallet | kwallet5 | kwallet6)
        echo "Debug: Using password store: ${SIGNAL_PASSWORD_STORE}"
        EXTRA_ARGS=(
            "--password-store=${SIGNAL_PASSWORD_STORE}"
        )
        ;;
    *)
        echo "Error: SIGNAL_PASSWORD_STORE (${SIGNAL_PASSWORD_STORE}) must be one of the following: basic, gnome-libsecret, kwallet, kwallet5, kwallet6"
        exit 1
        ;;
esac

# Warn the user about plaintext password
# - if the user chose basic (this is the default)
# - and Signal starts for the first time
if [[ "${SIGNAL_PASSWORD_STORE}" == "basic" ]]; then
    if [[ ! -f "${XDG_CONFIG_HOME}/Signal Beta/config.json" ]]; then
        show_encryption_warning
    fi
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
# We can't export to "/app/Signal Beta" because chromium trips over the whitespace
exec zypak-wrapper "/app/Signal/signal-desktop-beta" "${EXTRA_ARGS[@]}" "$@"
