# tsgo LSP Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate the experimental Go-native TypeScript compiler/LSP (`tsgo`) into Neovim LSP configs, replacing `ts_ls`.

**Architecture:** Register `tsgo` dynamically using Neovim's native `vim.lsp.config` API, and toggle activation status in the `servers` table.

**Tech Stack:** Neovim 0.13, Lua, LSP

## Global Constraints

- Neovim version: v0.13.0-dev
- Keep both configurations but disable `ts_ls` manually by setting `ts_ls = false` in `servers.lua`.

---

### Task 1: Register Custom LSP Config for `tsgo` in `init.lua`

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/lsp/init.lua:207-210`

**Interfaces:**
- Consumes: None
- Produces: Registration of `tsgo` server config in `vim.lsp.config`

- [ ] **Step 1: Check syntax of original init.lua before making changes**

Run: `luac -p nvim/.config/nvim/lua/plugins/lsp/init.lua`
Expected: Exits with 0 (no syntax errors)

- [ ] **Step 2: Add `tsgo` config registration under `init.lua`**

Modify `nvim/.config/nvim/lua/plugins/lsp/init.lua` to add the `tsgo` config registration.

```lua
            vim.lsp.config("*", {
                root_markers = { ".git" },
            })

            vim.lsp.config("tsgo", {
                cmd = { "tsgo", "--lsp", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
                root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
            })
```

- [ ] **Step 3: Verify the syntax of the modified init.lua**

Run: `luac -p nvim/.config/nvim/lua/plugins/lsp/init.lua`
Expected: Exits with 0 (no syntax errors)

---

### Task 2: Configure Server Toggle in `servers.lua` and Validate Start-up

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/lsp/servers.lua:121-122`

**Interfaces:**
- Consumes: `tsgo` definition registered in `init.lua`
- Produces: Enabled `tsgo` config and disabled `ts_ls` config in `servers.lua`

- [ ] **Step 1: Disable `ts_ls` and enable `tsgo` in `servers.lua`**

Modify `nvim/.config/nvim/lua/plugins/lsp/servers.lua`:

```lua
    taplo = {},
    ts_ls = false,
    tsgo = {},
}
```

- [ ] **Step 2: Verify syntax of modified servers.lua**

Run: `luac -p nvim/.config/nvim/lua/plugins/lsp/servers.lua`
Expected: Exits with 0 (no syntax errors)

- [ ] **Step 3: Run Neovim in headless mode to verify configuration loads without runtime errors**

Run: `nvim --headless -c "qa"`
Expected: Exits with 0 (no warnings, errors, or tracebacks)
