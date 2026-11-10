# Research: Espanso installation on Omarchy

Generated: 2026-11-10

## Executive summary

The crash observed on this Omarchy host matches an Arch/Wayland Espanso failure pattern in the wxWidgets GTK startup path. Espanso’s official Linux guide lists manual source compilation—not an AppImage or binary package—as the Arch + Wayland method. The current AUR source package builds Espanso 2.4.1 against local Arch libraries, and a 2026 community report says that build ran on Arch where the prebuilt Debian binary crashed. The Omarchy plugin at `taisau/omarchy-espanso` is a bar-control and snippet-browser companion, not a crash fix; its install helper chooses the AUR source package and starts the service, while the package install hook grants `CAP_DAC_OVERRIDE`. The current host already has the binary AUR package, linked snippets, and scoped udev permissions; its Espanso service is disabled after the repeatable startup crash.

## Best practices and findings

- **Use the Wayland-specific implementation on Hyprland.** Omarchy uses Hyprland/Wayland; Espanso’s official guide marks Wayland support experimental and says Arch/Manjaro Wayland users should compile from source. [official]
- **Prefer the current AUR source package over the Debian binary package for this host.** Current AUR package base `espanso` is version 2.4.1-2 and its `espanso-wayland` variant builds with Arch’s local wxWidgets. The separate `espanso-wayland-bin` package repackages Espanso’s Debian Wayland binary. [version specific]
- **The crash has a close known match.** This host’s Espanso 2.4.1 binary warned that Arch wxWidgets libraries lacked version information, then SIGSEGV’d in `wxWindow::AddChildGTK` while starting `espanso launcher`. In Espanso issue #2594, an Arch user reports the same warning and GTK stack for a prebuilt Espanso binary; a later comment reports that building Espanso 2.4.1 from source against Arch wxWidgets 3.2.11 ran successfully. That is strong evidence for trying the current source AUR package, but not proof it will run against this host’s exact library build. [community consensus]
- **AUR package install hooks grant a broad capability.** Both the current `espanso-wayland` source package and the `espanso-wayland-bin` package contain an install hook that applies `CAP_DAC_OVERRIDE` to `/usr/bin/espanso`. Espanso’s official guide explains that the capability is temporarily activated to open input devices and then dropped. The current host deliberately installed the binary package with scriptlets disabled and uses a scoped udev `uaccess` rule instead. [official] [version specific]
- **The Omarchy bar repository is optional UI integration.** `taisau/omarchy-espanso` provides a Quickshell bar widget for status/toggle, Espanso search, snippet browsing, and copying snippet replacements to the clipboard. It expects `/usr/bin/espanso` and does not implement text expansion itself. Its installer helper chooses `espanso-wayland` on Omarchy and enables/starts the user service; using it as-is would reintroduce the package hook’s capability unless package scripts are deliberately handled. The panel displays replacement text, so snippets with personal details are visible in its UI; copy-to-clipboard is an explicit action. The UI cannot fix a crash in Espanso’s daemon. [repository]
- **The repository is small and recent.** At research time GitHub showed 4 stars, 3 forks, and 18 commits; latest listed release-like manifest version is 1.0.14. Treat it as a community plugin rather than a core Omarchy component. [repository]
- **Snippet compatibility is a material constraint if switching tools.** The existing Espanso file contains shell, clipboard, date, form, and choice-variable matches. SnipExpand advertises Espanso YAML compatibility but explicitly excludes shell commands/scripts, forms, and some variables. It would require a feature-by-feature migration audit. [version specific]

## Omarchy plugin review

Repository: <https://github.com/taisau/omarchy-espanso>

- `README.md` documents plugin installation with `omarchy plugin add ... --enable`, or manual cloning into `~/.config/omarchy/plugins/` followed by adding the widget ID to `shell.json`.
- `Service.qml` polls Espanso status and match-list commands, invokes Espanso CLI commands for toggle/search/restart, and uses `wl-copy` for the explicit “copy replacement” action. It does not create or transform snippet matches.
- `scripts/espanso-install.sh` installs `espanso-wayland` if no Espanso binary exists, then enables/starts the user service. It does not diagnose a failing binary or choose the binary package.
- **Recommendation:** consider this plugin after Espanso itself starts reliably. It is useful Omarchy polish, but it is not needed for automatic expansion and is not a remedy for this crash.

## Community discussion

- Espanso issue [#2594](https://github.com/espanso/espanso/issues/2594) contains reports of wxWidgets incompatibility on Arch. A later September 2026 comment distinguishes the prebuilt-binary crash from the source-built 2.4.1 package, which reportedly worked against wxWidgets 3.2.11. This host has wxWidgets 3.2.12-1 and the same warning/GTK stack, so the match is strong but not an exact same-version reproduction. [community consensus] [version specific]
- The current AUR package page also has user comments about the 2.4.1 packaging transition and its Wayland build. The live package base is now `espanso`, which emits separate `espanso-x11` and `espanso-wayland` packages. [community]
- Reddit search results contain general Wayland reports, but the accessible threads did not provide a more reliable or specific fix than the Espanso issue and AUR discussion. [debated]

## Official documentation

- [Espanso: Install on Linux](https://espanso.org/docs/install/linux/) — says Wayland is experimental; for Arch/Manjaro, it documents source compilation with `git`, `dbus`, `base-devel`, `wl-clipboard`, and `wxwidgets-gtk3`. It documents `espanso service register` and service start. [official]
- [Espanso: Wayland final steps](https://github.com/espanso/website/blob/main/docs/install/linux/_wayland-final-steps.mdx) — explains the input-device requirement and `CAP_DAC_OVERRIDE` behavior. [official]
- [Arch AUR package base: espanso](https://aur.archlinux.org/packages/espanso-wayland) — current Wayland package is source-built from Espanso 2.4.1. The AUR page is user-maintained packaging, not an official Espanso or Arch repository package. [version specific]
- [Omarchy plugin installation](https://github.com/taisau/omarchy-espanso#installation) — documents adding the bar widget; plugin installation is separate from installing the expander. [repository]

## Recommendation for this host

1. Keep the existing snippet config and Stow link unchanged.
2. Replace the current `espanso-wayland-bin` build with the current source-built `espanso-wayland` AUR package, after confirming the current AUR recipe and dependencies. Avoid running its install scriptlet so the scoped udev permission setup remains in effect rather than adding `CAP_DAC_OVERRIDE`.
3. Start Espanso manually first; verify the wxWidgets warnings are gone, the user service stays active, and a simple trigger expands in a text field. Only then enable automatic startup.
4. If source build or runtime still fails, stop and reassess instead of downgrading shared wxWidgets libraries. The fallback is either investigate the exact runtime/library compatibility further or evaluate a Wayland-native expander against the existing snippet features.
5. Add `omarchy-espanso` only if the user wants bar controls/search after expansion works; it is optional.

## Sources

- <https://espanso.org/docs/install/linux/>
- <https://github.com/espanso/espanso/issues/2594>
- <https://aur.archlinux.org/packages/espanso-wayland>
- <https://github.com/taisau/omarchy-espanso>
- <https://github.com/taisau/omarchy-espanso/blob/main/scripts/espanso-install.sh>
- <https://github.com/silouanwright/snipexpand>
- <https://github.com/omacom/omarchy/discussions/8021>
