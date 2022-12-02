# Signal Desktop Beta

<a href="https://github.com/cam-rod/org.signal.Signal_Beta/actions/workflows/build.yaml?query=branch%3Abeta+event%3Apush"><img src="https://github.com/cam-rod/org.signal.Signal_Beta/actions/workflows/build.yaml/badge.svg?branch=beta&event=push" alt="Status badge for most recent build" title="View the most recent builds"/></a> <a href="https://github.com/cam-rod/org.signal.Signal_Beta/actions/workflows/update.yaml?query=branch%3Abeta"><img src="https://github.com/cam-rod/org.signal.Signal_Beta/actions/workflows/update.yaml/badge.svg?branch=beta" alt="Status badge for update checks" title="View the most recent update checks"/></a>

This repo hosts a modified version of the **unofficial** [Signal flatpak](https://github.com/flathub/org.signal.Signal) to support beta builds of [Signal-Desktop](https://github.com/signalapp/Signal-Desktop).

Signal-Desktop is a Private Messenger that links with your installed Android/iOS version of Signal.

## Installing

The app will be installed as `Signal Beta`.

### From Flatpak bundle

Go to the [build action](https://github.com/cam-rod/org.signal.Signal_Beta/actions/workflows/build.yaml?query=branch%3Abeta+is%3Acompleted) and select the most recent _successful_ run, then download the artifact at the bottom of the page. Install the bundle as follows:

```bash
unzip signal-desktop-beta-v<version_number>.zip && cd signal-desktop-beta-v<version_number>/
chmod +x org.signal.Signal_Beta.flatpak
flatpak install ./org.signal.Signal_Beta.flatpak
```

If the artifact is not available, you can build from source with the following section.

### From source

```bash
git clone git@github.com:cam-rod/org.signal.Signal_Beta.git
cd org.signal.Signal_Beta/

mkdir builddir
flatpak-builder --install [--system/--user] --install-deps-from=flathub --force-clean builddir org.signal.Signal_Beta.yaml
```

## Building

Dependencies are listed in the [manifest file](./org.signal.Signal_Beta.yaml). Also required is [flatpak-builder](https://github.com/flatpak/flatpak-builder).

```bash
git clone git@github.com:cam-rod/org.signal.Signal_Beta.git
cd org.signal.Signal_Beta/

mkdir builddir
flatpak-builder --force-clean --install-deps-from=flathub builddir org.signal.Signal_Beta.yaml
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
