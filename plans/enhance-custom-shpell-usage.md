# Feature Implementation Plan: Enhance Custom Shpell Usage (Refined)

## 📋 Todo Checklist
- [x] ✅ Refactor existing popup bindings to use `custom_shpell`.
- [x] ✅ Create a new `dev` table for `--replay` commands.
- [x] ✅ Create a help table for the new `dev` mode.
- [x] ✅ Create a new `monitor` table.
- [ ] ⏩ Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The user's dotfiles are managed with `stow`. The tmux configuration is in `tmux/.tmux.conf.local`. The user has a `bin` directory for scripts, and also a `tmux/.config/tmux/scripts` directory.

### Current Architecture
The user is using `tmux` with `tpm` for plugin management. They have the `navahas/tmux-grimoire` plugin installed, which provides the `custom_shpell` command. `custom_shpell` is used to create and manage popup windows in tmux.

The user has a mix of `display-popup`, custom scripts, and `custom_shpell` for creating popups. This leads to an inconsistent configuration and makes it harder to manage the popups.

### Dependencies & Integration Points
- **tmux-grimoire:** The core dependency for `custom_shpell`.

### Considerations & Challenges
- The user wants to be sure that the suggested commands will work.
- The plan should provide clear instructions on how to refactor the existing bindings and create new ones.

## 📝 Implementation Plan

### Prerequisites
- The `navahas/tmux-grimoire` plugin must be installed and working correctly.

### Step-by-Step Implementation

#### 1. Refactor Existing Popup Bindings

The goal of this step is to unify the popup management by using `custom_shpell` where it makes sense. This will provide a more consistent and manageable configuration.

- **Files to modify:** `tmux/.tmux.conf.local`

- **Changes needed:**

  - **lazygit:**
    - **Old:** `bind g run-shell "$HOME/.config/tmux/scripts/popup/lazygit.sh '#{pane_current_path}'"`
    - **New:** `bind g run-shell "custom_shpell standard lazygit \"lazygit -p '#{pane_current_path}'\""`
    - **Reasoning:** Using `custom_shpell` simplifies the binding and removes the need for a custom script. The `-p` flag is the correct way to specify the repository path for lazygit.

  - **cht.sh:**
    - **Old:** `bind i display-popup -w 85% -h 85% -E "~/.config/tmux/scripts/cht-sh/cht.sh"`
    - **New:** `bind i run-shell "custom_shpell ephemeral cht-sh '~/.config/tmux/scripts/cht-sh/cht.sh'"`
    - **Reasoning:** Using `ephemeral` will run the script every time the key is pressed, which is the desired behavior.

  - **Project Runner:**
    - **Old:** `bind C-r display-popup -w 90% -h 90% -E "zsh -lc '~/.config/tmux/scripts/popup/runner/runner.sh'"`
    - **New:** `bind C-r run-shell "custom_shpell ephemeral project-runner '~/.config/tmux/scripts/popup/runner/runner.sh'"`
    - **Reasoning:** You are correct, `custom_shpell` already provides an interactive popup shell, so calling `zsh -lc` is redundant. The `runner.sh` script has a shebang `#!/usr/bin/env zsh -i` which ensures it runs in an interactive shell, so we can call the script directly.

  - **gh-dash:**
    - **Old:** `bind G run-shell "~/.config/tmux/scripts/popup/gh-dash.sh"`
    - **New:** `bind G run-shell "custom_shpell standard gh-dash 'gh dash'"`
    - **Reasoning:** Simplifies the setup by removing the need for a custom script. `custom_shpell` handles the popup toggling.

#### 2. Create `dev` table for `--replay` commands

- **Files to modify:** `tmux/.tmux.conf.local`

- **Changes needed:**

  - Add a new table for development-related commands that use the `--replay` feature.

  ```tmux
  #-------------------------------------------------------------------------------
  # --- NOTE: Dev Mode {{{ 
  #           Parent block for all dev-mode functionality.
  #           Enter dev-mode by pressing C-a C-d.
  #-------------------------------------------------------------------------------

  # Dev mode trigger
  bind-key C-d switch-client -T dev-mode

  #-------------------------------------------------------------------------------
  # --- NOTE: Dev Mode - Build/Test Runners {{{ 
  #-------------------------------------------------------------------------------

  # Example for a Rust project:
  bind -T dev-mode b run-shell "custom_shpell standard rust-build 'cargo build' --replay"

  # Example for a Node.js project:
  bind -T dev-mode t run-shell "custom_shpell standard node-test 'npm test' --replay"

  #-------------------------------------------------------------------------------
  # }}} 
  #-------------------------------------------------------------------------------

  # Exit dev mode
  bind-key -T dev-mode q switch-client -T root

  # Help for dev mode
  bind -T dev-mode ? run-shell "$HOME/.config/tmux/scripts/popup/help/help.sh dev-mode"

  #-------------------------------------------------------------------------------
  # }}} 
  #-------------------------------------------------------------------------------
  ```

#### 3. Create Help Table for `dev-mode`

- **File to create:** `tmux/.config/tmux/scripts/popup/help/tables/dev-mode.txt`

- **Content:**

  ```tsv
  Key	Description
  b	Build Rust project
  t	Test Node.js project
  q	Quit dev-mode
  ?	Show help
  ```

#### 4. Create `monitor-mode` table

- **Files to modify:** `tmux/.tmux.conf.local`

- **Changes needed:**

  - Add a new table for monitoring-related commands.

  ```tmux
  #-------------------------------------------------------------------------------
  # --- NOTE: Monitor Mode {{{ 
  #           Parent block for all monitor-mode functionality.
  #           Enter monitor-mode by pressing C-a C-m.
  #-------------------------------------------------------------------------------

  # Monitor mode trigger
  bind-key C-m switch-client -T monitor-mode

  #-------------------------------------------------------------------------------
  # --- NOTE: Monitor Mode - Process Viewer {{{ 
  #-------------------------------------------------------------------------------

  bind -T monitor-mode b run-shell "custom_shpell standard process-viewer 'btm'"

  #-------------------------------------------------------------------------------
  # }}} 
  #-------------------------------------------------------------------------------

  # Exit monitor mode
  bind-key -T monitor-mode q switch-client -T root

  # Help for monitor mode
  bind -T monitor-mode ? run-shell "$HOME/.config/tmux/scripts/popup/help/help.sh monitor-mode"

  #-------------------------------------------------------------------------------
  # }}} 
  #-------------------------------------------------------------------------------
  ```

#### 5. Create Help Table for `monitor-mode`

- **File to create:** `tmux/.config/tmux/scripts/popup/help/tables/monitor-mode.txt`

- **Content:**

  ```tsv
  Key	Description
  b	Process Viewer (btm)
  q	Quit monitor-mode
  ?	Show help
  ```

### For Future Consideration

- **Markdown Preview**:
  - The following command can be used to preview markdown files in a terminal browser inside a popup. This requires `w3m` and `glow` to be installed.
  - `bind -T dev-mode m run-shell "custom_shpell standard markdown-preview 'w3m -T text/html <(glow -s dark your_file.md)'"`
  - **Testing:** Before adding this to your configuration, you can test it by running the command directly in your shell. To do so, you first need to install `w3m` and `glow` by running `./scripts/install/phases/03-system-foundation.zsh`.

### Testing Strategy
- After modifying the `tmux/.tmux.conf.local` file, reload the tmux configuration with `tmux source-file ~/.tmux.conf.local`.
- Test each of the new and refactored keybindings to ensure they open the correct application in a popup.
- For the `--replay` bindings in the new `dev-mode` table, test that the command is re-executed when the key is pressed again.
- Test the new help table by pressing `C-a C-d ?`.
- Test the new monitor mode and its help table by pressing `C-a C-m` and `C-a C-m ?`.

## 🎯 Success Criteria
- The user has a more consistent and manageable tmux popup configuration.
- The user has a new `dev` table for their development commands with a corresponding help table.
- The user has a new `monitor` table for their monitoring commands with a corresponding help table.
- The user has new and useful `custom_shpell` bindings that enhance their workflow.