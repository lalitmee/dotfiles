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
    },
    arecibo = {
      ['selected_engine'] = 'google',
      ['url_open_command'] = 'xdg-open',
      ['show_http_headers'] = false,
      ['show_domain_icons'] = false
    },
    tele_tabby = { use_highlighter = true },
    bookmarks = {
      -- Available: 'brave', 'google_chrome', 'safari', 'firefox', 'firefox_dev'
      selected_browser = 'brave',
      url_open_command = 'xdg-open',
      firefox_profile_name = nil
    }
  }
}

require('telescope').load_extension('arecibo')
require('telescope').load_extension('cheat')
require('telescope').load_extension('dap')
require('telescope').load_extension('dotfiles')
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('harpoon')
require('telescope').load_extension('jumps')
require('telescope').load_extension('lsp_handlers')
require('telescope').load_extension('media_files')
require('telescope').load_extension('openbrowser')
require('telescope').load_extension('packer')
require('telescope').load_extension('project')
require('telescope').load_extension('snippets')
require('telescope').load_extension('tele_tabby')
require('telescope').load_extension('ultisnips')
require('telescope').load_extension('git_worktree')
require('telescope').load_extension('bookmarks')
require('telescope').load_extension('coc')

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

function M.installed_plugins()
  builtin.find_files {
    cwd = vim.fn.stdpath('data') .. '/site/pack/packer/start/'
  }
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

function M.lsp_workspace_symbols()
  builtin.lsp_workspace_symbols { query = vim.fn.input('Query > ') }
end

local function set_background(content)
  vim.fn.system(
      'dconf write /org/mate/desktop/background/picture-filename "\'' .. content ..
          '\'"')
end

local function select_background(prompt_bufnr, map)
  local function set_the_background(close)
    local content = require('telescope.actions.state').get_selected_entry(
                        prompt_bufnr)
    set_background(content.cwd .. '/' .. content.value)
    if close then
      require('telescope.actions').close(prompt_bufnr)
    end
  end

  map('i', '<C-p>', function()
    set_the_background()
  end)

  map('i', '<CR>', function()
    set_the_background(true)
  end)
end

local function image_selector(prompt, cwd)
  return function()
    require('telescope.builtin').find_files(
        {
          prompt_title = prompt,
          cwd = cwd,

          attach_mappings = function(prompt_bufnr, map)
            select_background(prompt_bufnr, map)

            -- Please continue mapping (attaching additional key maps):
            -- Ctrl+n/p to move up and down the list.
            return true
          end
        })
  end
end

M.change_background = image_selector('< Select Wallpaper > ',
                                     '~/data/Github/wallpapers')

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return builtin[k]
    end
  end
})
