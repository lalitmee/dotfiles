local sorters = require('telescope.sorters')
local actions = require('telescope.actions')

require('telescope').load_extension('gh')
require('telescope').load_extension('fzy_native')
require'telescope'.load_extension('project')
require('telescope').load_extension('media_files')
require('telescope').load_extension('frecency')
require('telescope').load_extension('z')
require('telescope').load_extension('node_modules')
-- require('telescope').load_extension('snippets')

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

    file_sorter = sorters.get_fzy_sorter,

    layout_defaults = {
      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.6,
      },
      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5,
      }
    },

    file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    fzf_writer = {
      use_highlighter = true,
      minimum_grep_characters = 0,
      minimum_files_characters = 0,
    },
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = {"png", "webp", "jpg", "jpeg", "pdf", "mp4", "webm"},
      find_cmd = "rg" -- find command (defaults to `fd`)
    },
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*"},
      workspaces = {
        ["conf"]      = "/home/data/Github/dotfiles",
        ["koinearth"] = "/home/data/koinearth",
        ["project"]   = "/home/data/Github",
        -- ["wiki"]   = "/home/my_username/wiki"
      }
    }
  }
}
