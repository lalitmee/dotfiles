# Specification: Homebrew Cask Applications Directory Config

## Goal
Configure Homebrew on macOS to install Cask applications to the user-specific `~/Applications` directory rather than the system-wide `/Applications` folder. This avoids permission issues and administrator password prompts.

## Proposed Changes
Modify `zsh/.zprofile` to set the `HOMEBREW_CASK_OPTS` environment variable for macOS Homebrew installations.

### [zsh/.zprofile](file:///Users/lalit.kumar1/dotfiles/zsh/.zprofile)

```diff
 if [[ -f /opt/homebrew/bin/brew ]]; then
     # Homebrew exists at /opt/homebrew for arm64 macos
     eval $(/opt/homebrew/bin/brew shellenv)
+    export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
 elif [[ -f /usr/local/bin/brew ]]; then
     # or at /usr/local for intel macos
     eval $(/usr/local/bin/brew shellenv)
+    export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
```

## Verification
1. Run syntax check on the file:
   ```bash
   zsh -n zsh/.zprofile
   ```
2. Manually source the file or open a new terminal session and verify `echo $HOMEBREW_CASK_OPTS` outputs `--appdir=~/Applications`.
