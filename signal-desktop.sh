#!/bin/bash

report_warning() {
    read -r -d '|' MESSAGE <<EOF
Signal is being launched with the <b>plaintext password store</b> by
default due to database corruption bugs when using the encrypted backends.
This will leave your keys <b>unencrypted</b> on disk.

If you wish to experiment with the encrypted backend at the risk of
database corruption, set the environment variable
<tt>SIGNAL_PASSWORD_STORE</tt> to gnome_libsecret, kwallet,
kwallet5 or kwallet6 depending on your desktop environment using
Flatseal.

Press <b>Yes</b> to proceed with <b>plaintext password store</b> or
<b>No</b> to <b>exit</b>. |
EOF
    zenity --question --no-wrap --default-cancel --icon-name=dialog-warning --title "Warning" --text "$MESSAGE"

    if [ "$?" -eq "1" ]; then
        echo "Debug: Abort as user pressed no"
        exit 1
    else
        touch "${XDG_CACHE_HOME}"/warning-shown
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

if [[ "${SIGNAL_PASSWORD_STORE}" == "basic" ]]; then
    echo "Info: Using basic password store. The encryption key to the datbase will be stored unencrypted."
    echo "Info: If you see a database opening error, you should change the environent variable SIGNAL_PASSWORD_STORE to one of the following: gnome-libsecret, kwallet, kwallet5, or kwallet6"
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

found_basic_pw_store=false
for value in "${EXTRA_ARGS[@]}"; do
    if [[ "--password-store=basic" = "$value" ]]; then
        found_basic_pw_store=true
        break
    fi
done

if "$found_basic_pw_store" && [[ ! -f "${XDG_CACHE_HOME}"/warning-shown ]]; then
    report_warning
elif ! "$found_basic_pw_store"; then
    rm "${XDG_CACHE_HOME}"/warning-shown || true
fi

exec zypak-wrapper "/app/Signal/signal-desktop" "${EXTRA_ARGS[@]}" "$@"
