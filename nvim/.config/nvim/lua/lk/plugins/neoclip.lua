require("neoclip").setup({
  enable_persistent_history = true,
  enable_macro_history = true,
  preview = true,
  keys = {
    telescope = {
      i = { select = "<c-p>", paste = "<CR>", paste_behind = "<c-s-p>" },
      n = { select = "p", paste = "<CR>", paste_behind = "P" },
    },
  },
})

require("telescope").load_extension("neoclip")
