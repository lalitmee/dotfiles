# Feature Implementation Plan: Optimize and Fix AI Tool Launcher

## 📋 Todo Checklist
- [ ] Analyze root cause of fzf delay and popup execution failure.
- [ ] Optimize the shell invocation in `tmux.conf.local` to reduce delay.
- [ ] Correct the command execution logic for `popup` mode in `tool.sh`.
- [ ] Final Review and Testing.

## 🔍 Analysis & Investigation

Based on the user's report, there are two distinct issues. I have analyzed the current implementation to determine the root cause of each.

### Issue 1: Delay Before FZF Appears

-   **Symptom**: After the tmux popup appears, there is a noticeable delay before the `fzf` layout selection menu is displayed.
-   **Root Cause**: The keybindings in `tmux/.tmux.conf.local` invoke the script using `zsh -lic`. The `-l` flag makes it a **login shell**. This forces `zsh` to source all of its startup files (e.g., `.zprofile`, `.zshrc`), which can include slow operations like checking for updates, initializing version managers (nvm, pyenv), etc. This entire initialization process must complete before the `tool.sh` script even begins to execute, causing the observed delay.
-   **Solution**: By removing the `-l` (login) flag and using only `zsh -ic`, we can significantly speed up the startup. An interactive shell (`-i`) is usually sufficient to load the necessary environment variables and `$PATH` without the overhead of a full login process.

### Issue 2: `popup` Option Fails

-   **Symptom**: When `popup` is selected from the `fzf` menu, the popup immediately closes instead of executing the tool.
-   **Root Cause**: The `popup` case in `tool.sh` uses the command `exec $COMMAND`. When the `$COMMAND` variable contains a string with shell syntax, such as an environment variable assignment (`NODE_TLS_REJECT_UNAUTHORIZED=0 opencode`), the `exec` command does not parse it correctly. The shell interprets `NODE_TLS_REJECT_UNAUTHORIZED=0` as the command to be executed and `opencode` as its argument, which is invalid and causes an error. Because `set -e` is active, this error causes the script to exit instantly. The `-E` flag on the `display-popup` then correctly closes the popup because its child process has terminated.
-   **Solution**: The command string must be properly evaluated by the shell *before* `exec` runs it. The correct way to do this is with `eval exec "$COMMAND"`. The `eval` command will first process the string, correctly handling the environment variable assignment, and then `exec` will replace the shell with the resulting, valid command.

### Files Inspected
- `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
- `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`

## 📝 Implementation Plan

### Prerequisites
- The previous refactoring of `tool.sh` is the baseline for these changes.

### Step-by-Step Implementation

1.  **Step 1**: Optimize Shell Invocation to Reduce Delay
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`
    -   **Changes needed**: Perform a search-and-replace to change all occurrences of the `tool.sh` invocation.
        -   **Search for**: `zsh -lic '~/.config/tmux/scripts/ai/tool.sh`
        -   **Replace with**: `zsh -ic '~/.config/tmux/scripts/ai/tool.sh`
    -   **Justification**: This removes the slow login shell initialization, which should make the `fzf` menu appear almost instantly.

2.  **Step 2**: Fix `popup` Mode Command Execution
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: In the final `case "$MODE"` statement, locate the `popup` case and modify the `exec` line.
        -   **Search for**: `exec $COMMAND`
        -   **Replace with**: `eval exec "$COMMAND"`
    -   **Justification**: `eval` will correctly parse the command string, allowing `exec` to run commands that include environment variable assignments, fixing the bug for `opencode` and other similar tools.

### Testing Strategy

1.  **Delay Test**: Press any of the AI tool keybindings. The `fzf` layout menu should now appear significantly faster, with minimal delay after the popup opens.
2.  **`opencode` Popup Test**: Press the keybinding for `opencode` and select `popup`. The tool should now launch correctly within the popup.
3.  **Standard Popup Test**: Press the keybinding for `gemini` (a command without special syntax) and select `popup`. This should continue to work correctly.
4.  **Regression Test**: Quickly test the `split` and `window` options for any tool to ensure they were not negatively affected by the changes.

## 🎯 Success Criteria

-   The delay between the popup opening and `fzf` appearing is eliminated or drastically reduced.
-   The `popup` layout option works correctly for all configured AI tools, including `opencode`.
-   The `split` and `window` layout options continue to work correctly.
-   The overall user experience is faster and more reliable.
