local command = lk.command

require("harpoon").setup({
  projects = {
    ["/home/lalitmee/Desktop/Github/dotfiles"] = {
      term = { cmds = { "gst\n" } },
    },
    ["/home/lalitmee/Desktop/koinearth/wf-webapp-service"] = {
      term = { cmds = { "gst\n" } },
    },
  },
})

----------------------------------------------------------------------
-- NOTE: harpoon commands {{{
----------------------------------------------------------------------

command({
  "HarpoonGotoFile1",
  function()
    require("harpoon.ui").nav_file(1)
  end,
})

command({
  "HarpoonGotoFile2",
  function()
    require("harpoon.ui").nav_file(2)
  end,
})

command({
  "HarpoonGotoFile3",
  function()
    require("harpoon.ui").nav_file(3)
  end,
})

command({
  "HarpoonGotoFile4",
  function()
    require("harpoon.ui").nav_file(4)
  end,
})

command({
  "HarpoonGotoFile5",
  function()
    require("harpoon.ui").nav_file(5)
  end,
})

command({
  "HarpoonGotoFile6",
  function()
    require("harpoon.ui").nav_file(6)
  end,
})

command({
  "HarpoonGotoFile7",
  function()
    require("harpoon.ui").nav_file(7)
  end,
})

command({
  "HarpoonGotoFile8",
  function()
    require("harpoon.ui").nav_file(8)
  end,
})

command({
  "HarpoonGotoFile9",
  function()
    require("harpoon.ui").nav_file(9)
  end,
})

command({
  "HarpoonGotoFile10",
  function()
    require("harpoon.ui").nav_file(10)
  end,
})

command({
  "HarpoonAddFile",
  function()
    require("harpoon.mark").add_file()
  end,
})

command({
  "HarpoonRemoveFile",
  function()
    require("harpoon.ui").rm_file()
  end,
})

command({
  "ToggleHarpoonMenu",
  function()
    require("harpoon.ui").toggle_quick_menu()
  end,
})

command({
  "HarpoonGotoTerm1",
  function()
    require("harpoon.term").gotoTerminal(1)
  end,
})

command({
  "HarpoonGotoTerm2",
  function()
    require("harpoon.term").gotoTerminal(2)
  end,
})

command({
  "HarpoonGotoTerm3",
  function()
    require("harpoon.term").gotoTerminal(3)
  end,
})

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker:foldlevel=0
