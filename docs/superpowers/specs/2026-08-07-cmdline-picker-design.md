# Cmdline Picker with Snacks.nvim

## Goal

Replicate the core of `telescope-cmdline.nvim` (jonarrien) using the existing
Snacks.nvim picker infrastructure: a single fuzzy picker that combines command
history and all `:commands`, allowing the user to run, edit, or re-run anything
from the command line in a floating window.

Not in scope: live argument completion after a space (getcompletion-based),
shell `!` commands via overseer, `%s/` substitute preview, line-number jump.
These can be added later by making the item source dynamic.

## Design

### Item source

A single combined list, newest-first:

- **History** entries from `vim.fn.histnr("cmd")` down to 1 via
  `vim.fn.histget("cmd", i)` (mirror of Snacks' own
  `source/vim.lua` `history()`). Empty lines skipped. Tagged
  `kind = "history"`.
- **Commands** from `vim.api.nvim_get_commands({})` merged with
  `vim.api.nvim_buf_get_commands(0, {})` and lowercase
  `vim.fn.getcompletion("", "command")` fallback (mirror of Snacks'
  `commands()`). Sorted by name. Tagged `kind = "command"` with
  `desc = definition`.

Item shape: `{ text = cmd, kind = ..., desc = ..., cmd = cmd, preview = { text = ..., ft = "text" } }`.

### Running commands

`run_cmd(str)` runs `pcall(vim.cmd, str)`. On error, show
`vim.notify(err, vim.log.levels.ERROR, { title = "Cmdline" })`. `vim.cmd`
handles `:...`, `/...`, `?...`, `!...`, `%s/...`, and bare line numbers.

### Picker

- New module `lua/plugins/snacks/picker/cmdline.lua`.
- `Snacks.picker.pick(items, opts)` with `on_confirm` running the selection
  (default `<CR>`), and custom keymap actions:
  - `<C-CR>` → run the raw prompt input (`picker.input:get()`)
  - `<Tab>` → copy the selected item's command into the prompt for editing
    (`picker.input:set(item.cmd)`)
- Preview shows the command definition for commands and the raw line for
  history rows.

### Keybinding

`<leader>:` in `lua/plugins/snacks/picker/keys.lua` switches from
`Snacks.picker.commands()` to the new combined picker. `<leader>v:` and
`<leader>vC` remain unchanged.

## Files

- New: `nvim/.config/nvim/lua/plugins/snacks/picker/cmdline.lua`
- Edit: `nvim/.config/nvim/lua/plugins/snacks/picker/keys.lua` (`<leader>:`)

## Error handling and testing

- All run errors surface via `vim.notify`; the picker never crashes.
- Validation: Stylua (repo `stylua.toml`), `nvim --headless` require of the new
  module, manual smoke test (open picker, `<CR>` runs a harmless command,
  `<Tab>` edits the selection, `<C-CR>` runs the raw input).