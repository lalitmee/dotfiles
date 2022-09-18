local ok, windows = lk.require("windows")
if not ok then
  return
end

-- settings for windows.nvim
vim.o.winwidth = 50
vim.o.winminwidth = 50
vim.o.equalalways = false

-- setup
windows.setup({
  autowidth = {
    winwidth = 50,
    filetype = {
      help = 100,
    },
  },
})
