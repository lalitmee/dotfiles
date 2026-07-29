# Phase 2: Telescope → Snacks Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace telescope.nvim (plus 10 extensions, fzf-lua, 4 custom extensions, 4 custom commands, worktree picker) with snacks.picker. Refactor `plugins/snacks.lua` from a single 326-line file into a modular directory.

**Architecture:** `plugins/snacks.lua` → `plugins/snacks/` directory with focused files. Picker config/keys/sources get their own subfolder. 4 custom telescope extensions rewritten as inline snacks.picker sources. Worktree picker ported to snacks.picker API.

**Tech Stack:** snacks.nvim (already loaded), no new dependencies.

**Branch:** `snacks-migration` (continues from Phase 1 commits af1d2e14, 7512067b, 3eff1b22)

## File Structure (New)

```
plugins/snacks/
├── init.lua           # Main spec: lazy=false, priority=1000, composes sub-modules
├── opts.lua           # All opt config (scoped, bigfile, dashboard, indent, input,
│                      #   notifier, quickfile, statuscolumn, words, scroll, zen,
│                      #   animate, styles, image, gh, picker config)
├── keys_general.lua   # Non-picker keymaps (bufdelete, scratch, git, notifier,
│                      #   github issues/prs, neovim news, zen/zoom)
├── setup.lua          # Init logic: which-key groups, debug globals, oil rename,
│                      #   words jump, toggle mappings
├── picker/
│   ├── keys.lua       # All picker keymaps (~60 entries)
│   └── sources.lua    # Custom picker sources (ported telescope extensions +
│                      #   commands + wallpaper + git hunks)
```

## Global Constraints

- All keymaps preserve exact `<leader>` prefix and desc from telescope keymaps
- LSP keymaps (`gd`, `gr`, `gw`, etc.) stay on same keys
- fzf-lua's 3 LSP keymaps (`gD`, `gy`, `gz`) move to snacks.picker directly
- custom/telescope.lua fully deleted (not disabled)
- All `require("telescope")` calls outside `plugins/telescope/` removed
- `:checkhealth snacks` reports all modules OK after each task
- `luafile %` on changed files passes with no errors

---

### Task 1: Create modular snacks structure + port opts/keys/setup

**Files:**
- Create: `plugins/snacks/init.lua` — main spec, composes sub-modules
- Create: `plugins/snacks/opts.lua` — all opts from current snacks.lua
- Create: `plugins/snacks/keys_general.lua` — non-picker keymaps
- Create: `plugins/snacks/setup.lua` — init logic (toggles, debug, oil rename)
- Create: `plugins/snacks/picker/keys.lua` — picker keymaps
- Create: `plugins/snacks/picker/config.lua` — picker opts (rg args, sorting, layout, etc.)
- Create: `plugins/snacks/picker/sources.lua` — empty placeholder for Task 3
- Delete: `plugins/snacks.lua` — replaced by directory

**Interfaces:**
- Consumes: current `plugins/snacks.lua` content (326 lines)
- Produces: 7 files under `plugins/snacks/` with identical behavior

- [ ] **Step 1: Create `plugins/snacks/opts.lua`**

Copy the entire `opts = { ... }` table from snacks.lua into a standalone return. Include full picker config:

```lua
return {
    scope = { enabled = true },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { ... },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    scroll = { enabled = true },
    zen = { enabled = true },
    animate = { enabled = true },
    styles = { ... },
    image = { enabled = true },
    gh = { enabled = true },
    picker = {
        enabled = true,
        -- ripgrep args from custom/telescope.lua:vimgrep_arguments
        -- file_ignore_patterns
        -- sorting_strategy = "ascending"
        -- layout config (width, height, preview)
        -- win.input.keys: <Esc>, <c-s> flash
        -- win.list.keys: <c-t> trouble
        -- formatters.file.filename_first
        -- actions: trouble integration
    },
}
```

- [ ] **Step 2: Create `plugins/snacks/keys_general.lua`**

Copy all non-picker key entries from snacks.lua: bufdelete, git blame/browse/lazygit, notifier, scratch, github issues/prs, neovim news, zen/zoom.

- [ ] **Step 3: Create `plugins/snacks/setup.lua`**

Copy the `init` function content from snacks.lua: which-key scratch group, word jump mapping, oil rename autocmd, VeryLazy autocmd with debug globals and toggle mappings.

- [ ] **Step 4: Create `plugins/snacks/init.lua`**

```lua
local general_keys = require("plugins.snacks.keys_general")
local picker_keys = require("plugins.snacks.picker.keys")

local keys = {}
for _, k in ipairs(general_keys) do table.insert(keys, k) end
for _, k in ipairs(picker_keys) do table.insert(keys, k) end

require("plugins.snacks.picker.sources")

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = keys,
    opts = require("plugins.snacks.opts"),
    init = function()
        require("plugins.snacks.setup")
    end,
}
```

- [ ] **Step 5: Create `plugins/snacks/picker/config.lua`**

Picker-specific config file that's merged into opts:
```lua
return {
    enabled = true,
    -- ripgrep args (port from custom/telescope.lua defaults.vimgrep_arguments)
    -- file_ignore_patterns
    -- sorting_strategy = "ascending"
    -- layout options
    -- win.input.keys
    -- win.list.keys
    -- formatters
    -- actions
}
```

Note: this config is merged into the main opts table in `opts.lua` for simplicity.

- [ ] **Step 6: Create `plugins/snacks/picker/keys.lua`**

All picker keymaps (~60 entries organized by group):
```lua
return {
    -- search/file
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find", silent = true },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep", silent = true },
    { "<leader>ff", function() Snacks.picker.project_files() end, desc = "Project Files", silent = true },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files", silent = true },
    -- ... all 50+ keymaps
}
```

- [ ] **Step 7: Create empty `plugins/snacks/picker/sources.lua`**

```lua
return {} -- populated in Task 3
```

- [ ] **Step 8: Delete `plugins/snacks.lua`**

`rm nvim/.config/nvim/lua/plugins/snacks.lua`

- [ ] **Step 9: Run `luafile` on init.lua to verify no errors**

Open nvim with `nvim --headless -c "luafile plugins/snacks/init.lua" -c "q"` or just source in running nvim.

- [ ] **Step 10: Commit**

```bash
git add -A
git commit -m "feat(nvim): modularize snacks config into plugins/snacks/ directory"
```

---

### Task 2: Remove telescope + fzf-lua specs + custom/telescope.lua

**Files:**
- Delete: `plugins/telescope/` (entire directory — 6 files)
- Delete: `plugins/fzf-lua.lua`
- Delete: `custom/telescope.lua`

- [ ] **Step 1: Delete files**

```bash
rm -rf nvim/.config/nvim/lua/plugins/telescope/
rm nvim/.config/nvim/lua/plugins/fzf-lua.lua
rm nvim/.config/nvim/lua/custom/telescope.lua
```

- [ ] **Step 2: `:checkhealth snacks` inside nvim — verify no telescope load errors**

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat(nvim): remove telescope.nvim, fzf-lua, and custom/telescope.lua"
```

---

### Task 3: Port custom extensions + commands to picker/sources.lua

**Files:**
- Modify: `plugins/snacks/picker/sources.lua` — add ported extension + command functions
- Modify: `plugins/snacks/picker/keys.lua` — add keymaps for ported commands

**Interfaces:**
- Consumes: logic from `plugins/telescope/commands.lua` (250 lines), `plugins/telescope/finders.lua` (90 lines), `plugins/telescope/lens.lua` (70 lines)
- Produces: Snacks.picker-based equivalents in `sources.lua`

- [ ] **Step 1: Port TelescopeProjectFiles**

```lua
-- Check if inside git worktree, use git_files or find_files
-- Map to: <leader>ff (or replace current project_files mapping)
```

- [ ] **Step 2: Port TelescopeEditNeovim and TelescopeEditDotfiles**

```lua
-- Snacks.picker.files with cwd options
-- TelescopeEditNeovim → <leader>ne
-- TelescopeEditDotfiles → <leader>fd
```

- [ ] **Step 3: Port TelescopeFuzzyLiveGrep**

```lua
-- Use vim.ui.input + Snacks.picker.grep_word
-- Map to: <leader>sa
```

- [ ] **Step 4: Port multi-ripgrep extension**

```lua
-- Snacks.picker.grep with preset args
-- Map to: <leader>pm
```

- [ ] **Step 5: Port messages extension**

```lua
-- Read :messages into temp buffer, open picker on it
-- Or just redirect to :messages command
```

- [ ] **Step 6: Port wallpaper selector**

```lua
-- Snacks.picker.files with feh action
-- Map to: SetWallpaper command
```

- [ ] **Step 7: Port git hunks picker**

```lua
-- Custom picker using Snacks.picker API with git-jump
-- Map to: <leader>ghh, <leader>ghb
```

- [ ] **Step 8: Port live workspace symbols lens**

```lua
-- LSP workspace/symbol with input filter callback
```

- [ ] **Step 9: Add `require("plugins.snacks.picker.sources")` in init.lua** (already done)

- [ ] **Step 10: `luafile %` sources.lua to verify**

- [ ] **Step 11: Commit**

```bash
git add -A
git commit -m "feat(nvim): port custom telescope extensions to snacks.picker sources"
```

---

### Task 4: Remove telescope extension loads from other plugin specs

**Files:**
- Modify: `plugins/editor.lua:371` — yanky telescope extension load
- Modify: `plugins/tools.lua:450` — textcase telescope extension load
- Modify: `plugins/git/init.lua:190` — git_worktree telescope extension load

- [ ] **Step 1: editor.lua — remove yank_history extension load**

```lua
-- Before:
config = function(_, opts)
    require("yanky").setup(opts)
    require("telescope").load_extension("yank_history")  -- remove line
end,

-- After:
config = function(_, opts)
    require("yanky").setup(opts)
end,
```

- [ ] **Step 2: tools.lua — remove textcase extension load**

```lua
-- Before:
config = function()
    require("textcase").setup({})
    require("telescope").load_extension("textcase")  -- remove line
end,

-- After:
config = function()
    require("textcase").setup({})
end,
```

- [ ] **Step 3: git/init.lua — remove git_worktree extension load**

Remove `require("telescope").load_extension("git_worktree")` line.

- [ ] **Step 4: `luafile %` each changed file to verify syntax**

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat(nvim): remove telescope extension loads from plugin specs"
```

---

### Task 5: Update remaining references across codebase

**Files:**
- Modify: `plugins/lsp/utils.lua` — Telescope → Snacks.picker in `on_attach`
- Modify: `utils/reload.lua` — telescope.find_files → snacks.picker
- Modify: `plugins/tools.lua` — todo-comments Telescope → Snacks, http-codes dep
- Modify: `plugins/colors/init.lua` — remove `telescope = true` in catppuccin integrations
- Modify: `globals.lua` — remove telescope icon entries
- Modify: `utils/codicons.lua` — remove telescope entry
- Modify: `plugins/ai/codecompanion/init.lua:430` — picker "telescope" → "snacks"
- Modify: `plugins/tmux.lua:25` — picker "telescope" → "snacks"
- Modify: `plugins/editor.lua:358` — :Telescope yank_history → Snacks.picker.yank_history()
- Modify: `plugins/tools.lua:629-637` — TodoTelescope → Snacks.picker.todo_comments()

- [ ] **Step 1: lsp/utils.lua — replace all telescope + fzf-lua calls with snacks.picker**

Full replacement for the `on_attach` function:

```lua
-- All 10 telescope/fzf-lua LSP keymaps → Snacks.picker equivalents
nmap("gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go To Definition" })
nmap("ge", function() Snacks.picker.diagnostics({ buffer = 0 }) end, { desc = "Go To Diagnostics" })
nmap("gE", function() Snacks.picker.diagnostics() end, { desc = "Go To Workspace Diagnostics" })
nmap("gr", function() Snacks.picker.lsp_references() end, { desc = "Go To References" })
nmap("gw", function() Snacks.picker.lsp_symbols() end, { desc = "Go To Document Symbols" })
nmap("gW", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go To Workspace Symbols" })
nmap("ga", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go To Workspace Symbols" })
nmap("gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declarations" })
nmap("gy", function() Snacks.picker.lsp_typedefs() end, { desc = "Go to Type Definitions" })
nmap("gz", function() Snacks.picker.lsp_implementations() end, { desc = "Go To Implementations" })
```

- [ ] **Step 2: utils/reload.lua — convert telescope-based reloader to snacks.picker**

Replace the telescope `find_files` call with `Snacks.picker.files()` with custom attach_mappings for Ctrl+R to reload.

- [ ] **Step 3: tools.lua — update todo-comments**

Replace `TodoTelescope` commands with snacks.picker calls:
```lua
{ "<leader>qt", function() Snacks.picker.todo_comments() end, desc = "Todo" },
{ "<leader>qf", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX" } }) end, desc = "TODO/FIX Telescope" },
-- etc for all variants
```

- [ ] **Step 4: editor.lua — update yanky telescope keymap**

```lua
-- Before:
{ "<leader>ty", ":Telescope yank_history<CR>", desc = "Yank History" },
-- After:
{ "<leader>ty", function() Snacks.picker.yank_history() end, desc = "Yank History" },
```

- [ ] **Step 5: tools.lua — http-codes dependency update**

Remove `dependencies = "nvim-telescope/telescope.nvim"` line. Optionally change `opts.use` from "telescope" to snacks (if snacks supports it, otherwise leave as-is).

- [ ] **Step 6: colors/init.lua — remove telescope integration**

Remove `telescope = true,` from catppuccin setup.

- [ ] **Step 7: globals.lua — remove telescope icons**

Remove from `lk.style.icons.ui.Telescope` and `lk.style.icons.misc.telescope`.

- [ ] **Step 8: utils/codicons.lua — remove telescope entry**

Remove `["telescope"] = { icon = "", unicode = 0xEB68 }`.

- [ ] **Step 9: codecompanion/init.lua — update picker**

`picker = "telescope"` → `picker = "snacks"`

- [ ] **Step 10: tmux.lua — update picker** (already disabled, but update for consistency)

`picker = "telescope"` → `picker = "snacks"`

- [ ] **Step 11: `luafile %` each changed file to verify**

- [ ] **Step 12: Commit**

```bash
git add -A
git commit -m "feat(nvim): update remaining telescope references to snacks picker"
```

---

### Task 6: Port git worktree picker to snacks.picker

**Files:**
- Create: `plugins/git/worktree/picker.lua` — snacks-based worktree picker
- Delete: `plugins/git/worktree/telescope.lua` — old telescope-based picker
- Modify: `plugins/git/init.lua` — update requires

- [ ] **Step 1: Create `plugins/git/worktree/picker.lua`**

Port `create_worktree_picker` and `delete_worktree_picker` from telescope to snacks.picker. Use `Snacks.picker` with custom sources.

```lua
local M = {}

function M.create_worktree_picker()
    -- fetch branches via Job
    -- Snacks.picker.pick(items, { prompt = "Create Worktree", ... })
    -- on confirm: create worktree
end

function M.delete_worktree_picker()
    -- fetch worktrees via Job
    -- Snacks.picker.pick(items, { prompt = "Delete Worktree", ... })
    -- safe_delete on enter, force_delete on <c-d>
end

return M
```

- [ ] **Step 2: Update git/init.lua**

```lua
-- Before:
require("plugins.git.worktree.telescope").create_worktree_picker()
require("plugins.git.worktree.telescope").delete_worktree_picker()
require("telescope").load_extension("git_worktree")

-- After:
require("plugins.git.worktree.picker").create_worktree_picker()
require("plugins.git.worktree.picker").delete_worktree_picker()
```
Also remove or replace the `<leader>gwl` Telescope git_worktree keymap.

- [ ] **Step 3: Delete telescope.lua**

`rm nvim/.config/nvim/lua/plugins/git/worktree/telescope.lua`

- [ ] **Step 4: `luafile %` changed files to verify**

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat(nvim): port git worktree picker from telescope to snacks.picker"
```

---

### Task 7: Final cleanup and verification

- [ ] **Step 1: Grep for remaining telescope references**

```bash
rg -i "telescope" nvim/.config/nvim/lua/ | grep -v "github.com" | grep -v "telescope" | grep -v "comment"
```

Expected survivors: bookmark URLs in browse.nvim, dep strings in checkmate/http-codes that reference telescope URLs (not actual requires).

- [ ] **Step 2: `:checkhealth snacks` in nvim**

- [ ] **Step 3: `:Lazy` in nvim — verify no missing dependency errors**

- [ ] **Step 4: Spot-test picker operations:**

```vim
<leader>ff   " project files
<leader>/    " grep
gd           " LSP definitions
<leader>bb   " buffers
<leader>fo   " recent
<leader>ne   " neovim config
<leader>fd   " dotfiles
<leader>ghh  " git hunks
<leader>gwa  " create worktree
<leader>gwd  " delete worktree
```

- [ ] **Step 5: Fix any issues found**

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore(nvim): final cleanup after telescope removal"
```
