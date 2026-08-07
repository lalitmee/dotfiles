# Doom Emacs TypeScript Development Suite

Date: 2026-07-29

## Context

Configure Doom Emacs (GNU Emacs 29.3) to match or exceed the Neovim TypeScript/JavaScript/React/Angular development workflow. The existing Doom config at `~/.config/doom/` already has Evil mode, Magit, Org-mode with dual-brain setup, Corfu completion, Vertico/Consult navigation, and basic LSP. Gaps identified vs Neovim's TS workflow.

## Changes

### 1. LSP — Prefer tsgo

The Go-native TypeScript language server (`tsgo`) is already on the system. Emacs lsp-mode and Eglot both gained built-in tsgo support in late 2025. Set priority to prefer tsgo over the Node server.

```elisp
(setq lsp-client-priority '(:tsgo 1 :ts-ls 0))
```

### 2. Completion — Corfu (already enabled)

Stick with Corfu + Orderless. Already configured. No changes needed.

### 3. Formatting — apheleia (already enabled via `format +onsave`)

Point apheleia at `prettierd` and `eslint_d` (already installed via Mason). Doom's whitespace module (`+trim`) handles trailing whitespace.

### 4. Debugger — dape

Dape is a modern, lightweight DAP client for Emacs. Configure with `js-debug-adapter` for Node/Chrome debugging.

```elisp
(package! dape)
```

### 5. AI Chat — gptel

Universal LLM client supporting OpenAI, Anthropic, Ollama, Gemini. Replaces CodeCompanion for chat and inline AI operations.

```elisp
(package! gptel)
```

### 6. AI Completions — Copilot

Doom's built-in `:editor copilot` module. Zero extra setup.

### 7. Task Runner — compile + projectile

Built-in Emacs `compile` + Doom/projectile `SPC p !` for shell commands. Covers npm/yarn scripts, build, test, lint. Vterm for persistent processes.

### 8. Testing — compile / vterm

Same as task runner. No dedicated test framework package needed.

### 9. Navigation — consult + vertico + avy

Already configured. Avy replaces flash.nvim's basic jumping.

### 10. Snippets — yasnippet

Port existing luasnippets to yasnippet `.yasnippet` format:

| Source File | Target | Snippets |
|---|---|---|
| `javascript.lua` | `js-ts-mode/` | `de`, `clg`, `log`, `ptd`, `imr`, `rfc`, `useS`, `useE`, `usest`, `mocks`, `imrt`, `tid`, `befo`, `bfa`, `cst` |
| `typescript.lua` | `typescript-ts-mode/` | Same as JS + `int`, `hook`, `atom` |
| `typescriptreact.lua` | `tsx-ts-mode/` | Same as JS + `int` |
| `javascriptreact.lua` | `js-ts-mode/` | Same as JS |
| `all.lua` | `prog-mode/` | `td`, `hr`, `cbox`, `fdm` |
| Auto-snippets | all TS modes | `ff\d{4}` → TODO comment |

### 11. Snippet Directory Structure

```
~/.config/doom/snippets/
├── js-ts-mode/
│   ├── de
│   ├── clg
│   ├── log
│   └── ...
├── typescript-ts-mode/
│   ├── de
│   ├── int
│   ├── hook
│   └── ...
├── tsx-ts-mode/
│   └── ...
└── prog-mode/
    ├── td
    ├── hr
    ├── cbox
    └── fdm
```

### 12. Files Modified

| File | Change |
|---|---|
| `init.el` | Enable `:editor copilot`, `:tools debugger` |
| `packages.el` | Add `dape`, `gptel` |
| `config.el` | tsgo priority, dape setup, gptel setup, formatting config, keybindings |
| `snippets/` | 25+ yasnippet files |

## Key Workflows

| Action | Keybind | Provider |
|---|---|---|
| Go-to-def | `SPC c d` | lsp-mode (tsgo) |
| Find refs | `SPC c r` | lsp-mode |
| Rename | `SPC c R` | lsp-mode |
| Code actions | `SPC c a` | lsp-mode |
| Hover | `SPC c h` | lsp-mode |
| Format | on-save | apheleia (prettierd) |
| Debug | `SPC d d` | dape |
| AI chat | gptel keybind | gptel |
| AI complete | inline | copilot |
| Run command | `SPC p !` | projectile |
| Jump | `SPC j j` | avy |
| Find file | `SPC .` | consult |
| Search proj | `SPC s p` | consult-ripgrep |
| Git | `SPC g` | magit |
| Terminal | `SPC o t` | vterm |

## Verdict

Doom Emacs can match and partially exceed Neovim for TS development. Areas where Emacs is stronger: Magit (better than Neogit), org-mode (native vs ported), built-in compiler support. All Neovim TS workflow gaps are covered with the changes above.
