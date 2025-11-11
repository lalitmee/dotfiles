# Feature Implementation Plan: Spotify Integration

## 📋 Todo Checklist
- [x] ✅ Create `bin/spotify-control` script for cross-platform Spotify control.
- [x] ✅ Update Neovim keybindings in `nvim/.config/nvim/lua/plugins/keys.lua` to use `spotify-control`.
- [x] ✅ Create `tmux/.config/tmux/scripts/popup/spotify/` directory and individual scripts for Spotify actions.
- [x] ✅ Define new Tmux keybinding table for Spotify controls in `tmux/.tmux.conf.local`.
- [x] ✅ Add keybindings to the new Tmux table to call the Spotify action scripts.
- [x] ✅ Create `tmux/.config/tmux/scripts/help/tables/spotify.txt` for Spotify keybinding documentation.
- [x] ✅ Update `tmux/.tmux.conf.local` to include the new help table.
- [ ] Test Neovim Spotify keybindings on both macOS and Linux.
- [ ] Test Tmux Spotify keybindings on both macOS and Linux.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
- **Neovim Keybindings**: `nvim/.config/nvim/lua/plugins/keys.lua` currently uses `playerctl` for Spotify control.
- **Tmux Configuration**: `tmux/.tmux.conf.local` is the main configuration file for Tmux keybindings and table definitions.
- **Tmux Scripts**: `tmux/.config/tmux/scripts/popup/` is the directory for popup-related scripts.
- **Help Tables**: `tmux/.config/tmux/scripts/help/tables/` contains documentation for Tmux keybindings.
- **Bin Directory**: `bin/` is available for custom executable scripts.

### Current Architecture
The current Neovim setup relies on `playerctl`, which is primarily a Linux utility. This limits cross-platform robustness. Tmux integration for Spotify controls does not exist.

### Dependencies & Integration Points
- **`playerctl`**: Currently used by Neovim, but not cross-platform for macOS.
- **`spotify_player`**: Identified as a potential cross-platform CLI tool for Spotify control.
    -   **GitHub Repository**: `aome510/spotify-player` (https://github.com/aome510/spotify-player)
    -   **Dependability and Stability**:
        -   **Active Development**: The project shows recent activity, with fixes and upgrades (e.g., `librespot` library upgrade in August 2025), indicating ongoing maintenance and responsiveness to issues.
        -   **Community Engagement**: With 5.6k stars and 273 forks on GitHub, it demonstrates a notable level of community interest and usage.
        -   **Issue Resolution**: While some open issues exist, critical bugs have been addressed, suggesting a well-maintained project.
        -   **Comprehensive Features**: It aims for "full feature parity" with the official Spotify application, implying a robust and well-developed codebase.
        -   **Cross-platform**: Designed to work on Linux, macOS, and Windows, directly addressing the cross-platform requirement.
    -   **Reasoning for Selection**: `spotify_player` was chosen because it provides a direct command-line interface for Spotify control, which is ideal for keybinding integration. Its cross-platform compatibility and consistent command structure across operating systems simplify the implementation, avoiding the need for separate platform-specific tools like `playerctl` (Linux) and AppleScript (macOS).
- **Shell scripting**: Will be used to create a wrapper script for cross-platform compatibility and individual Tmux action scripts.
- **Neovim `which-key.nvim`**: Used for managing Neovim keybindings.
- **Tmux `bind` command**: Used for defining keybindings and tables.
- **`gum`**: Used for displaying help tables in Tmux.

### Considerations & Challenges
- **Platform detection**: The `spotify-control` script needs to reliably detect the operating system (macOS vs. Linux) to execute the correct commands. (Note: `spotify_player` commands are generally consistent across platforms, simplifying this).
- **Error handling**: The scripts should gracefully handle cases where Spotify is not running or `spotify_player` is not installed.
- **Volume control**: `spotify_player` might have its own volume control, or it might need to integrate with system-level volume control (e.g., `osascript` on macOS, `amixer` or `pactl` on Linux). This needs to be investigated.
- **Tmux table design**: Choosing an intuitive keybinding for the new Spotify table and its actions.
- **Help documentation**: Ensuring the new keybindings are well-documented in the Tmux help system.

## 📝 Implementation Plan

### Prerequisites
- It is assumed that `spotify_player` is already installed on both macOS and Linux systems.

### Step-by-Step Implementation

1.  **Create `bin/spotify-control` for cross-platform control.**
    -   **Files to modify**: `bin/spotify-control` (new file)
    -   **Changes needed**:
        -   Add a shebang `#!/usr/bin/env zsh`.
        -   Implement a check for `spotify_player` existence.
        -   Implement OS detection if platform-specific commands are needed (though `spotify_player` commands are generally consistent).
        -   Use `spotify_player` commands for actions like `play-pause`, `next`, `previous`, `volume up`, `volume down`.
        -   Add error handling for `spotify_player` not found or Spotify not running.
        -   Example structure (simplified to avoid repetition as `spotify_player` commands are consistent):
            ```zsh
            #!/usr/bin/env zsh

            ACTION=$1

            # Check if spotify_player is installed
            if ! command -v spotify_player &> /dev/null; then
                echo "Error: spotify_player is not installed. Please install it to use Spotify controls."
                exit 1
            fi

            case "$ACTION" in
                play-pause) spotify_player playback play-pause ;;
                next) spotify_player playback next ;;
                previous) spotify_player playback previous ;;
                volume-up) spotify_player playback volume --offset 5 ;;
                volume-down) spotify_player playback volume --offset -- -5 ;;
                *) echo "Unknown action: $ACTION" ;;
            esac
            ```
        -   Make the script executable: `chmod +x bin/spotify-control`.

2.  **Update Neovim keybindings.**
    -   **Files to modify**: `nvim/.config/nvim/lua/plugins/keys.lua`
    -   **Changes needed**:
        -   Replace `playerctl` calls with calls to `spotify-control`.
        -   Example:
            ```lua
            { "<leader>an", ":!spotify-control previous<CR>", desc = "Spotify Prev" },
            { "<leader>ap", ":!spotify-control next<CR>", desc = "Spotify Next" },
            { "<leader>as", ":!spotify-control play-pause<CR>", desc = "Spotify Play Pause" },
            ```

3.  **Create Tmux Spotify scripts.**
    -   **Files to modify**:
        -   `tmux/.config/tmux/scripts/popup/spotify/` (new directory)
        -   `tmux/.config/tmux/scripts/popup/spotify/play-pause.sh` (new file)
        -   `tmux/.config/tmux/scripts/popup/spotify/next.sh` (new file)
        -   `tmux/.config/tmux/scripts/popup/spotify/previous.sh` (new file)
        -   `tmux/.config/tmux/scripts/popup/spotify/volume-up.sh` (new file)
        -   `tmux/.config/tmux/scripts/popup/spotify/volume-down.sh` (new file)
    -   **Changes needed**:
        -   Each script will call `spotify-control` with the appropriate action.
        -   Example for `play-pause.sh`:
            ```zsh
            #!/usr/bin/env zsh
            spotify-control play-pause
            ```
        -   Make all scripts executable: `chmod +x`.

4.  **Define new Tmux keybinding table and add keybindings.**
    -   **Files to modify**: `tmux/.tmux.conf.local`
    -   **Changes needed**:
        -   Add a new Tmux table, e.g., `spotify-controls`.
        -   Bind a key to enter this table, e.g., `bind C-e switch-client -T spotify-mode`.
        -   Example for `tmux/.tmux.conf.local`:
            ```tmux
            # Spotify Controls Table
            bind C-e switch-client -T spotify-mode

            bind -T spotify-mode p run-shell "~/.config/tmux/scripts/popup/spotify/play-pause.sh" \; display-message "Spotify: Play/Pause"
            bind -T spotify-mode n run-shell "~/.config/tmux/scripts/popup/spotify/next.sh" \; display-message "Spotify: Next"
            bind -T spotify-mode b run-shell "~/.config/tmux/scripts/popup/spotify/previous.sh" \; display-message "Spotify: Previous"
            bind -T spotify-mode + run-shell "~/.config/tmux/scripts/popup/spotify/volume-up.sh" \; display-message "Spotify: Volume Up"
            bind -T spotify-mode - run-shell "~/.config/tmux/scripts/popup/spotify/volume-down.sh" \; display-message "Spotify: Volume Down"
            bind -T spotify-mode q switch-client -T root # Exit table
            ```
        -   Consider using `display-popup` for a more interactive experience, similar to other existing popups. This would involve creating a `runner.sh` script in `tmux/.config/tmux/scripts/popup/spotify/` that uses `gum` to display options and execute the commands.

5.  **Create and update Tmux help tables.**
    -   **Files to modify**:
        -   `tmux/.config/tmux/scripts/help/tables/spotify-mode.txt` (new file)
        -   `tmux/.tmux.conf.local` (to add help binding)
    -   **Changes needed**:
        -   Create `spotify-mode.txt` with tab-separated values for Spotify keybindings.
            ```tsv
            Key	Description
            p	Play/Pause Spotify
            n	Next Track
            b	Previous Track
            +	Volume Up
            -	Volume Down
            q	Quit Spotify Controls
            ```
        -   Add a keybinding to `tmux/.tmux.conf.local` to display this help table, e.g., `bind -T spotify-mode ? run-shell "~/.config/tmux/scripts/help/help.sh spotify-mode"`.

### Testing Strategy
1.  **`spotify_player` installation verification**:
    -   Run `spotify_player --version` on both macOS and Linux to confirm installation.
    -   Run basic commands like `spotify_player playback play-pause` directly in the terminal to ensure functionality.
2.  **`bin/spotify-control` testing**:
    -   Execute `spotify-control play-pause`, `next`, `previous`, `volume-up`, `volume-down` directly on both macOS and Linux to verify cross-platform logic and command execution.
3.  **Neovim integration testing**:
    -   Open Neovim on both macOS and Linux.
    -   Press `<leader>an`, `<leader>ap`, `<leader>as` and observe Spotify behavior.
4.  **Tmux integration testing**:
    -   Start a Tmux session on both macOS and Linux.
    -   Press `C-a C-e` to enter the Spotify controls table.
    -   Press `p`, `n`, `b`, `+`, `-` and observe Spotify behavior.
    -   Press `C-a C-e ?` to verify the help table is displayed correctly.

## 🎯 Success Criteria
- `spotify_player` is successfully installed and functional on both macOS and Linux.
- Neovim keybindings (`<leader>an`, `<leader>ap`, `<leader>as`) control Spotify correctly on both macOS and Linux.
- A new Tmux keybinding table (`C-a C-e`) is created for Spotify controls.
- Tmux keybindings within the Spotify table (`p`, `n`, `b`, `+`, `-`) control Spotify correctly on both macOS and Linux.
- The Tmux help system (`C-a C-e ?`) displays the Spotify keybindings accurately.
- The solution is robust and handles cases where Spotify is not running or `spotify_player` is not available (graceful error messages).