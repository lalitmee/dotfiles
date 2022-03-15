require("workspaces").setup({
  hooks = {
    open = { "Telescope find_files" },
  },
})

require("telescope").load_extension("workspaces")
