local opt = vim.opt_local

opt.colorcolumn = {}
opt.expandtab = true
opt.foldlevel = 99
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.iskeyword = opt.iskeyword + "-"
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.textwidth = 80

vim.cmd([[
  nnoremap <C-c> :TermExec cmd="g++ -std=c++11 % -Wall -g -o %.out && ./%.out"<CR>
]])
