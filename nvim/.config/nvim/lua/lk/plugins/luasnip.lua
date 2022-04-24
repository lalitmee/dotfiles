local ls = require("luasnip")
local types = require("luasnip.util.types")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config({
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  updateevents = "TextChanged,TextChangedI",

  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        hl_mode = "combine",
        virt_text = { { "● ", "Error" } },
      },
    },
    [types.insertNode] = {
      active = {
        hl_mode = "combine",
        virt_text = { { "● ", "WarningMsg" } },
      },
    },
  },
  snip_env = {
    fmt = fmt,
    m = extras.match,
    r = extras.rep,
    t = ls.text_node,
    f = ls.function_node,
    c = ls.choice_node,
    d = ls.dynamic_node,
    i = ls.insert_node,
    snippet = ls.snippet,
  },
})

----------------------------------------------------------------------
-- NOTE: loading snippets {{{
----------------------------------------------------------------------
-- NOTE: snippets from extension and from `snippet` dir
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
ls.filetype_extend("all", { "_" })

-- NOTE: custom snippets created in `lua` format
require("luasnip.loaders.from_lua").lazy_load()
lk.command("LuaSnipEdit", function()
  require("luasnip.loaders.from_lua").edit_snippet_files()
end)
-- }}}
----------------------------------------------------------------------

-- <c-j> is my forward key
-- this will jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, { silent = true })

-- <c-k> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-y> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-y>", function()
  if ls.expandable() then
    ls.expand()
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
