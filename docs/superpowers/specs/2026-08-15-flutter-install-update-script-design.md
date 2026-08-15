# Design Specification: Flutter Installation & Update Script (`install-flutter`)

## 1. Overview
A standalone, interactive, and scriptable Zsh utility located at `bin/.config/bin/install-flutter` to install, update, and manage Flutter SDK installations on Linux. The script uses `gum` for a rich terminal UI with searchable fuzzy-filtering (`gum filter`) and supports direct CLI flags for automation.

## 2. Requirements & Goals
- **Location**: `bin/.config/bin/install-flutter` (automatically linked into `PATH` via dotfiles `stow`).
- **Target Path**: `$HOME/development/flutter` (aligned with `$HOME/development/flutter/bin` in `zsh/.zshenv`).
- **Installation Method**: Official Git clone (`git clone -b stable https://github.com/flutter/flutter.git`).
- **Interactive UI**: Searchable fuzzy filter powered by `gum filter` with cobalt2 color theme styling.
- **Scriptable CLI**: Direct flags for automated execution (`--install`, `--upgrade`, `--doctor`, `--channel`, `--status`, `--help`).
- **Coding Conventions**:
  - `#!/usr/bin/env zsh`
  - 4-space indentation
  - Quoted variables and `[[ ... ]]` conditionals
  - Fold markers (`# {{{` and `# }}}`) for functions
  - Executable permissions (`chmod +x`)

## 3. Architecture & Components

### 3.1. Interactive Searchable Menu (`gum filter`)
When executed without CLI arguments, the script presents a searchable list of actions:
1. `📥 Install Flutter` - Check dependencies, clone `stable` channel into `~/development/flutter`, precache binaries, and run `flutter doctor`.
2. `🔄 Update / Upgrade Flutter` - Run `flutter upgrade` and `flutter precache`.
3. `🔀 Switch Release Channel` - Fuzzy select `stable`, `beta`, or `master` channel and switch via `flutter channel <name>` + `flutter upgrade`.
4. `🩺 Run Flutter Doctor` - Run verbose diagnostics (`flutter doctor -v`).
5. `📦 Precache Platform Artifacts` - Pre-download platform engines and tools (`flutter precache`).
6. `🛠️ Check & Install Dependencies` - Check and install required Linux dependencies (`curl`, `git`, `unzip`, `xz-utils`, `zip`, `libglu1-mesa`, `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`).
7. `ℹ️ Flutter Status & Info` - Show current version, git branch/commit, and active path.
8. `🧹 Repair / Clean Installation` - Offer `flutter clean` or git reset options for broken states.

### 3.2. CLI Flags Interface
- `-i, --install`: Run the installation routine directly.
- `-u, --upgrade`, `--update`: Run the update routine directly.
- `-c, --channel <channel>`: Switch channel to `stable`, `beta`, or `master`.
- `-d, --doctor`: Run `flutter doctor -v`.
- `-p, --precache`: Run `flutter precache`.
- `-s, --status`: Display current Flutter installation details.
- `-h, --help`: Show help and usage message.

### 3.3. Functions & Modular Structure
- `show_help()`: Display help text and examples.
- `gum_log()`: Helper for styled output with cobalt2 colors (`gum style`).
- `ensure_path()`: Temporarily exports `$HOME/development/flutter/bin` to `PATH` in the current script process if not already present.
- `check_dependencies()`: Checks system dependencies (curl, git, unzip, xz, tar, libglu1-mesa, and build tools). Prompts to install missing packages via apt/pacman/dnf.
- `install_flutter()`: Clones Flutter to `$HOME/development/flutter`, sets up precache, and runs doctor. If directory already exists, asks to update instead.
- `update_flutter()`: Verifies installation and executes `flutter upgrade`.
- `switch_channel([channel])`: Switches the channel to specified or selected channel and upgrades.
- `run_doctor()`: Runs `flutter doctor -v`.
- `precache_artifacts()`: Runs `flutter precache`.
- `show_status()`: Prints current version, git status, and channel.
- `repair_flutter()`: Offers clean/reset operations if local SDK state is corrupt.
- `main_menu()`: Renders the `gum filter` selector and routes to corresponding function.

## 4. Error Handling & Edge Cases
- **Missing `gum`**: Falls back to simple text input or alerts user to install `gum`.
- **Existing Directory on Install**: Detects `$HOME/development/flutter` and prevents accidental overwrite, offering update instead.
- **Missing SDK on Update**: Prompts to run install first if `$HOME/development/flutter` does not exist.
- **Git Modification Conflicts**: Repair action helps inspect `git status` and reset changes if `flutter upgrade` gets blocked.

## 5. Verification Plan
1. Validate script syntax: `zsh -n bin/.config/bin/install-flutter`.
2. Check executable permissions: `[[ -x bin/.config/bin/install-flutter ]]`.
3. Test `--help` flag output.
4. Test interactive `gum filter` menu rendering.
5. Test dependency checking and status display.
