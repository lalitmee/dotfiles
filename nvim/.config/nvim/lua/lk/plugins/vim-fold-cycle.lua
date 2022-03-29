local nmap = lk.nmap

-- diable default mappings
vim.g.fold_cycle_default_mapping = 0

nmap("<Tab><Tab>", "<Plug>(fold-cycle-open)", { silent = true })
nmap("<S-Tab><S-Tab>", "<Plug>(fold-cycle-close)", { silent = true })
