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

## Error reporting
Please only report errors in this repo that are specific to the flatpak version.
All other errors should be reported to the upstream repo: https://github.com/signalapp/Signal-Desktop 

## Wayland
The integration between Chromium, Electron, and Wayland seems broken.
Adding an additional layer of complexity like Flatpak can't help.
For now, using this repo with wayland should be regarded as experimental.

The socket is given, however, the special treatment from the launch script was actually never given in the first place.

If you need special features from Wayland, add these to you run script:

* `--ozone-platform=wayland`: Use wayland
* `--enable-features=WaylandWindowDecorations`: Add window decorations but will break fullscreen and resizing
* `--disable-gpu`: May be needed
* `--disable-gpu-sandbox`: May be needed on NVIDIA devices
