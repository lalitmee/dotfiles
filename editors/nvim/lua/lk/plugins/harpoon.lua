local map = lk_utils.map

require('harpoon').setup(
    {
      projects = {
        ['/home/lalitmee/data/Github/dotfiles'] = {
          term = { cmds = { 'gst\n' } }
        },
        ['/home/lalitmee/data/koinearth/wf-webapp-service'] = {
          term = { cmds = { 'gst\n' } }
        }
      }
    }
)

local opts = { noremap = true }

map('n', '<leader>dc', [[:lua require("harpoon.mark").clear_all()<CR>]], opts)
map('n', '<leader>df1', [[:lua require("harpoon.ui").nav_file(1)<CR>]], opts)
map('n', '<leader>df2', [[:lua require("harpoon.ui").nav_file(2)<CR>]], opts)
map('n', '<leader>df3', [[:lua require("harpoon.ui").nav_file(3)<CR>]], opts)
map('n', '<leader>df4', [[:lua require("harpoon.ui").nav_file(4)<CR>]], opts)
map('n', '<leader>df5', [[:lua require("harpoon.ui").nav_file(5)<CR>]], opts)
map('n', '<leader>df6', [[:lua require("harpoon.ui").nav_file(6)<CR>]], opts)
map('n', '<leader>dfa', [[:lua require("harpoon.mark").add_file()<CR>]], opts)
map('n', '<leader>dfr', [[:lua require("harpoon.mark").rm_file()<CR>]], opts)
map(
    'n', '<leader>dm', [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]],
    opts
)
map('n', '<leader>dp', [[:lua require("harpoon.mark").promote()<CR>]], opts)
map('n', '<leader>ds', [[:lua require("harpoon.mark").shorten_list()<CR>]], opts)
map(
    'n', '<leader>dtS', [[:lua require("harpoon.term").sendCommand(1, 2)<CR>]],
    opts
)
map(
    'n', '<leader>dtf', [[:lua require("harpoon.term").gotoTerminal(1)<CR>]],
    opts
)
map(
    'n', '<leader>dts', [[:lua require("harpoon.term").sendCommand(1, 1)<CR>]],
    opts
)
map(
    'n', '<leader>dtt', [[:lua require("harpoon.term").gotoTerminal(2)<CR>]],
    opts
)
