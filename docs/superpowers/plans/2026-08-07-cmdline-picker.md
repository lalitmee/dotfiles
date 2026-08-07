# Cmdline Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give `<leader>:` a single fuzzy picker that combines command history and all `:commands` — run, re-run, or edit anything from the command line in a floating window.

**Architecture:** A new module `lua/plugins/snacks/picker/cmdline.lua` builds a static item list (history newest-first, then sorted command names) and opens it via `Snacks.picker.pick`. A `confirm` action runs the selected item with `pcall(vim.cmd, ...)`; custom actions bound in `win.input.keys`/`win.list.keys` run the raw prompt input (`<C-CR>`) or copy the selection into the prompt for editing (`<Tab>`). `keys.lua` re-points `<leader>:` at it.

**Tech Stack:** Neovim Lua, Snacks.nvim picker (installed version, commit 882c996; the config is the picker engine).

## Global Constraints

- Lua files: 4-space indent, double-quoted strings (repo `stylua.toml`).
- No unit-test framework in the repo; validate with `nvim --headless` smoke checks plus stylua.
- Configs are stowed/symlinked — edits take effect live; no install needed. Never run `./install.sh`.
- Do not auto-commit; the repo's AGENTS.md forbids committing unless the user explicitly asks (commit steps below are written for non-repo contexts — SKIP them here unless asked; the two files changed are committed as one `feat(nvim): ...` conventional commit when the user asks).
- The installed snacks API: custom actions go under `opts.actions.<name>` (resolved via `picker.opts.actions[action] or require("snacks.picker.actions")[action]`). `<opts.confirm>` is merged into `opts.actions.confirm` automatically. Pickers bind keys via `opts.win.input.keys` and `opts.win.list.keys`, where a value is an action spec like `{ "action_name", mode = { "i", "n" } }`. Available picker methods: `picker.input:get()`, `picker.input:set(text)`, `picker:current()` (current item table). `on_confirm` and `keymap` opts are NOT supported in this version.

---

### Task 1: Item source + runner module

**Files:**
- Create: `nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua`

**Interfaces:**
- Produces: `require("plugins.snacks.picker.cmdline")` with `M.run_cmd(str: string)` -> none (notifies on error), `M.get_items()` -> `snacks.picker.Item[]`, `M.cmdline()` -> opens the picker.

- [ ] **Step 1: Write the failing check**

Create `nvim/.config/nvim/tests/cmdline_smoke.lua`:

```lua
local m = require("plugins.snacks.picker.cmdline")
assert(type(m.get_items) == "function")
assert(type(m.run_cmd) == "function")
assert(type(m.cmdline) == "function")
local items = m.get_items()
assert(type(items) == "table")
assert(#items > 0, "expected at least one command")
local has = false
for _, it in ipairs(items) do
    if it.kind == "command" then
        has = true
        break
    end
end
assert(has, "expected at least one kind == 'command' item")
m.run_cmd("version")
print("OK cmdline_smoke")
```

- [ ] **Step 2: Run the check to see it fail**

Run: `nvim --headless -l nvim/.config/nvim/tests/cmdline_smoke.lua`
Expected: FAIL — "module 'plugins.snacks.picker.cmdline' not found" (runtimepath error) or `m.get_items` is nil.

- [ ] **Step 3: Create the module**

Create `nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua`:

```lua
local M = {}

function M.run_cmd(str)
    local ok, err = pcall(vim.cmd, str)
    if not ok then
        vim.notify(err, vim.log.levels.ERROR, { title = "Cmdline" })
    end
end

function M.get_items()
    local items = {}

    local count = vim.fn.histnr("cmd")
    for i = count, 1, -1 do
        local line = vim.fn.histget("cmd", i)
        if not line:find("^%s*$") then
            table.insert(items, {
                text = line,
                cmd = line,
                kind = "history",
                preview = { text = line, ft = "text" },
            })
        end
    end

    local commands = {}
    for k, v in pairs(vim.api.nvim_get_commands({})) do
        commands[k] = v
    end
    for k, v in pairs(vim.api.nvim_buf_get_commands(0, {})) do
        if type(k) == "string" then
            commands[k] = commands[k] or v
        end
    end
    for _, c in ipairs(vim.fn.getcompletion("", "command")) do
        if not commands[c] and c:find("^%l") then
            commands[c] = { definition = "command completion" }
        end
    end

    local names = {}
    for name in pairs(commands) do
        names[#names + 1] = name
    end
    table.sort(names)
    for _, name in ipairs(names) do
        table.insert(items, {
            text = name,
            cmd = name,
            kind = "command",
            desc = commands[name].definition,
            preview = { text = commands[name].definition, ft = "text" },
        })
    end

    return items
end

function M.cmdline()
    Snacks.picker.pick(M.get_items(), {
        prompt = "Cmdline (history + commands)",
        layout = { preset = "dropdown" },
        confirm = function(_, item)
            M.run_cmd(item.cmd or item.text)
        end,
        actions = {
            run_input = function(picker)
                M.run_cmd(picker.input:get())
            end,
            expand = function(picker)
                local item = picker:current()
                if item then
                    picker.input:set(item.cmd or item.text)
                end
            end,
        },
        win = {
            input = {
                keys = {
                    ["<c-cr>"] = { "run_input", mode = { "i", "n" } },
                    ["<tab>"] = { "expand", mode = "i" },
                },
            },
            list = {
                keys = {
                    ["<c-cr>"] = { "run_input", mode = { "n", "x" } },
                    ["<tab>"] = { "expand", mode = { "n", "x" } },
                },
            },
        },
    })
end

return M
```

- [ ] **Step 4: Put the module on the runtimepath and run the check**

Run: `nvim --headless --cmd "set rtp+=~/.config/nvim" -l nvim/.config/nvim/tests/cmdline_smoke.lua`
Expected: PASS — prints `cmdline_smoke`. (The default runtimepath already includes `~/.config/nvim`, so the require resolves through `<rtp>/lua/plugins/...`; the `--cmd rtp+=` is harmless belt-and-suspenders.)

- [ ] **Step 5: Stylua format check**

Run: `stylua --check nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua`
Expected: PASS (no output). Fix any formatting diffs with `stylua nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua`.

- [ ] **Step 6: Commit** — SKIPPED unless the user asks (AGENTS.md). When they do:
```bash
git add nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua nvim/.config/nvim/tests/cmdline_smoke.lua
git commit -m "feat(nvim): add combined history+commands cmdline picker"
```

**Task note:** `M.get_items()` calls `vim.cmd`-time APIs only; it runs eagerly (static list) — fine for the agreed CORE scope. Arg-completion etc. is deferred.

---

### Task 2 — Rebind `<leader>:`

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/snacks/picker/keys.lua:5`

**Interfaces:**
- Consumes: `M.cmdline()` from Task 1.
- Produces: nothing for other tasks.

- [ ] **Step 1: Read the current binding**

Read `nvim/.config/nvim/lua/plugins/snacks/picker/keys.lua` lines 1-12; confirm line 5 currently maps `<leader>:` to `Snacks.picker.commands()`.

- [ ] **Step 2: Edit the binding**

Replace the `<leader>:` entry so its action is `require("plugins.snacks.picker.cmdline").cmdline()`, keeping the surrounding entry style (function + `desc`), e.g.:

```lua
{ "<leader>:", function() require("plugins.snacks.picker.cmdline").cmdline() end, desc = "Cmdline (history + commands)", silent = true },
```

- [ ] **Step 3: Verify live**

Open nvim in the running config, run `:lua require("plugins.snacks.picker.cmdline").cmdline()`. Expected: picker opens with history entries first, then commands.
- `<CR>` on a command (e.g. `messages`) runs it.
- Type a new command like `e ~/.zshrc`, press `<C-CR>` — runs it from raw input.
- Move to a history line, press `<Tab>` — the prompt now contains that command for editing.
- X on a line — `<Esc>` closes the picker (global default).

- [ ] **Step 4: Commit** — SKIPPED unless the user asks. Then:
- Stage `nvim/.config/nvim/lua/plugins/snacks/picker/keys.lua` and Task-1 files; write `feat(nvim): add cmdline history+commands picker`.

## Self-review

- Spec coverage ✓ (combined list, `<CR>` run, `<C-CR>` raw input, `<Tab>` edit, single new file, one keybinding change).
- Placeholder scan ✓ (all steps carry concrete files, code, and commands).
- Type consistency: `run_cmd`/`get_items`/`cmdline` names agree across Task 1 and Task 2.