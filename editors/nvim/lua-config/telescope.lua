-- local telescope = require('telescope')
-- local builtin = require('telescope.builtin')
-- local previewers = require('telescope.previewers')
-- local sorters = require('telescope.sorters')
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    color_devicons = true,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-k>"] = actions.move_selection_next,
        ["<c-j>"] = actions.move_selection_prev,
      }
    },
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },

    -- file_sorter = sorters.get_fzy_sorter,

    file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    width = 0.5,
    results_width = 0.5,
  }
}

require('telescope').setup {
  defaults = {
    sorting_strategy = "ascending",
    prompt_position = "top",
  }
}

