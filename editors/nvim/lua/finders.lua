-- in lua/finders.lua
local finders = {}

-- Dropdown list theme using a builtin theme definitions :
local center_list = require'telescope.themes'.get_dropdown({
  winblend = 10,
  width = 0.5,
  prompt = " ",
  results_height = 15,
  previewer = false,
})

-- Settings for with preview option
local with_preview = {
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false,
  layout_config = {
    preview_width = 0.5,
  },
}

-- Find in neovim config with center theme
finders.fd_in_nvim = function()
  local opts = vim.deepcopy(center_list)
  opts.prompt_prefix = 'Nvim>'
  opts.cwd = vim.fn.stdpath("config")
  require'telescope.builtin'.fd(opts)
end

-- Find files with_preview settings
function fd()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = 'FD>'
  require'telescope.builtin'.fd(opts)
end

return finders

-- make sure to map it:
-- nnoremap <leader>ff :lua require'finders'.fd_in_nvim()<cr>
-- nnoremap <leader>ff :lua require'finders'.fd()<cr>

---------------------------------------------------------------------------
---------------------------------------------------------------------------

--local center_list  -- check the above snippet
--local with_preview -- check the above snippet
--local main = {}
--local telescopes = {
--  fd_nvim = {
--    prompt_prefix = 'Nvim>',
--    fun = "fd",
--    theme = center_list,
--    cwd = vim.fn.stdpath("config")
--    -- .. other options
--  }
--  fd = {
--    prompt_prefix = 'Files>',
--    fun = "fd",
--    theme = with_preview,
--    -- .. other options
--  }
--}

--main.run = function(str, theme)
--  local base, fun, opts
--  if not telescopes[str] then
--    fun = str
--    opts = theme or {}
--    --return print("Sorry not found")
--  else
--    base = telescopes[str]
--    fun = base.fun; theme = base.theme
--    base.theme = nil; base.fun = nil
--    opts = vim.tbl_extend("force", theme, base)
--  end
--  if str then
--    return require'telescope.builtin'[fun](opts)
--  else
--    return print("You need to a set a default function")
--    -- return require'telescope.builtin'.find_files(opts)
--  end
--end

--return main

-- make sure to map it:
-- nnoremap <leader>ff :lua require'main'.run('fd')<cr>
-- nnoremap <leader>ff :lua require'main'.run('fd_in_nvim')<cr>

