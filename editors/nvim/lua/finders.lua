-- in lua/finders.lua
local finders = {}

-- copied from https://github.com/nvim-telescope/telescope.nvim/wiki/Gallery
local dropdown_theme = require('telescope.themes').get_dropdown({
  results_height = 20;
  winblend = 20;
  width = 0.6;
  prompt_title = '';
  prompt_prefix = 'Files>';
  previewer = false;
  borderchars = {
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
  },
})

-- copied from https://github.com/nvim-telescope/telescope.nvim/wiki/Gallery
local full_theme = {
  winblend = 20;
  width = 0.8;
  show_line = false;
  prompt_prefix = 'Files>';
  prompt_title = '';
  results_title = '';
  preview_title = '';
  borderchars = {
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
  },
}

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
  results_title = 'Results',
  preview_title = 'Preview',
  layout_config = {
    width_padding = 0.11,
    height_padding = 0.13,
    preview_width = 0.56,
  },
}

-- Find in neovim config with center theme
finders.fd_full = function()
  local opts = vim.deepcopy(full_theme)
  require'telescope.builtin'.fd(opts)
end

-- Find in neovim config with center theme
finders.fd_files_dropdown = function()
  local opts = vim.deepcopy(dropdown_theme)
  require'telescope.builtin'.fd(opts)
end

-- Find in neovim config with center theme
finders.fd_in_nvim = function()
  local opts = vim.deepcopy(center_list)
  opts.prompt_prefix = 'Nvim>'
  opts.cwd = vim.fn.stdpath("config")
  require'telescope.builtin'.fd(opts)
end

-- Find in dotfiles with center theme
finders.fd_dotfiles = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = 'dotfiles>'
  opts.cwd = "~/data/Github/dotfiles"
  require'telescope.builtin'.fd(opts)
end

-- Find files with_preview settings
finders.fd = function()
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

