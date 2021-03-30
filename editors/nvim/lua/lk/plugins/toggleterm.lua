require'toggleterm'.setup {
  size = 20,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = 'vertical'
}

-- commands
vim.cmd [[command! -count=1 TermGitPush lua require'toggleterm'.exec("git push", <count>, 12)]]
vim.cmd [[command! -count=1 TermGitPushF lua require'toggleterm'.exec("git push -f", <count>, 12)]]
