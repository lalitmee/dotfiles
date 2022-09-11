-- ╭──────────────────────────────────────────────────────────╮
-- │           https://github.com/lalitmee/dotfiles           │
-- │                 Created By: Lalit Kumar                  │
-- ╰──────────────────────────────────────────────────────────╯

-- impatient
pcall(require, "impatient")
pcall(function()
  require("impatient").enable_profile()
end)

-- install packer if not installed
if require("lk/first_load")() then
  return
end

----------------------------------------------------------------------
-- NOTE: leaders {{{
----------------------------------------------------------------------
-- mapping leader and localleader keys
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " " -- NOTE: leader is `<space>`
vim.g.maplocalleader = "," -- NOTE: local leader is ,
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing {{{
----------------------------------------------------------------------
local ok, reload = pcall(require, "plenary.reload")
RELOAD = ok and reload.reload_module or function(...)
  return ...
end
function R(name)
  RELOAD(name)
  return require(name)
end

-- packer plugins
R("plugins")

-- globals
R("lk/globals")

-- core
R("lk/core")

-- disable builtin
R("lk/disable_builtin")

-- pakcer_compliled
R("packer_compiled")
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
