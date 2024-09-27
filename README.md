# Signal Desktop

This repo hosts the flatpak version of [Signal-Desktop](https://github.com/signalapp/Signal-Desktop)

Signal-Desktop is a Private Messenger that links with your installed Android/iOS version of Signal.

Note that this is an **unofficial** redistribution.

## Installing

```bash
flatpak install flathub org.signal.Signal
```

## Options

You can set the following environment variables:

- `ELECTRON_OZONE_PLATFORM_HINT=auto`: Enables Wayland support
- `SIGNAL_DISABLE_GPU=1`: Disables GPU acceleration
- `SIGNAL_DISABLE_GPU_SANDBOX=1`: Disables GPU sandbox
- `SIGNAL_PASSWORD_STORE`: Selects where the database key is stored. Valid options are:
	- `basic` Writes the key in plaintext to config.json. This is the default.
	- `gnome-libsecret` for X-Cinnamon, Deepin, GNOME, Pantheon, XFCE, UKUI, unity
	- `kwallet` for kde4
	- `kwallet5` for kde5
	- `kwallet6` for kde6

## Wayland

The integration between Chromium, Electron, and Wayland seems broken.
Adding an additional layer of complexity like Flatpak can't help.
For now, using this repo with wayland should be regarded as experimental.

Wayland support can be enabled with `ELECTRON_OZONE_PLATFORM_HINT=auto` in [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal).

Wayland support can also be enabled on the command line:

```bash
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto org.signal.Signal
```

GPU acceleration may be need to be disabled:

```bash
flatpak override --user --env=SIGNAL_DISABLE_GPU=1 org.signal.Signal
```

Additionally, Nvidia devices may need the GPU sandbox disabled:

```bash
flatpak override --user --env=SIGNAL_DISABLE_GPU_SANDBOX=1 org.signal.Signal
```

## Issue reporting

**Please only report issues in this repo that are specific to the flatpak version.**

Issues that can be replicated in a stable release should be reported in the [upstream repo](https://github.com/signalapp/Signal-Desktop).
Make sure, that the reported issue is **not** flatpak-related.
