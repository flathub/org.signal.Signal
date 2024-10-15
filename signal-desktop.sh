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

user_accepted_filesystem_access() {
    read -r -d '|' MESSAGE <<EOF
By default, Signal is being launched with the <b>filesystem=host</b> option to allow access to the host filesystem.
This is currently required because Electron decided to break the portals (temporarily):
See <a href="https://github.com/flathub/org.signal.Signal/issues/719">flathub/org.signal.Signal#719</a> and <a href="https://github.com/electron/electron/issues/43819#issuecomment-2383104130">electron/electron#43819</a>

If you disagree with host filesystem access, please use Flatseal (or the commandline) to restrict the permissions
to the only those directories you want Signal to be able access for reading and writing files.

Press <b>Yes</b> to proceed with <b>filesystem=host</b> or <b>No</b> to <b>exit</b>.

If you manually changed the permissions with Flatseal already, you can press <b>Yes</b> to continue.
EOF
    zenity --question --no-wrap --icon-name=info --title "Information about full file system access" --text "${MESSAGE}"
    return $?
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

# Explain filesystem=host upon the first run
EXPLAIN_FILESYSTEM_HOST_FILE="${XDG_CACHE_HOME}/signal-user-accepted-filesystem-access"
if [[ ! -f "${EXPLAIN_FILESYSTEM_HOST_FILE}" ]]; then
    if user_accepted_filesystem_access; then
        echo "Debug: User accepted filesystem=host explanation or already changed permissions."
        touch "${EXPLAIN_FILESYSTEM_HOST_FILE}"
    else
        echo "Debug: Abort as user pressed cancel on filesystem=host explanation."
        exit 1
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
exec zypak-wrapper "/app/Signal/signal-desktop" "${EXTRA_ARGS[@]}" "$@"
