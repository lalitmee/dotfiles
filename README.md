# dotfiles

## Quick Start

To set up your environment, clone this repository and run the main installer. It will guide you through the process and automatically configure all necessary tools and security hooks.

```bash
git clone https://github.com/lalitmee/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

All of my dotfiles are here. 👍

## Configurations

This dotfiles repository includes configuration for:

- **Zed Editor** - Editor settings, keybindings, and theme configuration
  - See `zed/README.md` for details
  - Security-first design: no secrets tracked in version control
  - Ready for future environment variable interpolation support
  - Install with: `stow zed`

And more...

## Screenshots

### neovim

![neovim](https://user-images.githubusercontent.com/10762218/216720123-b7b7456f-f245-477d-a287-b580c55d2534.png)

### tmux

![tmux](https://user-images.githubusercontent.com/10762218/216720167-176b70d3-1b99-4a33-aac5-44954f6377b4.png)

To remove Ubuntu's duplicate tmux after the `/usr/local` source build is verified, run `install-tmux --cleanup-distro`. It previews the apt removal and requires confirmation. Then verify the active binary and package state:

```bash
whence -a tmux
tmux -V
dpkg-query -W tmux # expected to report that the package is not installed
```

The weekly update check is opt-in. From the dotfiles repository, link its user units and enable the timer:

```bash
stow systemd
systemctl --user daemon-reload
systemctl --user enable --now tmux-update-check.timer
systemctl --user status tmux-update-check.timer
journalctl --user -u tmux-update-check.service
```

It only checks for updates and sends a desktop notification when one is available; it never installs updates. Disable it with `systemctl --user disable --now tmux-update-check.timer`.
