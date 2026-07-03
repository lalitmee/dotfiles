# Design Spec: Integrating tsgo LSP in Neovim

This document outlines the design for integrating the experimental Go-native TypeScript compiler/LSP (`tsgo`) into the existing Neovim LSP configurations in this dotfiles repository.

---

## 1. Context and Goals

The goal is to integrate `tsgo` (from Microsoft's high-performance Go port of TypeScript) as the primary language server for JavaScript and TypeScript, replacing the default Node.js-based `ts_ls`. 

Because `tsgo` is experimental and not yet built directly into `nvim-lspconfig`, we need to define it manually. To prevent conflicts and duplicate diagnostics, we also need a mechanism to toggle between `ts_ls` and `tsgo` easily.

---

## 2. Architecture and Configuration Changes

The integration is divided into two key components: custom server definition and server activation/toggling.

### 2.1. Custom Server Definition

We will register the `tsgo` configuration with Neovim's built-in LSP config mechanism inside `nvim/.config/nvim/lua/plugins/lsp/init.lua`.

```lua
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

This definition uses standard LSP parameters to run the server over standard input/output when one of the specified JavaScript or TypeScript filetypes is opened within a project root containing any of the standard markers.

### 2.2. Server Activation and Toggling

We will declare both servers in the list of configurations inside `nvim/.config/nvim/lua/plugins/lsp/servers.lua`. To prevent running both simultaneously, one must be set to `false`.

```lua
return {
    -- Existing configurations ...

    -- Disable standard typescript-language-server
    ts_ls = false,

    -- Enable experimental tsgo LSP
    tsgo = {},
}
```

The server loader loop in `init.lua` handles this structure natively, merging base configurations (capabilities, on_attach handlers, etc.) only if the config is not explicitly set to `false`.

---

## 3. Success Criteria

1. Verification that Neovim starts up cleanly without configuration errors.
2. Opening a TypeScript/JavaScript file starts the `tsgo` server automatically.
3. Verification that `ts_ls` is not started, avoiding duplicate LSP clients on the same buffer.
