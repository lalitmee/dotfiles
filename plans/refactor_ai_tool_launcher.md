# Feature Implementation Plan: Refactor AI Tool Launcher

## 📋 Todo Checklist
- [ ] Thoroughly analyze the script's execution flow and environment.
- [ ] Propose a simplified and robust script architecture.
- [ ] Implement the new, refactored `tool.sh` script.
- [ ] Verify all tool and layout combinations work as expected.
- [ ] Final Review and Testing.

## 🔍 Analysis & Investigation

### Root Cause Analysis

The previous fixes failed because they did not address the core problem. The key findings from a deeper analysis are:

1.  **The Role of `set -e`**: The script fails after removing `set -x` because `set -e` is active. This command causes a script to exit immediately if any command fails. This proves there is a command failing silently, and my previous attempts only masked this error instead of fixing it.

2.  **The Sub-Shell Environment Problem**: The most likely failing command is the one that actually tries to run the AI tool. The script uses a pattern like `tmux split-window "zsh -c '...complex command...'"`. This creates a new, non-interactive, non-login shell. Such shells **do not** inherit the full environment, `$PATH`, aliases, or functions from your user's configuration (`.zshrc`, etc.). This is the critical point. The fact that `opencode` fails is the smoking gun, as it is likely an alias, a function, or a command that relies on environment variables (like `NODE_PATH` or others) that are only set in a full login shell.

3.  **Overly Complex Logic**: The script has become too complex. It uses a fragile, multi-line quoted string (`FULL_COMMAND`) to define what to execute, and it contains duplicated, inconsistent logic for the `popup` case. This complexity makes it difficult to debug and is the source of the error.

### Proposed Improvements (as per user feedback)

-   **Speed and Efficiency**: The user noted that the "launching..." and "finished..." messages, along with the `sleep` and `read` commands, introduce delays. The proposed new architecture will be significantly faster by executing the tool command directly, eliminating these messages and pauses.
-   **Reliability**: By removing the nested shells and complex command strings, the new script will be far more reliable and easier to maintain.

### Files Inspected
- `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
- `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`

## 📝 Implementation Plan

The strategy is to **completely rewrite the `tool.sh` script** with a simpler, more direct, and more robust architecture. We will not patch the existing script.

### Prerequisites
- No new dependencies are required. This plan uses standard shell and tmux features.

### Step-by-Step Implementation

1.  **Step 1**: Overwrite the `tool.sh` script with the new, simplified logic.
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: The entire content of the file will be replaced with the following script. This new script is much shorter, contains no duplicated logic, and avoids the sub-shell environment issues entirely.

    ```bash
    #!/usr/bin/env zsh

    # A robust script to launch a specific AI CLI tool in a user-selected tmux layout.
    # It avoids nested shells and executes commands directly for speed and reliability.

    set -e

    # 1. Dependency & Argument Check
    # =================================
    if ! command -v fzf >/dev/null 2>&1; then
        tmux display-message "❌ Error: fzf is not installed."
        exit 1
    fi

    TOOL="$1"
    if [ -z "$TOOL" ]; then
        tmux display-message "❌ Usage: $0 <tool_name>"
        exit 1
    fi

    # 2. Tool Configuration
    # =======================
    # Define the command and title for each tool.
    # IMPORTANT: The command must be a direct executable or a full path.
    # Aliases will not work here unless sourced, but direct commands are preferred.
    case "$TOOL" in
        gemini)
            PANE_TITLE="🤖 Gemini"
            COMMAND="gemini"
            ;;
        opencode)
            PANE_TITLE="🧑‍💻 OpenCode"
            # This command sets an environment variable just for this process.
            COMMAND="NODE_TLS_REJECT_UNAUTHORIZED=0 opencode"
            ;;
        claude)
            PANE_TITLE="✨ Claude"
            COMMAND="claude"
            ;;
        codex)
            PANE_TITLE="🚀 Codex"
            COMMAND="codex"
            ;;
        qwen)
            PANE_TITLE="🧠 Qwen"
            COMMAND="qwen"
            ;;
        *)
            tmux display-message "❌ Error: Unknown AI tool '$TOOL'"
            exit 1
            ;;
    esac

    # 3. Layout Selection
    # =====================
    # The script is already in a popup. Use fzf to choose the final layout.
    FZF_HEADER="Choose layout for $PANE_TITLE:"
    MODE=$(echo -e "popup\nsplit\nwindow" | fzf --height=5 --header="$FZF_HEADER" --ansi)

    if [ -z "$MODE" ]; then
        # User pressed ESC, exit cleanly.
        exit 0
    fi

    # 4. Execution
    # ==============
    # Execute the chosen command in the selected layout.
    case "$MODE" in
        popup)
            # For popup mode, we are already in the popup.
            # Replace the current shell process with the tool's process.
            # This is extremely efficient. When the tool exits, the popup will close.
            exec $COMMAND
            ;;
        split)
            # Tell tmux to create a new split and run the command within it.
            # This inherits the correct user environment.
            tmux split-window -h -c "#{pane_current_path}" "$COMMAND"
            ;;
        window)
            # Tell tmux to create a new window and run the command within it.
            tmux new-window -n "$PANE_TITLE" -c "#{pane_current_path}" "$COMMAND"
            ;;
    esac
    ```

2.  **Step 2**: Verify `tmux.conf.local`
    -   **Files to modify**: None.
    -   **Changes needed**: No changes are required. The existing keybindings in `tmux/.tmux.conf.local` that call this script with the `-E` flag are now perfectly suited for the new `exec` logic in `popup` mode. When the tool (which has replaced the script) exits, the `-E` flag will correctly close the popup, ensuring no ghost processes.

### Testing Strategy

This new implementation must be tested thoroughly across all combinations.

1.  **`opencode` Test**: Press the keybinding for `opencode`. Select `popup`. It should now open correctly.
2.  **`gemini` Test**: Press the keybinding for `gemini`. Select `split`. It should open in a new horizontal split.
3.  **`claude` Test**: Press the keybinding for `claude`. Select `window`. It should open in a new tmux window named "✨ Claude".
4.  **Cancellation Test**: Press any keybinding, and when the `fzf` menu appears, press `ESC`. The popup should close cleanly.
5.  **Process Exit Test**: Launch any tool in any of the three layouts. When you are done, quit the tool using its native exit command (e.g., `Ctrl+C`, `:q`, etc.). The tmux pane, window, or popup should close cleanly or return you to a shell prompt without any extra messages.

## 🎯 Success Criteria

-   The user's desired workflow is fully restored and functional for all AI tools and all layout options.
-   The execution is noticeably faster due to the removal of `sleep` and `read` pauses.
-   The `tool.sh` script is simpler, more reliable, and easier to understand.
-   Closing an AI tool correctly closes the associated tmux pane/window/popup without leaving zombie processes.
