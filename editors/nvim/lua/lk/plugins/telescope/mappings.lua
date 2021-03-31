local map = lk_utils.map

if not pcall(require, 'telescope') then
  return
end

local sorters = require('telescope.sorters')

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = 'n'
  local rhs = string.format(
                  '<cmd>lua R(\'lk.plugins.telescope\')[\'%s\'](TelescopeMapArgs[\'%s\'])<CR>',
                  f, map_key
              )

  local map_options = { noremap = true, silent = true }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

vim.api.nvim_set_keymap(
    'c', '<c-r><c-r>', '<Plug>(TelescopeFuzzyCommandSearch)',
    { noremap = false, nowait = true }
)

-- lsp
map_tele('<localleader>lw', 'lsp_workspace_symbols')
map_tele('<localleader>ld', 'go_to_definition')

-- Dotfiles
map_tele('<leader>ofn', 'edit_neovim')
map_tele('<leader>ofc', 'edit_dotfiles')

-- Search
map_tele(
    '<space>osw', 'grep_string', {
      short_path = true,
      word_match = '-w',
      only_sort_text = true,
      -- layout_strategy = 'vertical',
      sorter = sorters.get_fzy_sorter()
    }
)
map_tele(
    '<space>osr', 'grep_last_search', {
      -- layout_strategy = 'vertical',
    }
)

-- -- Files
map_tele('<space>ofG', 'git_files')
map_tele('<space>osL', 'live_grep')
map_tele('<space>ofl', 'oldfiles')
map_tele('<space>ofD', 'fd')
map_tele('<space>pP', 'project_search')
map_tele('<space>ofE', 'file_browser')

-- -- Nvim
map_tele('<space>np', 'installed_plugins')
map_tele('<space>ofa', 'search_all_files')
map_tele('<space>obo', 'curbuf')
map_tele('<space>nh', 'help_tags')
map_tele('<space>osf', 'grep_prompt')

-- -- Telescope Meta
map_tele('<space>otB', 'builtin')

-- Change Background Wallpaper
map_tele('<space>otw', 'change_background')

-- NOTE: custom mappings
local opts = { noremap = true, silent = true }
-- Telescope key mappings {{{

map(
    'n', '<leader>obf',
    [[:lua require('telescope.builtin').buffers({ entry_maker = require('lk.plugins.telescope.my_make_entry').gen_from_buffer_like_leaderf() })<cr>]],
    opts
)
-- map('n', '<leader>ogc', [[:lua require('telescope_checkout.init').checkout{}<CR>]], opts)
map(
    'n', '<leader>ofd',
    [[:lua require('lk.plugins.telescope.finders').fd_files_dropdown()<cr>]],
    opts
)
map(
    'n', '<leader>ow',
    [[:lua require('telescope').extensions.fzf_writer.staged_grep{}<cr>]], opts
)
map(
    'n', '<leader>oa',
    [[:lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>]], opts
)
-- map('n', '<leader>ota', [[:lua require('config.telescope.customs').coc_list()<cr>]], opts)

-- }}}

vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal wrap]]

return map_tele
