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

* `SIGNAL_USE_TRAY_ICON=1`: Enables the tray icon
* `SIGNAL_START_IN_TRAY=1`: Starts in tray
* `SIGNAL_DISABLE_GPU=1`: Disables GPU acceleration
* `SIGNAL_DISABLE_GPU_SANDBOX=1`: Disables GPU sandbox

## Wayland
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
