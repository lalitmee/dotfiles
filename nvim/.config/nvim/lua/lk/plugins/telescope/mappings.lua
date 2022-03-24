local command = lk.command

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = "n"
  local rhs = string.format("<cmd>lua R('lk.plugins.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  local map_options = { noremap = true, silent = true }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

-- Dotfiles
map_tele("<leader>ofn", "edit_neovim")
map_tele("<leader>ofc", "edit_dotfiles")

-- Nvim
map_tele("<space>np", "installed_plugins")

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

----------------------------------------------------------------------
-- NOTE: telescope commands {{{
----------------------------------------------------------------------
command("LGrep", function()
  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ") })
end)
-- }}}
----------------------------------------------------------------------

return map_tele
