local ok, catppuccin = lk.safe_require("catppuccin")
if not ok then
  return
end

catppuccin.setup({})

-- vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
vim.cmd([[colorscheme catppuccin]])
