if not pcall(require, 'telescope') then
  return
end

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = 'n'
  local rhs = string.format(
                  '<cmd>lua R(\'lk.plugins.telescope\')[\'%s\'](TelescopeMapArgs[\'%s\'])<CR>',
                  f, map_key)

  local map_options = { noremap = true, silent = true }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

vim.api.nvim_set_keymap('c', '<c-r><c-r>',
                        '<Plug>(TelescopeFuzzyCommandSearch)',
                        { noremap = false, nowait = true })

-- lsp
map_tele('<localleader>lw', 'lsp_workspace_symbols')

-- Dotfiles
map_tele('<leader>ofn', 'edit_neovim')
map_tele('<leader>ofc', 'edit_dotfiles')

-- Search
map_tele('<space>obo', 'curbuf')

-- -- Nvim
map_tele('<space>np', 'installed_plugins')
map_tele('<space>ofa', 'search_all_files')
map_tele('<space>ofi', 'fd')
map_tele('<space>ofl', 'find_files')
map_tele('<space>nh', 'help_tags')

-- Change Background Wallpaper
map_tele('<space>otw', 'change_background')

vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal wrap]]

return map_tele
