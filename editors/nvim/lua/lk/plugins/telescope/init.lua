if not pcall(require, 'telescope') then
  return
end

local should_reload = true
local reloader = function()
  if should_reload then
    RELOAD('plenary')
    RELOAD('popup')
    RELOAD('telescope')
  end
end
reloader()

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--color=auto',
      '--hidden',
      '-g',
      '!.git'
    },
    prompt_prefix = ' > ',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    prompt_position = 'top',
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    mappings = {
      i = {
        ['<C-e>'] = actions.move_to_bottom,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-y>'] = actions.move_to_top,
        ['<esc>'] = actions.close
      }
    },
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
    },
    file_ignore_patterns = {
      '.backup',
      '.swap',
      '.langservers',
      '.session',
      '.undo',
      '*.git',
      'node_modules',
      'vendor',
      '.cache',
      '.vscode-server',
      '.Desktop',
      '.Documents',
      'classes'
    },
    file_sorter = sorters.get_fzy_sorter,

    layout_defaults = {
      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.56
      },
      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5
      }
    },
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new
  },
  extensions = {
    fzy_native = { override_generic_sorter = false, override_file_sorter = true },
    fzf_writer = {
      minimum_grep_characters = 5,
      minimum_files_characters = 5,
      use_highlighter = true
    },
    media_files = {
      filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'pdf', 'mp4', 'webm' },
      find_cmd = 'rg'
    },
    frecency = {
      show_unindexed = true,
      ignore_patterns = { '*.git/*', '*/node_modules/*' },
      workspaces = {
        ['nvim'] = '/home/lalitmee/data/.config/nvim/plugged',
        ['dotf'] = '/home/lalitmee/data/Github/dotfiles',
        ['work'] = '/home/lalitmee/data/koinearth',
        ['git'] = '/home/lalitmee/data/Github',
        ['conf'] = '/home/lalitmee/.config',
        ['data'] = '/home/lalitmee/.local/share'
      }
    },
    openbrowser = {
      bookmarks = {
        ['B2BOrdersWorkflowServer'] = 'https://github.com/koinearth/B2BOrdersWorkflowServer',
        ['dNotes'] = 'https://github.com/lalitmee/dNotes',
        ['dotfiles'] = 'https://github.com/lalitmee/dotfiles',
        ['marketsn-api-service'] = 'https://github.com/koinearth/marketsn-api-service',
        ['marketsn-pdf-service'] = 'https://github.com/koinearth/marketsn-pdf-service',
        ['marketsn-pwa-service'] = 'https://github.com/koinearth/marketsn-pwa-service',
        ['marketsn-webapp-service'] = 'https://github.com/koinearth/marketsn-webapp-service-nextjs',
        ['wf-pwa-service'] = 'https://github.com/koinearth/wf-pwa-service',
        ['wf-webapp-service'] = 'https://github.com/koinearth/wf-webapp-service'
      }
    }
  }
}

require('telescope').load_extension('dap')
require('telescope').load_extension('cheat')
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('jumps')
require('telescope').load_extension('openbrowser')
require('telescope').load_extension('project')
require('telescope').load_extension('snippets')
require('telescope').load_extension('ultisnips')
require('telescope').load_extension('harpoon')
require('telescope').load_extension('dotfiles')

local M = {}

function M.edit_neovim()
  builtin.find_files {
    prompt_title = '~ neovim ~',
    shorten_path = false,
    cwd = '~/.config/nvim',

    layout_strategy = 'horizontal',
    layout_defaults = {
      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.56
      },
      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5
      }
    }
  }
end

function M.edit_dotfiles()
  builtin.find_files {
    prompt_title = '~ dotfiles ~',
    shorten_path = false,
    hidden = true,
    cwd = '~/data/Github/dotfiles',

    layout_strategy = 'horizontal',
    layout_defaults = {
      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.56
      },
      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5
      }
    }
  }
end

function M.edit_zsh()
  builtin.find_files {
    shorten_path = false,
    cwd = '~/.config/zsh/',
    prompt = '~ dotfiles ~',

    layout_strategy = 'horizontal',
    layout_defaults = {
      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.56
      },
      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5
      }
    }
  }
end

function M.fd()
  builtin.fd()
end

function M.builtin()
  builtin.builtin()
end

function M.git_files()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false
  }

  builtin.git_files(opts)
end

function M.buffer_git_files()
  builtin.git_files(
      themes.get_dropdown {
        cwd = vim.fn.expand('%:p:h'),
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false
      }
  )
end

function M.lsp_code_actions()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false
  }

  builtin.lsp_code_actions(opts)
end

function M.live_grep()
  require('telescope').extensions.fzf_writer.staged_grep {
    shorten_path = true,
    previewer = true,
    fzf_separator = '|>'
  }
end

function M.grep_prompt()
  builtin.grep_string {
    shorten_path = true,
    search = vim.fn.input('Grep String > ')
  }
end

function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg('/'):gsub('\\<', ''):gsub('\\>', ''):gsub(
                       '\\C', ''
                   )

  opts.shorten_path = false
  opts.word_match = '-w'
  opts.search = register

  builtin.grep_string(opts)
end

function M.oldfiles()
  if true then
    require('telescope').extensions.frecency.frecency()
  end
  if pcall(require('telescope').load_extension, 'frecency') then
  else
    builtin.oldfiles {
      -- layout_strategy = 'vertical',
    }
  end
end

function M.my_plugins()
  builtin.find_files { cwd = '~/plugins/' }
end

function M.installed_plugins()
  builtin.find_files { cwd = vim.fn.stdpath('config') .. '/autoload/plugged' }
end

function M.project_search()
  builtin.find_files {
    -- previewer = true,
    hidden = true,
    cwd = require('nvim_lsp.util').root_pattern('.git')(vim.fn.expand('%:p'))
  }
end

function M.buffers()
  builtin.buffers { shorten_path = false }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 0,
    border = true,
    previewer = false,
    shorten_path = false
  }
  builtin.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  builtin.help_tags { show_version = true }
end

function M.search_all_files()
  builtin.find_files {
    find_command = { 'rg', '--no-ignore', '--hidden', '--files' },
    hidden = true
  }
end

function M.file_browser()
  builtin.file_browser {
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    prompt_position = 'top'
  }
end

function M.go_to_definition()
  builtin.lsp_definitions {
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    prompt_position = 'top'
  }
end

function M.lsp_workspace_symbols()
  builtin.lsp_workspace_symbols { query = vim.fn.input('Query > ') }
end

return setmetatable(
           {}, {
      __index = function(_, k)
        reloader()

        if M[k] then
          return M[k]
        else
          return builtin[k]
        end
      end
    }
       )