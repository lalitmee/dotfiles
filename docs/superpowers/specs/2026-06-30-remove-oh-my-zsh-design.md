# Spec: Remove ~/.oh-my-zsh and Migrate to ~/.znap

Remove the obsolete `~/.oh-my-zsh` folder and variables from the Zsh configuration and installer, migrating the Znap plugin manager to `~/.znap/znap`.

## Background & Goal

Historically, the dotfiles used `Oh My Zsh` as a framework. While the framework has been removed from active use in favor of a lean Znap-based setup, references to `~/.oh-my-zsh` and the `$ZSH` variable remained. 

This change cleans up the filesystem by removing the `~/.oh-my-zsh` directory entirely, updating configuration references to point to `~/.znap/znap`, and updating the phase installer to pre-install Znap in its new location instead of Oh My Zsh.

## Proposed Changes

### Configuration Files

#### [MODIFY] [zsh/.zshenv](file:///home/lalitmee/dotfiles/zsh/.zshenv)
- Remove `export ZSH="$HOME/.oh-my-zsh"` on line 39.

#### [MODIFY] [zsh/.zshrc](file:///home/lalitmee/dotfiles/zsh/.zshrc)
- Update `ZNAP_DIR` path from `~/.oh-my-zsh/custom/plugins/znap` to `~/.znap/znap`.

#### [MODIFY] [zsh/.zsh_aliases](file:///home/lalitmee/dotfiles/zsh/.zsh_aliases)
- Remove the commented-out `ohmyzsh` alias.

### Installation Phases

#### [MODIFY] [scripts/install/phases/03-system-foundation.zsh](file:///home/lalitmee/dotfiles/scripts/install/phases/03-system-foundation.zsh)
- Remove the Oh My Zsh installation block (lines 39-43).
- Remove the Powerlevel10k theme cloning block (lines 45-49).
- Add a block to clone the Znap plugin manager directly into `~/.znap/znap`.

## Migration & Execution Plan

1. Apply the configuration file changes.
2. Remove the old directory: `rm -rf ~/.oh-my-zsh`
3. Launch a new shell instance: `exec zsh` (or run `zs`). Znap will automatically clone itself and all active plugins into `~/.znap` on startup.

## Verification Plan

### Manual Verification
- Run `zsh -n` syntax checks on modified configuration files.
- Verify that a new terminal shell starts cleanly and downloads plugins to `~/.znap`.
- Verify that features like autosuggestions, syntax highlighting, and fzf-tab function correctly in the new shell.
