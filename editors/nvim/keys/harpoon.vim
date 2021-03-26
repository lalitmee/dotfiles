nnoremap <leader>dc :lua require("harpoon.mark").clear_all()<CR>
nnoremap <leader>df1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>df2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>df3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>df4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>df5 :lua require("harpoon.ui").nav_file(5)<CR>
nnoremap <leader>df6 :lua require("harpoon.ui").nav_file(6)<CR>
nnoremap <leader>dfa :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>dfr :lua require("harpoon.mark").rm_file()<CR>
nnoremap <leader>dm :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>dp :lua require("harpoon.mark").promote()<CR>
nnoremap <leader>ds :lua require("harpoon.mark").shorten_list()<CR>
nnoremap <leader>dtS :lua require("harpoon.term").sendCommand(1, 2)<CR>
nnoremap <leader>dtf :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>dts :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>dtt :lua require("harpoon.term").gotoTerminal(2)<CR>
