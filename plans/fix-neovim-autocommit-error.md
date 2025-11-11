# Feature Implementation Plan: fix-neovim-autocommit-error (Final)

## 📋 Todo Checklist
- [x] ✅ Implement the validated changes in `gitcommit.lua`.
- [ ] Test the auto-commit functionality to ensure the error is resolved.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The feature is implemented in a single Lua script: `nvim/.config/nvim/after/ftplugin/gitcommit.lua`. This script is executed when a `gitcommit` filetype is opened in Neovim. It automatically generates a commit message using the Gemini CLI (`gemini` or `gcli`) based on the staged changes (`git diff --cached`).

### Factual Validation
The `gemini-cli` documentation provides a clear example for how to pipe data to the `gemini` command while providing a prompt:

**Documentation Example:**
`cat README.md | gemini --prompt "Summarize this documentation"`

This confirms that `--prompt` is a global flag that accepts a string. The documented example uses double quotes (`"`). The most direct and fact-based approach is to modify the code to exactly match this syntax.

## 📝 Implementation Plan

The solution is to update the command string to use double quotes, as shown in the documentation, while using Lua's long string `[[]]` syntax for a cleaner implementation that avoids escaped quotes.

### Prerequisites
- None.

### Step-by-Step Implementation

1.  **Step 1: Modify `gitcommit.lua` to match the documented syntax.**
    -   **File to modify:** `nvim/.config/nvim/after/ftplugin/gitcommit.lua`
    -   **Changes needed:** Update the `command` string to use double quotes around the prompt argument, employing Lua's `[[]]` syntax to avoid escaping.

    **Locate this line:**
    ```lua
    local command = string.format("git diff --cached | gemini --prompt '%s'", config.prompt)
    ```

    **Replace it with this new line:**
    ```lua
    local command = string.format([[git diff --cached | gemini --prompt "%s"]], config.prompt)
    ```
    This change makes the generated command identical in structure to the one in the documentation, and it uses a cleaner, more readable Lua syntax.

### Testing Strategy
1.  Open your Neovim configuration and apply the change to `nvim/.config/nvim/after/ftplugin/gitcommit.lua`.
2.  Stage some changes in a git repository (`git add .`).
3.  Run `git commit` to open the `gitcommit` buffer in Neovim.
4.  Observe the notifications. The spinner should start, and then it should be replaced by a "✨ Commit message generated..." success message.
5.  **Verify that no "Gemini CLI error" notification appears.**
6.  Check that the commit message is correctly inserted into the buffer.

## 🎯 Success Criteria
-   The auto-commit feature works without displaying any errors in the Neovim notifications.
-   The spinner UI starts and stops correctly, providing clear feedback on the generation process.
-   The generated commit message is successfully inserted into the git commit buffer.
-   The solution uses a command structure that is an exact match of the official documentation and follows Lua best practices for string formatting.