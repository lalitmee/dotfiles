local nmap = lk.nmap

local map_opts = { noremap = true, silent = true }

----------------------------------------------------------------------
-- NOTE: options {{{
----------------------------------------------------------------------
vim.g.incsearch = { auto_nohlsearch = 1 }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
nmap("n", [[<Plug>(incsearch-nohl-n)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
nmap("N", [[<Plug>(incsearch-nohl-N)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
nmap("*", [[<Plug>(incsearch-nohl-*)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
nmap("#", [[<Plug>(incsearch-nohl-#)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
nmap("g*", [[<Plug>(incsearch-nohl-g*)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
nmap("g#", [[<Plug>(incsearch-nohl-g#)<Cmd>lua require('hlslens').start()<CR>]], map_opts)
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
