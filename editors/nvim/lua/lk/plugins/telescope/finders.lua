-- in lua/finders.lua
local finders = {}

-- copied from https://github.com/nvim-telescope/telescope.nvim/wiki/Gallery
local dropdown_theme = require('telescope.themes').get_dropdown(
                           {
      results_height = 20,
      -- winblend = 20;
      width = 0.6,
      prompt_title = '',
      prompt_prefix = 'Files> ',
      previewer = false,
      borderchars = {
        { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
      }
    }
                       )

-- copied from https://github.com/nvim-telescope/telescope.nvim/wiki/Gallery
local full_theme = {
  -- winblend = 20;
  width = 0.8,
  show_line = false,
  prompt_prefix = 'Files> ',
  prompt_title = '',
  results_title = '',
  preview_title = '',
  borderchars = {
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
  }
}

-- Dropdown list theme using a builtin theme definitions :
local center_list = require'telescope.themes'.get_dropdown(
                        {
      -- winblend = 10,
      width = 0.5,
      prompt = ' ',
      results_height = 15,
      previewer = false
    }
                    )

-- Settings for with preview option
local with_preview = {
  -- winblend = 10,
  show_line = false,
  results_title = 'Results',
  preview_title = 'Preview',
  layout_config = {
    width_padding = 0.11,
    height_padding = 0.13,
    preview_width = 0.56
  }
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
finders.search_nvim_config = function()
  local opts = vim.deepcopy(center_list)
  opts.prompt_prefix = 'nvim> '
  opts.cwd = vim.fn.stdpath('config')
  require'telescope.builtin'.fd(opts)
end

-- Find in dotfiles with center theme
finders.search_dotfiles = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = 'dotfiles> '
  opts.cwd = '~/data/Github/dotfiles'
  require'telescope.builtin'.fd(opts)
end

-- Find files with_preview settings
finders.fd = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = 'Files> '
  require'telescope.builtin'.fd(opts)
end

return finders
