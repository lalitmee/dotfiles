# Feature Implementation Plan: Fix Security Vulnerabilities

## 📋 Todo Checklist
- [✅] Remediate hardcoded `PLAYWRIGHT_MCP_EXTENSION_TOKEN`.
- [✅] Update vulnerable npm packages in Neovim plugins.
- [❌] Update vulnerable RubyGems package in the `neogit` plugin.
- [✅] Update Go installation to address standard library vulnerabilities.
- [✅] Ensure Persistence of Dependency Fixes.
- [⏩] Final Review and Testing.

## 🔍 Analysis & Investigation

### Codebase Structure
The user's dotfiles repository contains configurations for a variety of tools, with a significant portion dedicated to Neovim. The Neovim configuration uses `lazy.nvim` for plugin management, and the plugins are installed in `~/.local/share/nvim/lazy/`. Several of these plugins have their own dependencies managed by `npm`, `yarn`, `bundler`, or are built with `go`.

### Current Architecture
The architecture is a standard dotfiles repository. The security vulnerabilities are not in the user's own code, but in the third-party dependencies of the tools and plugins they use.

### Dependencies & Integration Points
- **Hardcoded Secret:** A token was hardcoded in `gemini-cli/.gemini/settings.json`. The user has attempted to fix this.
- **NPM Dependencies:** Several Neovim plugins use npm to manage their dependencies. The `scan_vulnerable_dependencies` tool found vulnerabilities in `markdown-preview.nvim`, `blink-ripgrep.nvim`, `blink.cmp`, `codecompanion.nvim`, and `mcphub.nvim`.
- **RubyGems Dependencies:** The `neogit` plugin uses RubyGems and has a vulnerability in the `rexml` gem. This step was skipped by the user.
- **Go Dependencies:** The `go.nvim` plugin has test and playground fixtures that use the Go standard library, which has several known vulnerabilities in the version used.

### Considerations & Challenges
- The large number of vulnerabilities, especially in `markdown-preview.nvim`, might require significant updates and could potentially introduce breaking changes.
- Updating the Go standard library requires updating the Go installation itself, which is outside the scope of this repository but is a necessary step for the user to take.
- The user needs to be careful when updating dependencies and should be prepared to handle potential breaking changes.
- **Persistence of Dependency Fixes:** Running `:Lazy update` will overwrite the dependency fixes. A mechanism to re-apply the fixes after each update is needed.

## 📝 Implementation Plan

### Prerequisites
- Ensure you have `npm`, `yarn`, `bundle`, and `go` installed on your system.
- Back up your `dotfiles` and Neovim configurations before starting.

### Step-by-Step Implementation

1.  **Step 1: Verify Hardcoded Secret Remediation**
    -   **Files to verify:** `gemini-cli/.gemini/settings.json` and your `zsh` configuration file (e.g., `~/.zshrc`).
    -   **Verification steps:**
        -   The file `gemini-cli/.gemini/settings.json` correctly uses the `$PLAYWRIGHT_MCP_EXTENSION_TOKEN` environment variable instead of a hardcoded token.
        -   **Action required by user:** Please open a new `zsh` terminal and run `echo $PLAYWRIGHT_MCP_EXTENSION_TOKEN`. This should print the value of the token, confirming it's loaded into your environment. Please confirm once this is done.

2.  **Step 2: Update Vulnerable NPM Packages**
    -   **For each of the following plugins:** `markdown-preview.nvim`, `blink-ripgrep.nvim`, `blink.cmp`, `codecompanion.nvim`, and `mcphub.nvim`:
        -   Navigate to the plugin's directory. For example: `cd /home/lalitmee/.local/share/nvim/lazy/markdown-preview.nvim`.
        -   Run `npm audit fix` or `yarn audit` (depending on the lockfile present) to automatically update the vulnerable dependencies.
        -   If there are remaining vulnerabilities, especially high or critical ones, you may need to manually update the affected packages by editing the `package.json` file and running `npm install` or `yarn install`.

3.  **Step 3: Update Vulnerable RubyGems Package**
    -   This step was skipped by the user.

4.  **Step 4: Update Go Installation**
    -   Your current Go version is `1.22.2`. While this is newer than the versions with known vulnerabilities, it is recommended to update to the latest stable version of Go to ensure all security patches are applied.
    -   Visit the official Go website (https://golang.org/dl/) to download and install the latest stable version of Go.
    -   Follow the installation instructions for your operating system.

5.  **Step 5: Ensure Persistence of Dependency Fixes**
    -   To ensure that the dependency fixes are not lost when you update your plugins with `lazy.nvim`, you need to add a `build` step to your Neovim configuration for each of the affected plugins.
    -   **Action required by user:** In your Neovim configuration, locate the setup for `lazy.nvim` and add the `build` option to the respective plugin specifications.
    -   **File to modify:** `nvim/.config/nvim/lua/plugins/coding.lua`
    -   **For `markdown-preview.nvim` (which uses `yarn`):**
        ```lua
        { --[[ markdown-preview ]]
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            build = "cd app && yarn install && yarn audit fix",
            ft = { "markdown" },
            keys = {
                { "<leader>am", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview", silent = true },
            },
            init = function()
                vim.g.mkdp_filetypes = { "markdown" }
            end,
        },
        ```
    -   **File to modify:** `nvim/.config/nvim/lua/plugins/editor.lua`
    -   **For `blink.cmp` and `blink-ripgrep.nvim`:**
        ```lua
        { -- [[ blink.cmp ]]
            "saghen/blink.cmp",
            event = { "InsertEnter", "CmdlineEnter" },
            dependencies = {
                "mikavilpas/blink-ripgrep.nvim",
                "Kaiser-Yang/blink-cmp-dictionary",
            },
            build = "npm install && npm audit fix",
            version = "*",
            ...
        },
        {
            "mikavilpas/blink-ripgrep.nvim",
            build = "pnpm install && pnpm audit",
        },
        ```
    -   **File to modify:** `nvim/.config/nvim/lua/plugins/ai/codecompanion/init.lua`
    -   **For `codecompanion.nvim`:**
        ```lua
        return {
            "olimorris/codecompanion.nvim",
            tag = "v17.33.0",
            build = "npm install --prefix doc && npm audit fix --prefix doc",
            ...
        }
        ```
    -   **File to modify:** `nvim/.config/nvim/lua/plugins/ai/misc.lua`
    -   **For `mcphub.nvim`:** This plugin installs globally, so we cannot add a build step here.

### Testing Strategy
-   After each step, launch Neovim and test the functionality of the updated plugin.
-   For the `npm` based plugins, check if they still load correctly and if their core features work.
-   For `neogit`, test its core functionality like `git status`, `git commit`, etc.
-   For the hardcoded secret, verify that the `gemini-cli` tool still works correctly after the change.
-   After updating Go, re-run the tests for the `go.nvim` plugin if it has any.
-   After adding the `build` steps to your `lazy.nvim` config, run `:Lazy sync` to trigger the build process and ensure it completes without errors.

## 🎯 Success Criteria
- The hardcoded token is removed from the configuration file and loaded from the environment.
- `npm audit`, `yarn audit` and `bundle audit` report no high or critical vulnerabilities for the Neovim plugins.
- The `go.nvim` plugin's tests pass with the updated Go version.
- All affected Neovim plugins and tools continue to function correctly after the updates.
- Dependency fixes are persistent across plugin updates.