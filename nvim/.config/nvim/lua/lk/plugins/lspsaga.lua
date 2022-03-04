-- lk.augroup("LspSagaAutoCmds", {
--   {
--     events = { "LspsagaHover" },
--     targets = { "FileType" },
--     command = "nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>",
--   },
-- })

vim.cmd([[
  augroup lspsaga_filetypes
    autocmd!
    autocmd FileType LspsagaHover nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>
  augroup END
]])
