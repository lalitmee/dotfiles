local ok, harpoon = lk.safe_require("harpoon")
if not ok then
  return
end

local command = lk.command

harpoon.setup({
  save_on_toggle = true,
  tmux_autoclose_windows = true,
})

----------------------------------------------------------------------
-- NOTE: load telescope extension {{{
----------------------------------------------------------------------
require("telescope").load_extension("harpoon")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: harpoon commands {{{
----------------------------------------------------------------------
command("HarpoonGotoFile1", function()
  require("harpoon.ui").nav_file(1)
end, {})

command("HarpoonGotoFile2", function()
  require("harpoon.ui").nav_file(2)
end, {})

command("HarpoonGotoFile3", function()
  require("harpoon.ui").nav_file(3)
end, {})

command("HarpoonGotoFile4", function()
  require("harpoon.ui").nav_file(4)
end, {})

command("HarpoonGotoFile5", function()
  require("harpoon.ui").nav_file(5)
end, {})

command("HarpoonGotoFile6", function()
  require("harpoon.ui").nav_file(6)
end, {})

command("HarpoonGotoFile7", function()
  require("harpoon.ui").nav_file(7)
end, {})

command("HarpoonGotoFile8", function()
  require("harpoon.ui").nav_file(8)
end, {})

command("HarpoonGotoFile9", function()
  require("harpoon.ui").nav_file(9)
end, {})

command("HarpoonGotoFile10", function()
  require("harpoon.ui").nav_file(10)
end, {})

command("HarpoonAddFile", function()
  require("harpoon.mark").add_file()
end, {})

command("HarpoonRemoveFile", function()
  require("harpoon.mark").rm_file()
end, {})

command("ToggleHarpoonMenu", function()
  require("harpoon.ui").toggle_quick_menu()
end, {})

command("HarpoonGotoTerm1", function()
  require("harpoon.term").gotoTerminal(1)
end, {})

command("HarpoonGotoTerm2", function()
  require("harpoon.term").gotoTerminal(2)
end, {})

command("HarpoonGotoTerm3", function()
  require("harpoon.term").gotoTerminal(3)
end, {})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker:foldlevel=0
