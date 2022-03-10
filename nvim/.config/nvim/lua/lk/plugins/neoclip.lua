require("neoclip").setup({
  enable_persistent_history = true,
  keys = {
    telescope = {
      i = { select = "<c-p>", paste = "<CR>", paste_behind = "<c-k>" },
      n = { select = "p", paste = "<CR>", paste_behind = "P" },
    },
  },
})
