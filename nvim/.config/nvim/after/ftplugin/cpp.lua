vim.cmd([[
  nnoremap <C-c> :TermExec cmd="g++ -std=c++11 % -Wall -g -o %.out && ./%.out"<CR>
]])
