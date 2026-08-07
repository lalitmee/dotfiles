# Snacks.nvim Migration Evaluation

Date: 2026-07-29

## Context

Evaluating whether to replace several standalone Neovim plugins with equivalent modules from
[snacks.nvim](https://github.com/folke/snacks.nvim) (v2.31.0). The config already uses snacks
for: bigfile, notifier, quickfile, statuscolumn, words, scope, image, picker, gh, scratch,
bufdelete, git/gitbrowse/lazygit, debug, toggle, dim, rename.

## Modules Evaluated

### 1. Picker: snacks.picker vs telescope.nvim + 10 extensions

**Current setup:** telescope.nvim, fzf-lua, 10 extensions (frecency, zoxide, project, undo,
lazy, luasnip, import, helpgrep, smart-open, live-grep-args), 4 custom telescope extensions
(multi-ripgrep, messages, dotfiles, git_hunks), 80+ keymaps.

**snacks.picker pros:**
- Faster startup (lua-based, no native fzf dependency, async pipelines)
- 40+ built-in sources covering most telescope use cases
- Built-in git diffs with fancy diff renderer (v2.28+)
- GitHub integration (gh) — PRs, issues, reviews, diffs
- Layout system (vertical/horizontal/select per-source)
- Live filtering re-sorts results as you type
- LSP code actions browsable from picker
- Native `vim.ui.select` support
- Single plugin vs 14 separate declarations

**telescope pros:**
- Frecency is more mature (snacks has `smart` via sqlite but less refined)
- Larger extension ecosystem (textcase, specific niche extensions)
- Your custom extensions would need porting
- smart-open ML-based ranking has no direct snacks equivalent

**Assessment:** High-value migration. Most telescope extensions have built-in snacks
equivalents. Main gap: frecency maturity and custom extensions need porting.

---

### 2. Terminal: snacks.terminal vs toggleterm.nvim

**Current setup:** toggleterm.nvim with 7 custom named terminals (serpl, chatgpt, gh-dash,
lazygit, lazydocker, btm, tig), direction-based toggles, float handler logic.

**snacks.terminal pros:**
- Same API pattern (`Snacks.terminal(id)` vs `Terminal:new()`)
- Inherits snacks win system (borders, styles, animations)
- No separate plugin dependency

**toggleterm pros:**
- More mature terminal management
- 7 custom terminals with handlers would need porting
- `:ToggleTerm direction=horizontal` from cmdline is simpler

**Assessment:** Medium complexity migration. Lazydocker/btm/tig terminals map well to
snacks.terminal API. The float handler keymap cleanup logic needs porting.

---

### 3. Input: snacks.input vs dressing.nvim

**Current setup:** dressing.nvim with custom `insert_only`, `winblend`, `title_pos` config.

**snacks.input pros:**
- Author (stevearc) archived dressing and recommends snacks.input
- Purpose-built input + picker integration for `vim.ui.select`
- Inherits snacks style system

**Assessment:** Clear win. dressing is archived. Settings map directly.

---

### 4. Dashboard: snacks.dashboard

**Current setup:** No dashboard plugin.

**Assessment:** Clean addition. Startup screen with recent files, session restore.

---

### 5. Indent: snacks.indent

**Current setup:** No indent guide plugin.

**Assessment:** Clean addition. Indent guides, scope indicators. Minimal config.

---

### 6. Scroll: snacks.scroll (requires animate)

**Current setup:** No scroll animations. `scroll` currently disabled.

**Assessment:** Pure aesthetic add. Requires `snacks.animate` as dependency.

---

### 7. Zen: snacks.zen

**Current setup:** No zen/focus mode plugin.

**Assessment:** Clean addition. Full-screen focus mode, toggleable.

---

## Migration Impact

### Plugins that could be removed:
| Plugin | Replaced By |
|--------|------------|
| telescope.nvim + 10 extensions + fzf-lua | snacks.picker |
| toggleterm.nvim | snacks.terminal |
| dressing.nvim | snacks.input |
| fidget.nvim | Already replaced by snacks.notifier |

**Total: ~14 plugin declarations → 1 (snacks.nvim)**

### Additions (no removals):
- snacks.dashboard
- snacks.indent
- snacks.zen
- snacks.animate + snacks.scroll

---

## Open Questions

- Should custom telescope extensions (multi-ripgrep, messages, dotfiles, git_hunks) be
  ported to snacks picker sources, or rewritten as simpler alternatives?
- Should 7 custom toggleterm terminals be ported to snacks.terminal, or should toggleterm
  be kept just for these while migrating everything else?
- Is frecency important enough to keep telescope, or is snacks' `smart` source sufficient?
