local bookmarks = {
  "https://github.com/hoob3rt/lualine.nvim",
  "https://github.com/neovim/neovim",
  "https://neovim.discourse.group/",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/rockerBOO/awesome-neovim",
  "https://github.com/koinearth/B2BOrdersWorkflowServer",
  "https://github.com/lalitmee/dNotes",
  "https://github.com/lalitmee/dotfiles",
  "https://github.com/koinearth/marketsn-api-service",
  "https://github.com/koinearth/marketsn-pdf-service",
  "https://github.com/koinearth/marketsn-pwa-service",
  "https://github.com/koinearth/marketsn-webapp-service-nextjs",
  "https://material-ui.com/",
  "https://material-ui.com/components/material-icons/#material-icons",
  "https://github.com/pulls",
  "https://github.com/koinearth/wf-pwa-service",
  "https://github.com/koinearth/wf-webapp-service",
}

vim.keymap.set("n", "go", function()
  require("browse").browse({ bookmarks = bookmarks })
end)

vim.keymap.set("n", "gl", function()
  require("browse").open_bookmarks({ bookmarks = bookmarks })
end)

vim.keymap.set("n", "gx", function()
  require("browse").input_search()
end)
