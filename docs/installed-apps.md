# Installed Packages & Applications Reference

This document serves as a comprehensive index of all manually installed APT packages, Flatpaks, Homebrew formulae, and autostart apps on this system. It includes package classifications, exact use cases, and an active usage status based on shell history, config-dir age, and active processes.

*Last Updated: August 02, 2026*

---

## Usage Status Key
- **✅ Active:** Running now, autostarted, or actively used within the last 60 days.
- **⚠️ Sporadic:** Used or modified within the last 60–300 days; kept for occasional needs.
- **❌ Dead / Unused:** No shell history, untouched config dirs for >300 days, or never run since installation. Likely candidates for removal.

---

## 1. i3 Window Manager & X11 Desktop Stack
These components drive your custom tiling window manager environment (Phases 1 & 2 of the installer).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `i3` | APT | Metapackage for the i3 window manager | Primary tiling window manager shell. | ✅ Active |
| `sxhkd` | APT | Simple X hotkey daemon | Manages global keyboard shortcuts independently of the WM. | ✅ Active |
| `polybar` | APT | Fast and easy-to-use status bar | Desktop status bar showing workspaces, CPU, RAM, battery, etc. | ✅ Active |
| `picom` | APT | Lightweight compositor for X11 | Manages window transparency, shadows, and rendering effects. | ✅ Active |
| `feh` | APT | Fast and light image viewer | Sets randomized wallpaper at startup (`autostart/applications.conf`). | ✅ Active |
| `light` | APT | GNU/Linux backlight control utility | Hotkeys for screen brightness adjustments. | ❌ Dead / Unused |
| `lxappearance` | APT | GTK+ theme switcher | Applies Yaru-dark GTK theme at startup (`exec` in i3 config). | ✅ Active |
| `cbatticon` | APT | Battery icon that sits in the system tray | Autostarted battery tray icon with low-charge warnings (30%/20%). | ✅ Active |
| `unclutter` | APT | Hides the mouse cursor when inactive | Autostarted cursor autohide after 10s idle (`autostart/applications.conf`). | ✅ Active |
| `pavucontrol` | APT | PulseAudio Volume Control (GUI) | Audio input/output device and volume routing. | ⚠️ Sporadic |
| `playerctl` | APT | Media player controller CLI | Controls music via XF86 media keys (i3 + sxhkd) and polybar Spotify module. | ✅ Active |
| `xdotool` | APT | Command-line X11 automation tool | Window manipulation in `i3/layout-manager.sh`; types text in `dictate-whisper`. | ✅ Active |
| `pulseaudio` | APT | Sound server daemon | Legacy audio system wrapper (audio routed via PipeWire). | ✅ Active |
| `sur5r-keyring` | APT | Keyring for i3 repository | Required to fetch upstream i3 packages securely. | ✅ Active |

---

## 2. Terminal, Shell & Core Command-Line Tools
Your CLI environment foundation, shell configuration, and interactive shell utils (Phase 3).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `zsh` | APT | Programmable interactive shell | Your primary login and interactive terminal shell. | ✅ Active |
| `tmux` | APT | Terminal multiplexer | Runs persistent sessions, split panes, and background tasks. | ✅ Active |
| `tmuxinator` | APT | Tmux session manager (Ruby-based) | Automatically starts complex tmux layouts from YAML configs. | ❌ Dead / Unused |
| `stow` | APT | GNU Symlink farm manager | Symlinks configurations from the dotfiles repo to `$HOME`. | ✅ Active |
| `nala` | APT | Beautiful frontend for `apt` | Clean terminal UI and fast downloads for package operations. | ❌ Dead / Unused |
| `lsd` | APT | Modern replacement for `ls` | Icon-rich, colorized file listings with tree views. | ⚠️ Sporadic |
| `tldr` | APT | Simplified, community-driven man pages | Quick terminal cheatsheets for common commands. | ❌ Dead / Unused |
| `chafa` | APT | Character art facsimile generator | Renders images and GIFs as ANSI characters in terminal. | ❌ Dead / Unused |
| `tree` | APT | Recursive directory listing command | Visualization tool for directory folder trees. | ⚠️ Sporadic |
| `xclip` | APT | Command-line X11 clipboard utility | Interacts with primary/system clipboard (mostly replaced). | ❌ Dead / Unused |
| `xsel` | APT | Alternative command-line clipboard tool | Clipboard helper for selections and pasting. | ❌ Dead / Unused |
| `kiro` | APT | Ultra-minimal terminal text editor | Lightweight terminal editor, possibly used in development. | ⚠️ Sporadic |
| `clipboard` | Brew | Advanced CLI clipboard manager | High-featured replacement for xclip/xsel. | ❌ Dead / Unused |

---

## 3. Artificial Intelligence & Development Environments
The core stack of editors and AI agents defining your developer workspace (Phase 4).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `cursor` | APT | AI-first code editor | Modern VS Code fork with deep LLM/copilot integrations. | ✅ Active |
| `opencode` | APT | Interactive CLI engineering agent | Powers your currently active autonomous terminal assistant! | ✅ Active |
| `emacs` | APT | Extensible, self-documenting text editor | Configured for Org-mode, writing, and custom workflows. | ✅ Active |
| `goose` | APT | Autonomous AI developer agent | CLI AI agent from Block (formerly Square). | ⚠️ Sporadic |
| `notebooklm` | APT | Google NotebookLM webapp wrapper | AI research assistant web-wrapper. | ✅ Active |
| `programmusic` | APT | AI-assisted music/sound application | Soundscape generation or AI developer audio utility. | ✅ Active |
| `antigravity` | APT | AI developer assistant framework | Custom-built CLI helper/assistant. | ✅ Active |
| `code-insiders` | APT | Visual Studio Code (Insiders build) | Unused preview channel of VS Code. | ✅ Active |

---

## 4. Web Browsers
The collection of browsers on your system, often serving isolated contexts.

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `brave-browser` | APT | Privacy-focused Chromium browser | Primary web browser, loaded with ad-block defaults. | ✅ Active |
| `google-chrome-stable` | APT | Official Google Chrome browser | Secondary browser for Google services/casting. | ✅ Active |
| `vivaldi-stable` | APT | Customization-heavy Chromium browser | Tertiary workspace browser with side-tabs. | ✅ Active |
| `firefox` | APT | Privacy-centric Mozilla browser | Alternative web engine for isolated profiles/compat. | ✅ Active |

---

## 5. Media, Design & Gaming
Applications for playback, audio control, graphic design, and gaming (Phase 6).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `spotify-client` | APT | Native desktop client for Spotify | Music streaming (controls tray scroll utility). | ✅ Active |
| `youtubemusic` | APT | YouTube Music desktop wrapper | Alternative streaming client. | ✅ Active |
| `vlc` | APT | Robust GUI media player | Universal player for audio/video formats. | ✅ Active |
| `mpv` | APT | Command-line driven video player | Highly efficient, keyboard-driven media player. | ✅ Active |
| `cmus` | APT | Lightweight terminal music player | Stale terminal audio client, replaced by Spotify. | ✅ Active |
| `gimp` | APT | GNU Image Manipulation Program | Raster graphics editor (like Photoshop). | ✅ Active |
| `obs-studio` | APT | Screen recording and streaming suite | Video recording, presentation streaming, or virtual camera. | ✅ Active |
| `steam:i386` | APT | Valve Steam store (32-bit package) | Linux gaming loader interface. | ✅ Active |

---

## 6. Communication & Collaboration
Messaging utilities used for active communication.

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `slack-desktop` | APT | Official desktop Slack client | Work and community team communication. | ✅ Active |
| `discord` | APT | Chat, voice, and community app | Personal and developer chat groups. | ✅ Active |
| `twitter` | APT | Webapp wrapper for X/Twitter | Desktop social feed application. | ✅ Active |

---

## 7. Development Language Toolchains
System-wide compilers, runtimes, and environment managers.

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `golang-go` | APT | Go (Golang) compiler and runtime | Local development of Go applications. | ✅ Active |
| `python3.12-venv` | APT | Python 3.12 virtual environment support | Standard library module to create Python virtualenvs. | ⚠️ Sporadic |
| `pipx` | APT | Run Python applications in isolated envs | Manages CLI tools like ruff, black, and other py binaries. | ⚠️ Sporadic |
| `rbenv` | APT | Ruby environment manager | Manages Ruby versions and gems (e.g., for Tmuxinator). | ⚠️ Sporadic |
| `ruby-full` | APT | Complete Ruby development environment | Base system Ruby installation. | ✅ Active |
| `lua5.1` | APT | Lua 5.1 interpreter and runtime | Runtimes for neovim configs or awesome/picom scripts. | ⚠️ Sporadic |
| `luarocks` | APT | Package manager for Lua | Dependency retriever for Lua utilities. | ⚠️ Sporadic |
| `llvm` | APT | Low-Level Virtual Machine toolchain | Compiler backend needed for C/C++/Rust compiling. | ❌ Dead / Unused |

---

## 8. Build, Compilation & Header Libraries
These development packages are required primarily as compile-time dependencies (Phases 0 & 4).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `cmake` | APT | Cross-platform build system | Standard build orchestrator for compiled programs. | ❌ Dead / Unused |
| `meson` | APT | Ultra-fast next-gen build system | Used to compile modern C/C++ projects (like picom/dunst). | ❌ Dead / Unused |
| `ninja-build` | APT | Small build system focused on speed | Heavy compiler runner utilized by Meson/CMake. | ❌ Dead / Unused |
| `autoconf` | APT | Automatic configure script builder | GNU compilation helper tool. | ❌ Dead / Unused |
| `automake` | APT | GNU Makefile generator tool | Standard compile helper. | ❌ Dead / Unused |
| `bison` | APT | General-purpose parser generator | Parser compilation dependency. | ❌ Dead / Unused |
| `libtool` | APT | Generic library support script | Compile-time shared library helper. | ❌ Dead / Unused |
| `libtool-bin` | APT | Binaries for libtool | Core binary utility. | ❌ Dead / Unused |
| `pkg-config` | APT | Manages compiler and linker flags | Crucial compile-time dependency search utility. | ❌ Dead / Unused |
| `portaudio19-dev` | APT | PortAudio developer headers | Required to compile audio-reactive programs. | ❌ Dead / Unused |
| `libwebkit2gtk-4.1-dev` | APT | WebKitGTK development headers | Required to compile desktop-pwa apps (like Pake/Tauri). | ❌ Dead / Unused |
| `tk-dev` | APT | Graphical user interface toolkit | Required to compile python `tkinter` support. | ❌ Dead / Unused |
| `uuid-dev` | APT | Universally Unique ID headers | C/C++ developer header package. | ❌ Dead / Unused |
| `zlib1g-dev` | APT | Compression library headers | Standard compile-time compression library. | ❌ Dead / Unused |
| `libunibilium4` | APT | Terminfo parsing library | Dependency for terminal applications. | ❌ Dead / Unused |

---

## 9. Docker, Infrastructure & Networking
Software driving local container virtualization, scripting, and deployment (Phase 3).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `docker-ce` | APT | Docker engine (Community Edition) | Runs local development container daemons. | ✅ Active |
| `docker-ce-cli` | APT | Docker command-line client | CLI tool to control container operations. | ✅ Active |
| `docker-buildx-plugin` | APT | Extended multiplatform builds plugin | Modern build system for Docker. | ✅ Active |
| `docker-compose-plugin` | APT | Docker Compose plugin | Orchestrates multi-container development systems. | ✅ Active |
| `containerd.io` | APT | High-performance container runtime | Container daemon underlying Docker (service running). | ✅ Active |
| `ansible` | APT | IT automation and configuration engine | Automated system setup. | ✅ Active |
| `ngrok` | APT | Secure reverse-proxy tunneling tool | Port forwarding to expose local dev servers to the web. | ✅ Active |
| `google-cloud-cli` | APT | CLI suite for Google Cloud Platform | Deployment and management tool for GCP. | ✅ Active |

---

## 10. Privacy, Network Troubleshooting & Wifi
Tools for network management, network diagnostics, and anonymous routing.

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `tor` | APT | Anonymizing overlay network daemon | SOCKS5 proxy routing for privacy scripts. | ✅ Active |
| `torbrowser-launcher` | APT | Tor Browser secure downloader | Sandboxed installation loader for Tor Browser. | ✅ Active |
| `traceroute` | APT | Network route packet tracing tool | Command-line network latency/path diagnostics. | ✅ Active |
| `wpasupplicant` | APT | WPA/WPA2 wifi handshake daemon | Standard system wifi connection handler. | ✅ Active |
| `linux-wifi-hotspot` | APT | Share wifi through an access point | GUI/CLI interface to broadcast wifi from your system. | ✅ Active |

---

## 11. Productivity, Scripting & Utilities
General utilities configured to automate workflows and system routines (Phase 5).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `copyq` | APT | Advanced clipboard manager (Qt) | System-tray clipboard history tool (autostart). | ✅ Active |
| `espanso` | APT | Rust-based text expansion tool | Running snippet expansion engine (autostart). | ✅ Active |
| `ulauncher` | APT | Fast desktop application launcher | Keybinding `Ctrl+Space` launches ulauncher (autostart). | ✅ Active |
| `flameshot` | APT | Feature-rich screenshot GUI | Screen-capture utility with annotation defaults. | ✅ Active |
| `transmission` | APT | Fast, easy Bittorrent client (GUI/CLI) | Active torrent downloading client. | ✅ Active |
| `peek` | APT | Simple GIF screen recorder | High-quality compact GIF recorder for dev demos. | ✅ Active |
| `xpad` | APT | Sticky notes desktop app | Yellow desktop sticky notes manager. | ✅ Active |
| `appimagelauncher` | APT | AppImage desktop integration helper | Auto-extracts and links `.AppImage` runtimes to menus. | ✅ Active |
| `dropbox` | Other | Cloud storage file synchronizer | Files sync client (enabled in ~/.config/autostart). | ✅ Active |
| `Handy` | Other | Sticky notes / quick notepad | Autostarting note app (possibly AppImage format). | ✅ Active |

---

## 12. Flatpak Applications
These GUI applications run in sandboxed environments, isolated from system packages.

| Application | App ID | Use Case | Status |
| :--- | :--- | :--- | :--- |
| `Calendar` | `org.gnome.Calendar` | GNOME Desktop calendar application. | ✅ Active |

---

## 13. System Monitoring, Power & Diagnostics
Lower-level monitors and diagnostic tools (Phase 3).

| Package | Source | Description / What it is | Use Case in Your System | Status |
| :--- | :--- | :--- | :--- | :--- |
| `blueman` | APT | Full-featured Bluetooth manager | Manages device pairings and files (tray icon active). | ✅ Active |
| `tlp` | APT | High-power battery optimizer daemon | Enforces battery-saving profiles (service running). | ✅ Active |
| `tlp-rdw` | APT | TLP Radio Device Wizard | Automates disabling wifi/bluetooth when wired. | ✅ Active |
| `iotop` | APT | Disk IO utilization monitor | Terminal-based disk read/write tracking. | ❌ Dead / Unused |
| `powertop` | APT | Intel/AMD power diagnostic tool | Measures active device power draw in milliwatts. | ❌ Dead / Unused |
| `lm-sensors` | APT | Temperature & fan voltage monitor | CLI tool to print board sensor diagnostics. | ❌ Dead / Unused |
| `smartmontools` | APT | S.M.A.R.T drive health checker | Active disk failure prediction utility. | ❌ Dead / Unused |
| `mesa-utils` | APT | OpenGL benchmarking tools | Prints GPU details and test window FPS (glxinfo/glxgears). | ❌ Dead / Unused |
| `stacer` | APT | Complete GUI system optimizer | Dashboard for process tracking, logs, and disk cleaning. | ❌ Dead / Unused |
| `efibootmgr` | APT | Manipulates EFI Boot Manager variables | Edits GRUB menu priorities directly. | ❌ Dead / Unused |

---

## 14. Passive Dependencies & Standard Packages
These packages are installed on the system as necessary shared libraries, utilities, or OS defaults. Do not remove.

| Package | Use Category / Function | Description |
| :--- | :--- | :--- |
| `apt-transport-https` | System Core | Secures repository handshakes. |
| `bsdutils` | System Core | Standard BSD basic shell utils. |
| `ca-certificates` | System Core | Common Certificate Authority definitions. |
| `dash` | System Core | Posix-compliant default utility shell. |
| `diffutils` | System Core | Core system file comparison tools. |
| `findutils` | System Core | Core system files finding tools. |
| `gawk` | System Core | Pattern scanning and processing language. |
| `grep` | System Core | Core pattern matching utility. |
| `gzip` | System Core | Standard system compression. |
| `hostname` | System Core | Utility to set/show system host. |
| `init` | System Core | Essential system initialization. |
| `login` | System Core | User authorization system login. |
| `ncurses-base` | System Core | Core terminal UI layout metadata. |
| `ncurses-bin` | System Core | Standard terminal utilities. |
| `unzip` | System Core | Extraction tool for ZIP archives. |
| `wbritish` | System Core | British English word dictionary list. |
| `wget` | System Core | Essential remote file retriever. |
| `gnupg` | System Security | GnuPG encryption system. |
| `gnutls-bin` | System Security | GnuTLS core security protocol tools. |
| `shim-signed` | Bootloader | Secure Boot shim loader. |
| `grub-efi-amd64` | Bootloader | EFI GRUB Bootloader engine. |
| `grub-efi-amd64-signed` | Bootloader | Signed EFI boot engine. |
| `nvidia-driver-535` | Hardware | Proprietary NVIDIA graphics driver. |
| `linux-generic-hwe-24.04` | Hardware | Hardware Enablement kernel for Ubuntu 24.04. |
| `language-pack-en` | Localization | System English localization. |
| `language-pack-en-base` | Localization | Localization base layouts. |
| `language-pack-gnome-en` | Localization | GNOME application English support. |
| `language-pack-gnome-en-base` | Localization | GNOME application English assets. |
| `ubuntu-desktop-minimal` | Meta | Ubuntu default minimal desktop stack. |
| `ubuntu-minimal` | Meta | Core minimal Ubuntu software pack. |
| `ubuntu-restricted-addons` | Meta | Proprietary codecs and media accessories. |
| `ubuntu-standard` | Meta | Standard Ubuntu utility suite. |
| `ubuntu-wallpapers` | Meta | Standard lockscreen and wallpaper assets. |
| `git` | Git Tooling | Core git version control software. |
| `gh` | Git Tooling | Official GitHub command line suite. |
| `github-desktop` | Git Tooling | Official GitHub desktop Git GUI client. |
| `github` | Git Tooling | Repository authentication handler / helper. |
| `gum` | Shell Styling | Interactive shell design library used by installer. |
| `shellcheck` | Code Quality | Static analysis tool for shell scripts. |
| `shfmt` | Code Quality | Parser and formatter for shell scripts. |
| `sox` | Sound Utility | Play/convert sound formats via command line. |
| `flac` | Sound Utility | Free Lossless Audio Codec. |
