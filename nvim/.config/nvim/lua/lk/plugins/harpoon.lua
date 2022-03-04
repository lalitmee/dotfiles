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
  "HarpoonGoToFile1",
  function()
    require("harpoon.ui").nav_file(1)
  end,
})

command({
  "HarpoonGoToFile2",
  function()
    require("harpoon.ui").nav_file(2)
  end,
})

command({
  "HarpoonGoToFile3",
  function()
    require("harpoon.ui").nav_file(3)
  end,
})

command({
  "HarpoonGoToFile4",
  function()
    require("harpoon.ui").nav_file(4)
  end,
})

command({
  "HarpoonGoToFile5",
  function()
    require("harpoon.ui").nav_file(5)
  end,
})

command({
  "HarpoonGoToFile6",
  function()
    require("harpoon.ui").nav_file(6)
  end,
})

command({
  "HarpoonGoToFile7",
  function()
    require("harpoon.ui").nav_file(7)
  end,
})

command({
  "HarpoonGoToFile8",
  function()
    require("harpoon.ui").nav_file(8)
  end,
})

command({
  "HarpoonGoToFile9",
  function()
    require("harpoon.ui").nav_file(9)
  end,
})

command({
  "HarpoonGoToFile10",
  function()
    require("harpoon.ui").nav_file(10)
  end,
})

command({
  "HarpoonAddFile",
  function()
    require("harpoon.ui").add_file()
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

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker:foldlevel=0
