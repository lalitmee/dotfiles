# Feature Implementation Plan: fix-neovim-autocommit-error (Validated)

## 📋 Todo Checklist
- [ ] Validate the proposed command syntax using the `context7` documentation tool.
- [ ] Implement the validated changes in `gitcommit.lua`.
- [ ] Test the auto-commit functionality to ensure the error is resolved.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The feature is implemented in a single Lua script: `nvim/.config/nvim/after/ftplugin/gitcommit.lua`. This script is executed when a `gitcommit` filetype is opened in Neovim. It automatically generates a commit message using the Gemini CLI (`gemini` or `gcli`) based on the staged changes (`git diff --cached`).

### Current Architecture & Refined Analysis
The script uses `vim.fn.jobstart` to asynchronously run an external shell command. The original command was `git diff --cached | gemini --prompt '...'`.

Based on your feedback and a closer look at the error message `Gemini CLI error: [API Error: Exiting due to an error processing the @ command.]` and the mention of `gcli prompt`, the initial hypothesis was incorrect. The use of a temporary file is a workaround, not the proper solution.

**Refined Hypothesis:**
The name `gcli prompt` strongly implies that `prompt` is a **subcommand**, not a flag. The original script was treating `--prompt` as a global flag for the `gemini` command, which is likely incorrect when piping data. The CLI was probably entering a default mode where it expected a prompt from a file, leading to the "Prompt file not found" error.

The correct invocation should use the `prompt` subcommand, likely followed by the `--prompt` flag to pass the inline prompt string.

## 📝 Implementation Plan

The solution is to modify the command in `gitcommit.lua` to use the correct `prompt` subcommand syntax. This avoids temporary files and aligns with what appears to be the intended usage of the CLI tool.

### Step 1: Validate the Command (User Action)
Before editing the file, please validate the proposed command structure. Since I cannot access your `context7` tool, I recommend you run the following (or a similar command) to get the relevant documentation:

```sh
context7 gemini-cli prompt
```

This should provide the documentation for the `prompt` subcommand. Please verify that it accepts a `--prompt` flag for an inline prompt string when receiving data from stdin.

### Step 2: Modify `gitcommit.lua`
- **File to modify:** `nvim/.config/nvim/after/ftplugin/gitcommit.lua`
- **Changes needed:** Once validated, update the `command` string to insert the `prompt` subcommand after `gemini`.

**Locate this line:**
```lua
local command = string.format("git diff --cached | gemini --prompt '%s'", config.prompt)
```

**Replace it with this new line:**
```lua
local command = string.format("git diff --cached | gemini prompt --prompt '%s'", config.prompt)
```
This change is minimal but critical: it correctly invokes the `prompt` subcommand, which should then correctly parse the `--prompt` flag containing the instructions for the model.

### Step 3: Testing Strategy
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
-   The solution uses a direct, one-line command validated against the tool's documentation.
