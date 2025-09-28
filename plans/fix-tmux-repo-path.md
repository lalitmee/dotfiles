# Implementation Plan: Fix Tmux REPOSITORY_PATH (Refined)

This refined plan addresses the issue of the `REPOSITORY_PATH` environment variable not being available to scripts run from tmux keybindings. It incorporates the feedback to make the solution more robust by passing the target path as an argument.

## Part 1: Centralize and Enhance the `update_repo_path` Function

The goal of this part is to move the `update_repo_path` function to a central location and modify it to accept a path argument. This makes the function more flexible and reliable.

1.  **Modify the `update_repo_path` function**: The function will be modified to accept an optional path argument. It will use `git -C <path>` to operate on the specified directory. If no argument is provided, it will default to the current directory, preserving the existing behavior for the interactive shell.

    The new function will be:
    ```zsh
    # Function to update the REPOSITORY_PATH variable based on a given path
    update_repo_path() {
      local path_to_check="${1:-.}" # Default to current directory if no argument

      # Check if the path is a git repository
      if git -C "$path_to_check" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # If in a repo, set the path to the top-level directory
        export REPOSITORY_PATH=$(git -C "$path_to_check" rev-parse --show-toplevel)
      else
        # If not in a repo, set to an empty string
        export REPOSITORY_PATH=""
      fi
    }
    ```

2.  **Move the function to `.zsh_functions`**: The old function in `zsh/.zshrc` will be replaced with this new, enhanced function, and the new function will be placed in `zsh/.zsh_functions`.

3.  **Ensure `.zshrc` is clean**: The `zsh/.zshrc` file should no longer contain a definition of `update_repo_path`. The `add-zsh-hook precmd update_repo_path` line will remain, as it will correctly call the function (with no arguments) for the interactive shell.

## Part 2: Update the `ai/tool.sh` Script

This part will modify the `ai/tool.sh` script to call the new function with the correct path.

1.  **Source the functions file**: A line will be added at the beginning of `tmux/.config/tmux/scripts/ai/tool.sh` to source the `~/.zsh_functions` file:

    ```zsh
    # Source shell functions
    if [[ -f ~/.zsh_functions ]]; then
        source ~/.zsh_functions
    fi
    ```

2.  **Call the update function with the correct path**: A line will be added to call `update_repo_path` with the path of the pane that triggered the script. The `#{pane_current_path}` tmux variable is perfect for this.

    ```zsh
    # Ensure REPOSITORY_PATH is set for the correct pane path
    update_repo_path "#{pane_current_path}"
    ```

This refined plan ensures that the `REPOSITORY_PATH` is always set correctly, whether in an interactive shell or when launching a tool from a tmux keybinding, regardless of the script's own working directory.