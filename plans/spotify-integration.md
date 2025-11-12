# Feature Implementation Plan: Spotify Integration

## 📋 Todo Checklist
- [x] ✅ Create `bin/spotify-control` script for cross-platform Spotify control.
- [x] ✅ Create `nvim/.config/nvim/lua/core/spotify.lua` module for asynchronous Spotify control.
- [x] ✅ Update Neovim keybindings in `nvim/.config/nvim/lua/plugins/keys.lua` to use Lua functions for Spotify control, including volume up/down and moving all Spotify keybindings to `<localleader>s` with the following assignments: `sp` for previous, `sn` for next, `ss` for play/pause, `su` for volume up, and `sd` for volume down.
- [ ] Consolidate Tmux Spotify scripts into a single `spotify-action.sh` and implement system notifications.
- [x] ✅ Define new Tmux keybinding table for Spotify controls in `tmux/.tmux.conf.local` with `p` for previous, `n` for next, `s` for play/pause, `u` for volume up, and `d` for volume down.
- [x] ✅ Add keybindings to the new Tmux table to call the Spotify action scripts.
- [x] ✅ Create `tmux/.config/tmux/scripts/help/tables/spotify.txt` for Spotify keybinding documentation with `p` for previous, `n` for next, `s` for play/pause, `u` for volume up, and `d` for volume down.
- [x] ✅ Update `tmux/.tmux.conf.local` to include the new help table.
- [ ] Test Neovim Spotify keybindings on both macOS and Linux.
- [ ] Test Tmux Spotify keybindings on both macOS and Linux.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
- **Neovim Keybindings**: `nvim/.config/nvim/lua/plugins/keys.lua` currently uses `playerctl` for Spotify control.
- **Tmux Configuration**: `tmux/.tmux.conf.local` is the main configuration file for Tmux keybindings and table definitions.
- **Tmux Scripts**: `tmux/.config/tmux/scripts/popup/` is the directory for popup-related scripts.
- **Help Tables**: `tmux/.config/tmux/scripts/popup/help/tables/` contains documentation for Tmux keybindings.
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
- **Neovim UI Blocking**: Directly executing shell commands in Neovim can block the UI. This needs to be addressed by using asynchronous execution and `vim.notify` for feedback.
- **Tmux UI Blocking**: `tmux display-message` blocks the UI. This needs to be replaced with system notifications.

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

2.  **Implement Neovim Spotify control using Lua module.**
    -   **New Step 2.1: Create `nvim/.config/nvim/lua/core/spotify.lua` module.**
        -   **Files to modify**: `nvim/.config/nvim/lua/core/spotify.lua` (new file)
        -   **Changes needed**:
            *   Define Lua functions (e.g., `spotify.play_pause()`, `spotify.next()`, `spotify.previous()`, `spotify.volume_up()`, `spotify.volume_down()`).
            *   These functions will execute `spotify-control <action>` asynchronously using `vim.fn.jobstart()`.
            *   Implement `vim.notify` for success messages and error handling.
            *   Example structure:
                ```lua
                local M = {}

                local function run_spotify_control(action)
                    local cmd = "spotify-control " .. action
                    vim.fn.jobstart(cmd, {
                        on_exit = function(job_id, code, event)
                            if code == 0 then
                                vim.notify("Spotify: " .. action .. " successful", vim.log.levels.INFO)
                            else
                                vim.notify("Spotify: " .. action .. " failed (code: " .. code .. ")", vim.log.levels.ERROR)
                            end
                        end,
                        stdout_buffered = true,
                        stderr_buffered = true,
                    })
                end

                function M.play_pause()
                    run_spotify_control("play-pause")
                end

                function M.next()
                    run_spotify_control("next")
                end

                function M.previous()
                    run_spotify_control("previous")
                end

                function M.volume_up()
                    run_spotify_control("volume-up")
                end

                function M.volume_down()
                    run_spotify_control("volume-down")
                end

                return M
                ```
    -   **Modified Step 2.2: Update Neovim keybindings in `nvim/.config/nvim/lua/plugins/keys.lua`.**
        -   **Files to modify**: `nvim/.config/nvim/lua/plugins/keys.lua`
        -   **Changes needed**:
            *   Require the new `core.spotify` module.
            *   Update the keybindings to call the Lua functions (e.g., `function() require("core.spotify").previous() end`).
            *   Ensure `silent` is used in the keybinding definition (this is handled by the Lua function's asynchronous nature).
            *   Example:
                ```lua
                { "<leader>an", function() require("core.spotify").previous() end, desc = "Spotify Prev" },
                { "<leader>ap", function() require("core.spotify").next() end, desc = "Spotify Next" },
                { "<leader>as", function() require("core.spotify").play_pause() end, desc = "Spotify Play Pause" },
                ```

3.  **Consolidate Tmux Spotify scripts and implement system notifications.**
    -   **Files to modify**:
        -   `tmux/.config/tmux/scripts/popup/spotify/spotify-action.sh` (new file, replaces multiple scripts)
        -   `tmux/.config/tmux/scripts/popup/spotify/play-pause.sh` (delete)
        -   `tmux/.config/tmux/scripts/popup/spotify/next.sh` (delete)
        -   `tmux/.config/tmux/scripts/popup/spotify/previous.sh` (delete)
        -   `tmux/.config/tmux/scripts/popup/spotify/volume-up.sh` (delete)
        -   `tmux/.config/tmux/scripts/popup/spotify/volume-down.sh` (delete)
    -   **Changes needed**:
        -   Create a single script `spotify-action.sh` that takes an action as an argument.
        -   Implement OS detection to send system notifications (macOS: `osascript`, Linux: `notify-send`) for success and error messages.
        -   Fallback to `tmux display-message` if no system notification tool is available.
        -   Example structure for `spotify-action.sh`:
            ```zsh
            #!/usr/bin/env zsh

            ACTION=$1
            MESSAGE=$2 # Optional message for notification

            # Function to send system notifications
            send_notification() {
                local title="Spotify"
                local message="$1"
                if [[ "$(uname)" == "Darwin" ]]; then
                    # macOS notification
                    osascript -e "display notification \"${message}\" with title \"${title}\""
                elif command -v notify-send &> /dev/null; then
                    # Linux notification (requires notify-send)
                    notify-send "${title}" "${message}"
                else
                    # Fallback to tmux display-message if no system notification tool
                    tmux display-message "${title}: ${message}"
                fi
            }

            # Check if spotify_player is installed
            if ! command -v spotify_player &> /dev/null; then
                send_notification "Error: spotify_player is not installed."
                exit 1
            fi

            # Execute spotify_player command and capture output
            OUTPUT=""
            ERROR_CODE=0
            case "$ACTION" in
                play-pause) OUTPUT=$(spotify_player playback play-pause 2>&1); ERROR_CODE=$? ;;
                next) OUTPUT=$(spotify_player playback next 2>&1); ERROR_CODE=$? ;;
                previous) OUTPUT=$(spotify_player playback previous 2>&1); ERROR_CODE=$? ;;
                volume-up) OUTPUT=$(spotify_player playback volume --offset 5 2>&1); ERROR_CODE=$? ;;
                volume-down) OUTPUT=$(spotify_player playback volume --offset -- -5 2>&1); ERROR_CODE=$? ;;
                *) send_notification "Unknown action: $ACTION"; exit 1 ;;
            esac

            if [[ $ERROR_CODE -eq 0 ]]; then
                send_notification "Action: ${ACTION} successful."
            else
                send_notification "Action: ${ACTION} failed. Error: ${OUTPUT}"
            fi
            ```
        -   Make the script executable: `chmod +x tmux/.config/tmux/scripts/popup/spotify/spotify-action.sh`.

4.  **Define new Tmux keybinding table and add keybindings.**
    -   **Files to modify**: `tmux/.tmux.conf.local`
    -   **Changes needed**:
        -   Add a new Tmux table, e.g., `spotify-controls`.
        -   Bind a key to enter this table, e.g., `bind C-e switch-client -T spotify-mode`.
        -   Example for `tmux/.tmux.conf.local`:
            ```tmux
            # Spotify Controls Table
            bind C-e switch-client -T spotify-mode

            bind -T spotify-mode p run-shell "~/.config/tmux/scripts/popup/spotify/spotify-action.sh previous"
            bind -T spotify-mode n run-shell "~/.config/tmux/scripts/popup/spotify/spotify-action.sh next"
            bind -T spotify-mode s run-shell "~/.config/tmux/scripts/popup/spotify/spotify-action.sh play-pause"
            bind -T spotify-mode u run-shell "~/.config/tmux/scripts/popup/spotify/spotify-action.sh volume-up"
            bind -T spotify-mode d run-shell "~/.config/tmux/scripts/popup/spotify/spotify-action.sh volume-down"
            bind -T spotify-mode q switch-client -T root # Exit table
            ```

5.  **Create and update Tmux help tables.**
    -   **Files to modify**:
        -   `tmux/.config/tmux/scripts/popup/help/tables/spotify-mode.txt` (new file)
        -   `tmux/.tmux.conf.local` (to add help binding)
    -   **Changes needed**:
        -   Create `spotify-mode.txt` with tab-separated values for Spotify keybindings.
            ```tsv
            Key	Description
            p	Previous Track
            n	Next Track
            s	Play/Pause Spotify
            u	Volume Up
            d	Volume Down
            q	Quit Spotify Controls
            ```
        -   Add a keybinding to `tmux/.tmux.conf.local` to display this help table, e.g., `bind -T spotify-mode ? run-shell "$HOME/.config/tmux/scripts/popup/help/help.sh spotify-mode"`.

### Testing Strategy
1.  **`spotify_player` installation verification**:
    -   Run `spotify_player --version` on both macOS and Linux to confirm installation.
    -   Run basic commands like `spotify_player playback play-pause` directly in the terminal to ensure functionality.
2.  **`bin/spotify-control` testing**:
    -   Execute `spotify-control play-pause`, `next`, `previous`, `volume-up`, `volume-down` directly on both macOS and Linux to verify cross-platform logic and command execution.
3.  **Neovim integration testing**:
    -   Open Neovim on both macOS and Linux.
    -   Press `<localleader>sp` (Spotify Previous), `<localleader>sn` (Spotify Next), `<localleader>ss` (Spotify Play/Pause), `<localleader>su` (Spotify Volume Up), and `<localleader>sd` (Spotify Volume Down) and observe if Spotify responds correctly.
    -   Verify `vim.notify` messages for success and errors.
4.  **Tmux integration testing**:
    -   Start a Tmux session on both macOS and Linux.
    -   Press `C-a C-e` to enter the Spotify controls table.
    -   Press `p` (Spotify Previous), `n` (Spotify Next), `s` (Spotify Play/Pause), `u` (Spotify Volume Up), and `d` (Spotify Volume Down) and observe Spotify behavior.
    -   Verify system notifications appear for both successful actions and any potential errors, instead of `tmux display-message`.
    -   Press `C-a C-e ?` to verify the help table is displayed correctly with the updated key assignments.

## 🎯 Success Criteria
- `spotify_player` is successfully installed and functional on both macOS and Linux.
- Neovim keybindings (`<localleader>sp`, `<localleader>sn`, `<localleader>ss`, `<localleader>su`, `<localleader>sd`) control Spotify correctly on both macOS and Linux, without hanging the UI.
- `vim.notify` messages are displayed for Spotify control actions in Neovim.
- A single `spotify-action.sh` script handles all Tmux Spotify control actions.
- Tmux keybindings within the Spotify table (`C-a C-e p`, `C-a C-e n`, `C-a C-e s`, `C-a C-e u`, `C-a C-e d`) control Spotify correctly on both macOS and Linux.
- System notifications are used for Tmux Spotify actions on macOS and Linux, with `tmux display-message` as a fallback.
- The Tmux help system (`C-a C-e ?`) displays the Spotify keybindings accurately.
- The solution is robust and handles cases where Spotify is not running or `spotify_player` is not available (graceful error messages).