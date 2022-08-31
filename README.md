# Signal Desktop

This repo hosts the flatpak version of [Signal-Desktop](https://github.com/signalapp/Signal-Desktop)

Signal-Desktop is a Private Messenger that links with your installed Android/iOS version of Signal.

Note that this is an **inofficial** redistribution.

## Installing

`flatpak install flathub org.signal.Signal`

## Options
You can set the two environment variables:

* `SIGNAL_USE_TRAY_ICON=true`: Enables the tray icon
* `SIGNAL_START_IN_TRAY=true`: Starts in tray
* `SIGNAL_USE_WAYLAND=true`: Enables Wayland support
* `SIGNAL_DISABLE_GPU=true`: Disables GPU acceleration
* `SIGNAL_DISABLE_GPU_SANDBOX=true`: Disables GPU sandbox

## Error reporting
Please only report errors in this repo that are specific to the flatpak version.
All other errors should be reported to the upstream repo: https://github.com/signalapp/Signal-Desktop 

## Wayland
The integration between Chromium, Electron, and Wayland seems broken.
Adding an additional layer of complexity like Flatpak can't help.
For now, using this repo with wayland should be regarded as experimental.

Wayland support can be enabled with `SIGNAL_USE_WAYLAND=true` in [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal).

Wayland support can also be enabled on the command line:

```
$ flatpak override --user --env=SIGNAL_USE_WAYLAND=true org.signal.Signal
```

GPU acceleration may be need to be disabled:

```
$ flatpak override --user --env=SIGNAL_DISABLE_GPU=true org.signal.Signal
```

Additionally, Nvidia devices may need the GPU sandbox disabled:

```
$ flatpak override --user --env=SIGNAL_DISABLE_GPU_SANDBOX=true org.signal.Signal
```
