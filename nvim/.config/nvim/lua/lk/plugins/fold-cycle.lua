local ok, fold_cycle = lk.safe_require("fold-cycle")

if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
fold_cycle.setup()
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local command = lk.command

command("FoldOpen", function()
  fold_cycle.open()
end)

command("FoldClose", function()
  fold_cycle.close()
end)

command("FoldOpenAll", function()
  fold_cycle.open_all()
end)

command("FoldCloseAll", function()
  fold_cycle.close_all()
end)

command("FoldToggleAll", function()
  fold_cycle.toggle_all()
end)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local nmap = lk.nmap

nmap("<Tab>", "<cmd>FoldOpen<cr>", { silent = true })
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
