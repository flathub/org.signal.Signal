# Signal Desktop Beta

This repo hosts the flatpak version of [Signal-Desktop](https://github.com/signalapp/Signal-Desktop) _beta releases_.

Signal-Desktop is a Private Messenger that links with your installed Android/iOS version of Signal.

Note that this is an **unofficial** redistribution.

## Installing

```bash
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub-beta org.signal.Signal
```

The app will be installed as `Signal Beta`. The stable and beta release can be installed side-by-side, and will act as two separate installations. They do not share their data directory: you have to link both separately.

- To run the beta, specify the beta branch with `flatpak run org.signal.Signal//beta`.
- You can specify a default branch with `flatpak make-current org.signal.Signal beta`.

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

```bash
flatpak override --user --env=SIGNAL_USE_WAYLAND=1 org.signal.Signal
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

Any issues associated with a beta release should be reported to the [Signal community forum](https://community.signalusers.org/c/beta-feedback/25), under the topic _Beta feedback for the upcoming Desktop <MAJOR>.<MINOR> release_. Issues that can be replicated in a stable release should be reported in the [upstream repo](https://github.com/signalapp/Signal-Desktop).
