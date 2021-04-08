local map = lk_utils.map

require('harpoon').setup({
  projects = {
    ['/home/lalitmee/data/Github/dotfiles'] = { term = { cmds = { 'gst\n' } } },
    ['/home/lalitmee/data/koinearth/wf-webapp-service'] = {
      term = { cmds = { 'gst\n' } }
    }
  }
})

local opts = { noremap = true }

map('n', '<leader>dhc', [[:lua require("harpoon.mark").clear_all()<CR>]], opts)
map('n', '<leader>dhf1', [[:lua require("harpoon.ui").nav_file(1)<CR>]], opts)
map('n', '<leader>dhf2', [[:lua require("harpoon.ui").nav_file(2)<CR>]], opts)
map('n', '<leader>dhf3', [[:lua require("harpoon.ui").nav_file(3)<CR>]], opts)
map('n', '<leader>dhf4', [[:lua require("harpoon.ui").nav_file(4)<CR>]], opts)
map('n', '<leader>dhf5', [[:lua require("harpoon.ui").nav_file(5)<CR>]], opts)
map('n', '<leader>dhf6', [[:lua require("harpoon.ui").nav_file(6)<CR>]], opts)
map('n', '<leader>dhfa', [[:lua require("harpoon.mark").add_file()<CR>]], opts)
map('n', '<leader>dhfr', [[:lua require("harpoon.mark").rm_file()<CR>]], opts)
map('n', '<leader>dhm', [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]],
    opts)
map('n', '<leader>dhp', [[:lua require("harpoon.mark").promote()<CR>]], opts)
map('n', '<leader>dhs', [[:lua require("harpoon.mark").shorten_list()<CR>]],
    opts)
map('n', '<leader>dhtS', [[:lua require("harpoon.term").sendCommand(1, 2)<CR>]],
    opts)
map('n', '<leader>dhtf', [[:lua require("harpoon.term").gotoTerminal(1)<CR>]],
    opts)
map('n', '<leader>dhts', [[:lua require("harpoon.term").sendCommand(1, 1)<CR>]],
    opts)
map('n', '<leader>dhtt', [[:lua require("harpoon.term").gotoTerminal(2)<CR>]],
    opts)
