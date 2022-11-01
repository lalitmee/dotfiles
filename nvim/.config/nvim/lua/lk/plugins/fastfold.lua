local nmap = lk.nmap

vim.g.fastfold_minlines = 500

nmap("zuz", [[<Plug>(FastFoldUpdate)]])
