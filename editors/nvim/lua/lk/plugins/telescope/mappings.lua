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

return map_tele
