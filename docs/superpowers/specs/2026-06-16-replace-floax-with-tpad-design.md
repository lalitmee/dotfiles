# Design Spec: Replace tmux-floax with tmux-tpad Scratchpad

This specification describes replacing the `omerxx/tmux-floax` plugin with `Subbeh/tmux-tpad` to manage a generic shell scratchpad, freeing up the first-level prefix binding `C-a m` and binding the new scratchpad to `C-a C-d s` inside `dev-mode`.

## Background & Rationale

Currently, `tmux-floax` is used solely to provide a single generic floating shell scratchpad (toggled via `C-a m`). However, `tmux-tpad` is already installed and extensively configured in this dotfiles repository for several other tools and note files. By replacing `tmux-floax` with a new `tpad` instance:
1. We eliminate an extra plugin dependency (`tmux-floax`).
2. We free up the highly accessible first-level prefix binding `C-a m`.
3. We place the generic scratchpad under `dev-mode` (`C-a C-d` followed by `s`), which is highly ergonomic on a QWERTY keyboard as it can be typed entirely with the left hand.

---

## Proposed Changes

### 1. Modify [tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)

- **Remove `tmux-floax` Plugin & Configuration:**
  Remove lines 576–591 containing the `omerxx/tmux-floax` plugin declaration and `@floax-*` configurations.

- **Configure `tmux-tpad` Scratchpad Instance:**
  - Add `scratchpad` to the end of the `for inst in ...` list used to dynamically apply default styles to all `tpad` instances (around line 663).
  - Define the `scratchpad` instance command as empty `""` (to run the default shell) and set its title to `" Scratchpad "`:
    ```tmux
    set -g @tpad-scratchpad-cmd ""
    set -g @tpad-scratchpad-title " Scratchpad "
    ```

- **Define the Keybinding under `dev-mode`:**
  Add a binding in the `dev-mode` key table to toggle the new `scratchpad` instance via `s`:
  ```tmux
  bind -T dev-mode s run-shell "#{@tpad-path} toggle scratchpad"
  ```
  *(Note: We follow the repository convention of using `bind` instead of `bind-key` for consistency).*

---

### 2. Update Help Tables

- **Modify [global.txt](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/global.txt):**
  Remove the `C-a C-` or `C-a C-\` entry for `tmux-floax`.

- **Modify [dev-mode.txt](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/dev-mode.txt):**
  Add a line mapping `s` to the `Scratchpad`:
  ```text
  s	Scratchpad
  ```

---

### 3. Update AGENTS.md

- **Modify [AGENTS.md](file:///home/lalitmee/dotfiles/AGENTS.md):**
  Under the tmux keybindings or general documentation, note the removal of `C-a m` (floax) and the addition of `C-a C-d s` (tpad scratchpad).

---

## Verification Plan

### Automated Verification
- Run tmux configuration syntax check:
  ```bash
  tmux -f /home/lalitmee/dotfiles/tmux/.tmux.conf.local -c "echo 'valid'"
  ```

### Manual Verification
- Reload the tmux configuration:
  ```bash
  tmux source-file ~/.config/tmux/.tmux.conf
  ```
- Test `C-a C-d s` to ensure it successfully launches the `tmux-tpad` scratchpad with a `zsh` session.
- Verify `C-a m` is unbound or doesn't trigger anything.
- Check the help menus (`C-a /` for global, and `C-a C-d ?` for dev-mode) to ensure they display the updated listings correctly.
