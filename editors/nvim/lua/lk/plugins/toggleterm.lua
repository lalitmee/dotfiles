require'toggleterm'.setup {
  size = 30,
  open_mapping = '<c-t>',
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = 'horizontal'
}

-- commands
vim.cmd [[command! -count=1 TermGitPushSet lua require'toggleterm'.exec("gpsup", <count>, 12)]]
vim.cmd [[command! -count=1 TermGitPush lua require'toggleterm'.exec("gp", <count>, 12)]]
vim.cmd [[command! -count=1 TermGitPushF lua require'toggleterm'.exec("gpf", <count>, 12)]]
