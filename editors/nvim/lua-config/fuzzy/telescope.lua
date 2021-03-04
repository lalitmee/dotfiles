local sorters = require('telescope.sorters')
local actions = require('telescope.actions')

-- require('telescope').load_extension('snippets')
require('telescope').load_extension('dap')
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('gh')
require('telescope').load_extension('jumps')
require('telescope').load_extension('media_files')
require('telescope').load_extension('node_modules')
require('telescope').load_extension('openbrowser')
require('telescope').load_extension('project')
require('telescope').load_extension('ultisnips')
require('telescope').load_extension('z')

require('telescope').setup {
  defaults = {
    prompt_prefix = " 🔎 ",
    -- prompt_prefix = " > ",
    sorting_strategy = "ascending",
    prompt_position = "top",
    color_devicons = true,
    mappings = {
      i = {
        ["<C-e>"] = actions.move_to_bottom,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-y>"] = actions.move_to_top,
        ["<esc>"] = actions.close,
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
        preview_width = 0.56,
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
      filetypes = {'png', 'webp', 'jpg', 'jpeg', 'pdf', 'mp4', 'webm'},
      find_cmd = "rg" -- find command (defaults to `fd`)
    },
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {'*.git/*', '*/node_modules/*'},
      workspaces = {
        ['conf']      = '/home/data/Github/dotfiles',
        ['koinearth'] = '/home/data/koinearth',
        ['project']   = '/home/data/Github',
      },
    },
    openbrowser = {
      bookmarks = {
        ['dotfiles']                = 'https://github.com/lalitmee/dotfiles',
        ['dNotes']                  = 'https://github.com/lalitmee/dNotes',
        ['wf-webapp-service']       = 'https://github.com/koinearth/wf-webapp-service',
        ['marketsn-webapp-service'] = 'https://github.com/koinearth/marketsn-webapp-service-nextjs',
        ['wf-pwa-service']          = 'https://github.com/koinearth/wf-pwa-service',
        ['marketsn-pwa-service']    = 'https://github.com/koinearth/marketsn-pwa-service',
        ['marketsn-pdf-service']    = 'https://github.com/koinearth/marketsn-pdf-service',
        ['marketsn-api-service']    = 'https://github.com/koinearth/marketsn-api-service',
        ['B2BOrdersWorkflowServer'] = 'https://github.com/koinearth/B2BOrdersWorkflowServer'
      }
    }
  }
}
