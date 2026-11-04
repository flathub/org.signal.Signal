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

    if (($? == 1)); then
        echo "Error: User pressed no" >&2
        exit 1
    fi
}

# Return success if: 1, true, yes, on (case-insensitive, trimmed)
# Otherwise return failure.
is_true() {
    local -r name="$1"
    local value="${!name:-}"

    # Trim leading and trailing whitespace
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"

    [[ "${value,,}" =~ ^(1|true|yes|on)$ ]]
}

maybe_show_encryption_warning() {
    # Don't show if the setting is not basic
    [[ "${SIGNAL_PASSWORD_STORE}" != "basic" ]] && return 0
    # Don't show if Signal was already started before
    [[ -f "${XDG_CONFIG_HOME}/Signal/config.json" ]] && return 0
    # Don't show if it's actively disabled
    is_true SIGNAL_DISABLE_ENCRYPTION_WARNING && return 0

    # Otherwise, show the warning.
    show_encryption_warning
}

EXTRA_ARGS=()

declare -r SIGNAL_PASSWORD_STORE="${SIGNAL_PASSWORD_STORE:-basic}"

case "${SIGNAL_PASSWORD_STORE}" in
basic | gnome-libsecret | kwallet | kwallet5 | kwallet6)
    echo "Debug: Using password store: ${SIGNAL_PASSWORD_STORE}"
    EXTRA_ARGS=(
        "--password-store=${SIGNAL_PASSWORD_STORE}"
    )
    ;;
*)
    echo "Error: SIGNAL_PASSWORD_STORE (${SIGNAL_PASSWORD_STORE}) must be one of the following: basic, gnome-libsecret, kwallet, kwallet5, kwallet6" >&2
    exit 1
    ;;
esac

# Show encryption warning if needed
maybe_show_encryption_warning

if is_true SIGNAL_DISABLE_GPU; then
    EXTRA_ARGS+=(
        "--disable-gpu"
    )
fi

if is_true SIGNAL_DISABLE_GPU_SANDBOX; then
    EXTRA_ARGS+=(
        "--disable-gpu-sandbox"
    )
fi

echo "Debug: Will run signal with the following arguments:" "${EXTRA_ARGS[@]}"
echo "Debug: Additionally, user gave: $*"

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

# Finally launch signal
exec zypak-wrapper "/app/Signal/signal-desktop" "${EXTRA_ARGS[@]}" "$@"
