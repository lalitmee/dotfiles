# Flutter Installation & Update Script (`install-flutter`) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an interactive and scriptable Zsh utility `install-flutter` in dotfiles to install, update, and manage the Flutter SDK on Linux via Git, featuring a searchable `gum filter` UI and CLI flags.

**Architecture:** A standalone Zsh script structured with fold markers, `gum` styling (cobalt2 theme), modular functions for dependency checking, git cloning/updating, channel switching, diagnostic doctor checks, and repair routines, with an interactive fuzzy-filter menu fallback.

**Tech Stack:** Zsh, Git, Gum (Charmbracelet CLI tool), Flutter SDK.

## Global Constraints

- Location: `bin/.config/bin/install-flutter`
- SDK Target Directory: `$HOME/development/flutter`
- Shebang & Standards: `#!/usr/bin/env zsh`, 4-space indentation, `[[ ... ]]` conditionals, fold markers (`# {{{` and `# }}}`) for functions
- Executable permissions: `chmod +x`
- No auto-commits without user confirmation

---

### Task 1: Scaffolding and CLI Help Interface

**Files:**
- Create: `bin/.config/bin/install-flutter`

**Interfaces:**
- Produces: `show_help()`, `gum_log()`, `ensure_path()`, CLI argument parser (`-h`, `--help`, `-i`, `-u`, `-c`, `-d`, `-p`, `-s`)

- [ ] **Step 1: Write base script structure and CLI parser**

Write the script with shebang, configuration variables (`FLUTTER_DIR="$HOME/development/flutter"`, `FLUTTER_GIT_URL="https://github.com/flutter/flutter.git"`), cobalt2 colors, `show_help()`, and `ensure_path()` functions.

- [ ] **Step 2: Syntax validation**

Run: `zsh -n bin/.config/bin/install-flutter`
Expected: Return 0 (no syntax errors)

- [ ] **Step 3: Verification of Help output**

Run: `zsh bin/.config/bin/install-flutter --help`
Expected: Formatted help output with usage instructions and flag descriptions.

---

### Task 2: System Dependencies & Environmental Pre-checks

**Files:**
- Modify: `bin/.config/bin/install-flutter`

**Interfaces:**
- Produces: `check_dependencies()`, `is_installed()`

- [ ] **Step 1: Implement dependency check logic**

Implement `check_dependencies()` to verify required core utilities (`curl`, `git`, `unzip`, `xz-utils` / `xz`, `zip`, `tar`, `libglu1-mesa`) and optional desktop build dependencies (`clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`). Use `gum confirm` to prompt for automatic installation via `sudo apt` / system package manager if any required packages are missing.

- [ ] **Step 2: Syntax validation**

Run: `zsh -n bin/.config/bin/install-flutter`
Expected: Return 0 (no syntax errors)

---

### Task 3: Core SDK Actions (Install, Update, Channel Switch, Precache, Doctor, Status, Repair)

**Files:**
- Modify: `bin/.config/bin/install-flutter`

**Interfaces:**
- Produces: `install_flutter()`, `update_flutter()`, `switch_channel()`, `run_doctor()`, `precache_artifacts()`, `show_status()`, `repair_flutter()`

- [ ] **Step 1: Implement core SDK operations**

Implement:
- `install_flutter()`: Clone `stable` branch into `$HOME/development/flutter`, run `flutter precache`, and run `flutter doctor -v`.
- `update_flutter()`: Check SDK existence, execute `flutter upgrade`, and precache artifacts.
- `switch_channel(channel)`: Prompt or use argument to switch branch (`stable`, `beta`, `master`) via `flutter channel <name>` and `flutter upgrade`.
- `run_doctor()`: Execute `flutter doctor -v`.
- `precache_artifacts()`: Execute `flutter precache`.
- `show_status()`: Print SDK path, version (`flutter --version`), git branch, and upstream commit.
- `repair_flutter()`: Check git status in SDK directory, offer `git reset --hard` / `git clean` or `flutter clean`.

- [ ] **Step 2: Syntax validation**

Run: `zsh -n bin/.config/bin/install-flutter`
Expected: Return 0 (no syntax errors)

---

### Task 4: Interactive Searchable Menu (`gum filter`) & Dispatcher

**Files:**
- Modify: `bin/.config/bin/install-flutter`

**Interfaces:**
- Produces: `main_menu()`, script entrypoint

- [ ] **Step 1: Implement `main_menu()` with `gum filter`**

Render a searchable action list using `gum filter --placeholder "Search Flutter actions..." --height 12 --indicator "👉"`:
- `📥 Install Flutter (Fresh setup to ~/development/flutter)`
- `🔄 Update / Upgrade Flutter (flutter upgrade + precache)`
- `🔀 Switch Channel (stable, beta, master)`
- `🩺 Run Flutter Doctor (flutter doctor -v)`
- `📦 Precache Artifacts (download platform binaries)`
- `🛠️ Check & Install Dependencies`
- `ℹ️ Flutter Status & Version Info`
- `🧹 Clean / Repair Installation`
- `🚪 Exit`

Route the selection to the corresponding function.

- [ ] **Step 2: Syntax validation**

Run: `zsh -n bin/.config/bin/install-flutter`
Expected: Return 0 (no syntax errors)

---

### Task 5: Permissions, Symlink & End-to-End Verification

**Files:**
- Permissions: `bin/.config/bin/install-flutter`

- [ ] **Step 1: Set executable permissions**

Run: `chmod +x bin/.config/bin/install-flutter`

- [ ] **Step 2: Validate flag invocation**

Run: `bin/.config/bin/install-flutter --help`
Run: `bin/.config/bin/install-flutter --status` (verifies handling when not yet installed or installed)

- [ ] **Step 3: Verify with pre-commit / dotfiles sanity**

Run: `zsh -n bin/.config/bin/install-flutter`
