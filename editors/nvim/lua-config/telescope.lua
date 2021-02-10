local sorters = require('telescope.sorters')
local actions = require('telescope.actions')

require('telescope').load_extension('gh')

require('telescope').setup {
  defaults = {
    prompt_prefix = "🔍",
    sorting_strategy = "ascending",
    prompt_position = "top",
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
  }
}

-- require('telescope.builtin').buffers({
--   entry_maker = require'rc.telescope.my_make_entry'.gen_from_buffer_like_leaderf(),
-- })
