# Signal Desktop Beta

This repo hosts a modified version of the unofficial [Signal flatpak](https://github.com/flathub/org.signal.Signal) to support beta builds of [Signal-Desktop](https://github.com/signalapp/Signal-Desktop).

Signal-Desktop is a Private Messenger that links with your installed Android/iOS version of Signal.

Note that this is an **inofficial** redistribution.

## Installing

```bash
git clone git@github.com:cam-rod/org.signal.Signal_Beta.git
cd org.signal.Signal_Beta/

mkdir builddir
flatpak-builder --install [--system/--user] builddir org.signal.Signal_Beta.yaml
```

The app will be installed as `Signal Beta`.

## Building

Dependencies are listed in the [manifest file](./org.signal.Signal_Beta.yaml). Also required is [flatpak-builder](https://github.com/flatpak/flatpak-builder).

```bash
git clone git@github.com:cam-rod/org.signal.Signal_Beta.git
cd org.signal.Signal_Beta/

mkdir builddir
flatpak-builder --force-clean builddir org.signal.Signal_Beta.yaml
```

## Options

You can set the following environment variables:

* `SIGNAL_USE_TRAY_ICON=1`: Enables the tray icon
* `SIGNAL_START_IN_TRAY=1`: Starts in tray
* `SIGNAL_USE_WAYLAND=1`: Enables Wayland support
* `SIGNAL_DISABLE_GPU=1`: Disables GPU acceleration
* `SIGNAL_DISABLE_GPU_SANDBOX=1`: Disables GPU sandbox

### Wayland

The integration between Chromium, Electron, and Wayland seems broken.
Adding an additional layer of complexity like Flatpak can't help.
For now, using this repo with wayland should be regarded as experimental.

Wayland support can be enabled with `SIGNAL_USE_WAYLAND=1` in [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal).

Wayland support can also be enabled on the command line:

```
$ flatpak override --user --env=SIGNAL_USE_WAYLAND=1 org.signal.Signal
```

GPU acceleration may be need to be disabled:

```
$ flatpak override --user --env=SIGNAL_DISABLE_GPU=1 org.signal.Signal
```

Additionally, Nvidia devices may need the GPU sandbox disabled:

```
$ flatpak override --user --env=SIGNAL_DISABLE_GPU_SANDBOX=1 org.signal.Signal
```

## Issue reporting

Please only report issues in this repo that are specific to the beta version of the flatpak ([view the differences here](https://github.com/flathub/org.signal.Signal/compare/master...cam-rod:org.signal.Signal_Beta:beta)). All other flatpak-specific issues should be reported to the [flatpak repo](https://github.com/flathub/org.signal.Signal), and issues with Signal Beta itself should be reported to [the upstream repo](https://github.com/signalapp/Signal-Desktop).
