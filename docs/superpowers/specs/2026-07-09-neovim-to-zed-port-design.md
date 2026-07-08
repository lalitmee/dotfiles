# Neovim → Zed Editor Keybinding & Workflow Port

Date: 2026-07-09

## Motivation

The Zed editor is already installed and configured in this dotfiles repository, but its current keybindings and settings only cover a thin subset of the Neovim workflow used daily. The goal is to port the most critical Vim motions, leader-driven commands, LSP/Git interactions, and extension-level configuration (snippets, tasks, LSP) from Neovim to Zed so that switching between the two editors is frictionless, while documenting the gaps that Zed cannot close.

## Scope

This is a **keybinding and settings port**, not a plugin rewrite. Zed's extension API is intentionally limited: it supports language servers, themes, slash commands, context servers, and debug adapters, but **not** custom UI panels, webviews, or arbitrary Neovim-style plugins. Therefore, the design maps behaviors to Zed built-in actions where possible, drops behaviors that are impossible, and explicitly lists every gap rather than pretending to close it.

## Wave 1: Core Vim Keybindings

### Normal-mode tweaks

| Key | Zed binding | Neovim equivalent | Notes |
|-----|-------------|-------------------|-------|
| `U` | `vim::Redo` | `redo` | Vim-style redo; Zed already exposes `vim::Redo` |
| `H` | `vim::StartOfLine` | `0` | Move to first column |
| `L` | `vim::EndOfLine` | `$` | Move to last column |
| `0` | `vim::FirstNonWhitespace` | `^` | First non-blank character |
| `^` | `vim::StartOfLine` | `0` | Swap with `0` |
| `n` | `vim::MoveToNextMatch` then `editor::ScrollCursorCenter` via `action::Sequence` | `nzz` | Repeat last search forward, center cursor |
| `N` (shift-n) | `vim::MoveToPreviousMatch` then `editor::ScrollCursorCenter` via `action::Sequence` | `Nzz` | Repeat last search backward, center cursor |
| `C-d` | `vim::ScrollDown` then `editor::ScrollCursorCenter` via `action::Sequence` | `C-d` | Center cursor after half-page down |
| `C-u` | `vim::ScrollUp` then `editor::ScrollCursorCenter` via `action::Sequence` | `C-u` | Center cursor after half-page up |
| `Backspace` | `pane::GoBack` | `C-^` | Jump to alternate buffer/file |

`n`/`N`, `C-d`/`C-u`, and `H`/`L` are bound under `VimControl && !menu` context (covers normal + visual mode). `U`, `0`, `^`, and `Backspace` use `vim_mode == normal && !menu`. `action::Sequence` was confirmed working by a user on the Zed community (discussion #9494, Nov 2025).

### Preserved (already in keymap.json)

| Key | Action |
|-----|--------|
| `jk` / `kj` | `vim::NormalBefore` in insert mode |
| `Enter` | `editor::ToggleFold` in normal mode |
| `Shift-y` | `vim::YankToEndOfLine` |
| `J` / `K` | Move selected lines up/down in visual mode |
| `H` / `L` | `0` / `$` in VimControl mode |

### Wave 1 gaps

These Neovim features have no direct Zed equivalent and are **not** in scope:

- Expression mappings (`<expr>`) and arbitrary Vim script conditions.
- Undo breakpoints (`C-g u`) in insert mode.
- `very magic` search (`\v`).
- `cgn` / `gV` / counted dot-repeat operations.
- Auto-indent on pressing `Enter` on an empty line (Zed handles this differently per language).

## Wave 2: Built-in Parity

### Leader prefix: `space` (normal mode)

#### LSP group: `space l`

| Key | Zed action | Neovim equivalent |
|-----|------------|-------------------|
| `space l d` | `editor::GoToDefinition` | `gd` |
| `space l D` | `editor::FindAllReferences` | `gD` |
| `space l r` | `editor::Rename` | `gr` |
| `space l n` | `editor::GoToDiagnostic` | next diagnostic |
| `space l h` | `editor::Hover` | `K` |
| `space l a` | `editor::ToggleCodeActions` | `gra` / `space c a` |
| `space l i` | `editor::GoToImplementation` | `gi` |
| `space l y` | `workspace::CopyPath` | copy relative file path |
| `space l f` | `editor::Format` | `conform.nvim` / `gq` |

#### Git group: `space g`

| Key | Zed action | Neovim equivalent |
|-----|------------|-------------------|
| `space g s` | `git_panel::ToggleFocus` | `Neogit` / `gitsigns` status |
| `g b` | `editor::BlameHover` | `gitsigns blame_line` |
| `g d` | `editor::GoToHunk` | `gitsigns next_hunk` |
| `g j` | `editor::GoToHunk` | next hunk |
| `g k` | `editor::GoToPrevHunk` | previous hunk |

`g b`, `g d`, `g j`, `g k` are bound in **normal mode without leader** to match gitsigns-style navigation.

#### Case conversion: `cr` operator

Zed has built-in case conversion actions. These map to the abolish/vim-text-case-style `cr` operator:

| Key | Zed action | Result |
|-----|------------|--------|
| `crs` | `editor::ConvertToSnakeCase` | `snake_case` |
| `crc` | `editor::ConvertToUpperCamelCase` | `UpperCamelCase` |
| `crm` | `editor::ConvertToLowerCamelCase` | `lowerCamelCase` |
| `cr-` | `editor::ConvertToKebabCase` | `kebab-case` |
| `cru` | `editor::ConvertToUpperCase` | `UPPER_CASE` |
| `cr.` | `editor::ConvertToTitleCase` | Title Case |
| `cro` | `editor::ConvertToOppositeCase` | opposite case |

Each binding is a `motion` operator that waits for a text-object selection (`iw`, `aw`, etc.) or visual selection.

#### Diagnostics

| Key | Zed action | Neovim equivalent |
|-----|------------|-------------------|
| `space e` | `diagnostics::Deploy` | `Trouble` / diagnostic float |

### Wave 2 gaps (not in scope)

| Feature | Reason |
|---------|--------|
| Leader `v` introspection group (vim binds, options) | Zed has no command-window / vim introspection |
| Project switcher (`space p` telescope variants) | Covered by `space space` / `space p f` / `space b l` |
| Telescope dropdowns (buffers, oldfiles, frecency, zoxide) | `tab_switcher` / `file_finder` / `recent` cover most cases |
| CodeCompanion inline chat | Use Zed `agent::Toggle` (`space c` already exists) |
| `grug-far.nvim` project-wide search/replace | Use `space /` and `space ?` built-in search |
| `oil.nvim` file manager | Use `project_panel` / `file_finder` |
| `lazygit` | Zed has its own `git_panel` |

## Wave 3: Extension Configuration

### Snippets

- Port static LuaSnip snippets from `nvim/.config/nvim/luasnippets/` to Zed JSON snippets in `zed/.config/zed/snippets/`.
- Drop any dynamic LuaSnip snippet that depends on a Lua function or Node.js evaluation (Zed snippets are static JSON only).
- Language coverage: `all`, `javascript`, `typescript`, `json`, `lua`, `markdown`, `sxhkdrc`.

### Tasks

- Create `zed/.config/zed/tasks.json` from the overseer templates in `nvim/.config/nvim/lua/overseer/template/`.
- Preserve templates for: `cpp` (build & run), `go`, `node`, `python`, `npm`, `yarn`, `rust`.
- Each task includes a `label`, `command`, `args`, `env`, `cwd`, and `reveal`/`hide` behavior matching the original overseer definitions as closely as Zed's task schema allows.

### LSP and language settings

- Port server-specific settings from `nvim/.config/nvim/lua/plugins/lsp/servers.lua` to Zed's `settings.json` under `lsp`.
- Servers: `clangd`, `gopls`, `lua_ls`, `rust-analyzer`.
- Add language-specific overrides for tab sizes, hard/soft tabs, and formatters, mirroring the current `after/ftplugin/` settings in Neovim.
- Keep `format_on_save` enabled globally, but allow per-language override where Neovim disables it.

### Wave 3 gaps

- Custom LuaSnip dynamic snippets (function-based expansions) are dropped.
- Complex overseer task conditions (e.g., "run only if Makefile exists") become separate Zed tasks or shell scripts.
- Non-standard LSP servers not supported by Zed's built-in extension list cannot be ported.

## File Changes

### Modified files

- `zed/.config/zed/keymap.json`
  - Add Wave 1 normal-mode Vim bindings.
  - Add Wave 2 leader LSP, Git, case-conversion, and diagnostics bindings.
  - Add Wave 3 snippet/task trigger keys where needed.
- `zed/.config/zed/settings.json`
  - Add `lsp` server configuration blocks.
  - Add language overrides for tab sizes, formatters, and `format_on_save`.

### New files

- `zed/.config/zed/snippets/all.json`
- `zed/.config/zed/snippets/javascript.json`
- `zed/.config/zed/snippets/typescript.json`
- `zed/.config/zed/snippets/json.json`
- `zed/.config/zed/snippets/lua.json`
- `zed/.config/zed/snippets/markdown.json`
- `zed/.config/zed/snippets/sxhkdrc.json`
- `zed/.config/zed/tasks.json`

### Documentation

- Update `zed/README.md` to list the new keybinding groups, known gaps, and how to extend snippets/tasks.

## Testing & Verification

1. After editing, run Zed's built-in keymap validation: Zed loads `keymap.json` and reports syntax errors on startup.
2. Smoke-test each wave:
   - Wave 1: open a file, verify `U`, `H`/`L`, `0`/`^`, `C-d`/`C-u`, `Backspace`.
   - Wave 2: verify LSP, Git, case-conversion, and diagnostics bindings with a real project.
   - Wave 3: verify snippets expand, tasks run, and LSP settings take effect.
3. Keep Neovim and Zed configs side-by-side for one week and add missing bindings to the Wave 2/3 gaps list.

## Open Questions

1. Should the Cobalt2 theme be ported as a Zed theme JSON file, or should the current Catppuccin Mocha theme remain as-is?
2. Should the `space c` CodeCompanion-equivalent binding be mapped to `agent::Toggle` or `agent::NewContext`?
3. Do we need a `tasks.json` for `justfile`/`makefile` tasks in addition to the overseer templates?

(End of file)
