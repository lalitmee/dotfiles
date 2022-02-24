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
local previewers = require('telescope.previewers')
local themes = require('telescope.themes')

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    selection_strategy = 'reset',
    -- sorting_strategy = 'descending',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    color_devicons = true,
    dynamic_preview_title = true,
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },

    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,

    mappings = {
      i = {
        ['<C-a>'] = actions.cycle_previewers_prev,
        ['<C-e>'] = actions.move_to_bottom,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-y>'] = actions.move_to_top,
        ['<C-o>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<esc>'] = actions.close,
      },
    },
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    },
    -- NOTE: it was somehow stopping current_buffer_fuzzy_find, lsp_document_symbols
    -- and so many other things
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
      -- '.Desktop',
      -- '.Documents',
      'classes',
    },

    layout_config = {
      width = 0.90,
      height = 0.90,
      -- prompt_position = 'bottom',
      prompt_position = 'top',

      horizontal = {
        width_padding = 0.11,
        height_padding = 0.13,
        preview_width = 0.56,
      },

      vertical = {
        width_padding = 0.4,
        height_padding = 0.8,
        preview_height = 0.5,
      },

      flex = { horizontal = { preview_width = 0.8 } },
    },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,

  },
  pickers = {
    -- find_files = { theme = 'ivy' },

    buffers = {
      sort_mru = true,
      -- theme = 'dropdown',
      selection_strategy = 'closest',
      -- previewer = false,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      mappings = {
        i = { ['<c-x>'] = actions.delete_buffer },
        n = { ['<c-x>'] = actions.delete_buffer },
      },
    },
  },
  extensions = {
    frecency = {
      show_unindexed = true,
      ignore_patterns = { '*.git/*', '*/node_modules/*' },
      workspaces = {
        ['nvim'] = '/home/lalitmee/.config/nvim/plugged',
        ['dotf'] = '/home/lalitmee/Desktop/Github/dotfiles',
        ['work'] = '/home/lalitmee/Desktop/koinearth',
        ['git'] = '/home/lalitmee/Desktop/Github',
        ['conf'] = '/home/lalitmee/.config',
        ['data'] = '/home/lalitmee/.local/share',
      },
    },
    bookmarks = {
      -- Available: 'brave', 'google_chrome', 'safari', 'firefox', 'firefox_dev'
      selected_browser = 'brave',

      -- Either provide a shell command to open the URL
      url_open_command = 'xdg-open',

      -- Or provide the plugin name which is already installed
      -- Available: 'vim_external', 'open_browser'
      url_open_plugin = nil,
      firefox_profile_name = nil,
    },
    openbrowser = {
      bookmarks = {
        -- work related bookmards
        ['B2BOrdersWorkflowServer'] = 'https://github.com/koinearth/B2BOrdersWorkflowServer',
        ['dNotes'] = 'https://github.com/lalitmee/dNotes',
        ['dotfiles'] = 'https://github.com/lalitmee/dotfiles',
        ['marketsn-api-service'] = 'https://github.com/koinearth/marketsn-api-service',
        ['marketsn-pdf-service'] = 'https://github.com/koinearth/marketsn-pdf-service',
        ['marketsn-pwa-service'] = 'https://github.com/koinearth/marketsn-pwa-service',
        ['marketsn-webapp-service'] = 'https://github.com/koinearth/marketsn-webapp-service-nextjs',
        ['material-ui'] = 'https://material-ui.com/',
        ['material-ui-icons'] = 'https://material-ui.com/components/material-icons/#material-icons',
        ['my-pull-requests'] = 'https://github.com/pulls',
        ['wf-pwa-service'] = 'https://github.com/koinearth/wf-pwa-service',
        ['wf-webapp-service'] = 'https://github.com/koinearth/wf-webapp-service',
        ['google-meet-1'] = 'https://meet.google.com/czd-juio-jvf',

        -- neovim related bookmards
        ['lualine'] = 'https://github.com/hoob3rt/lualine.nvim',
        ['neovim'] = 'https://github.com/neovim/neovim',
        ['neovim-discource'] = 'https://neovim.discourse.group/',
        ['nvim-telescope'] = 'https://github.com/nvim-telescope/telescope.nvim',
        ['awesome-neovim'] = 'https://github.com/rockerBOO/awesome-neovim',

        -- general
        ['clang_func_dict'] = 'https://www.c-tipsref.com/cgi-bin/index.cgi?q={query}&b.x=0&b.y=0',
        ['crates_io'] = 'https://crates.io/search?q={query}',
        ['devdocs'] = 'https://devdocs.io/#q={query}',
        ['duckduckgo'] = 'https://duckduckgo.com/?q={query}',
        ['github'] = 'https://github.com/search?q={query}',
        ['luaroks'] = 'https://luarocks.org/search?q={query}',
        ['mdnwebdocs'] = 'https://developer.mozilla.org/ja/search?q={query}',
        ['memo'] = 'https://scrapbox.io/tamago324vim/search/page?q={query}',
        ['neovim_patch'] = 'https://github.com/neovim/neovim/issues?q=is%3Aopen+sort%3Aupdated-desc+{query}',
        ['python'] = 'https://docs.python.org/3/search.html?q={query}',
        ['rust_doc_std'] = 'https://doc.rust-lang.org/std/index.html?search={query}',
        ['utf8_icons'] = 'https://www.utf8icons.com/search?query={query}',
        ['vim_commits'] = 'https://github.com/vim/vim/search?q={query}&type=commits',
        ['vimawesome'] = 'https://vimawesome.com/?q={query}',
        ['google'] = 'https://www.google.com/search?q={query}',
      },
    },
    arecibo = {
      ['selected_engine'] = 'google',
      ['url_open_command'] = 'xdg-open',
      ['show_http_headers'] = false,
      ['show_domain_icons'] = false,
    },
    project = {
      base_dirs = {
        { '~/Desktop/Github', max_depth = 3 },
        { '~/Desktop/koinearth', max_depth = 3 },
        hidden_files = true,
      },
    },
  },
}

---------------------------------------------------------------------------------
--                          loading extensions start                           --
---------------------------------------------------------------------------------

-- -- coc integration in telescope
-- require('telescope').load_extension('coc')

-- -- tmux integration in telescope
-- require('telescope').load_extension('tmux')

-- -- debugger
-- require('telescope').load_extension('dap')

-- scratch buffer
require('telescope').load_extension('scratch')

-- search internet
require('telescope').load_extension('arecibo')

-- smart history in telescope
require('telescope').load_extension('bookmarks')

-- smart history in telescope
require('telescope').load_extension('smart_history')

-- packer integration with telescope
require('telescope').load_extension('packer')

-- project management in telescope
require('telescope').load_extension('zoxide')

-- project management in telescope
require('telescope').load_extension('project')

-- recent files or history or files visited
require('telescope').load_extension('frecency')

-- FZF sorter for telescope written in c
require('telescope').load_extension('fzf')

-- git worktree
require('telescope').load_extension('git_worktree')

-- harpoon
require('telescope').load_extension('harpoon')

-- open browser
require('telescope').load_extension('openbrowser')

-- ultisnips
require('telescope').load_extension('ultisnips')

-- emoji search
require('telescope').load_extension('emoji')

-- file browser
require('telescope').load_extension('file_browser')

---------------------------------------------------------------------------------
--                           loading extensions end                            --
---------------------------------------------------------------------------------

local M = {}

function M.edit_neovim()
  builtin.find_files {
    prompt_title = '~ neovim ~',
    cwd = '~/.config/nvim',

    layout_strategy = 'horizontal',
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
      },
    },
  }
end

function M.edit_dotfiles()
  builtin.find_files {
    prompt_title = '~ dotfiles ~',
    hidden = true,
    cwd = '~/Desktop/Github/dotfiles',

    layout_strategy = 'horizontal',
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
      },
    },
  }
end

function M.installed_plugins()
  builtin.find_files {
    cwd = vim.fn.stdpath('data') .. '/site/pack/packer/start/',
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 0,
    border = true,
    previewer = false,
  }
  builtin.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  builtin.help_tags { show_version = true }
end

function M.find_files()
  builtin.find_files {
    hidden = true,
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    scroll_strategy = 'cycle',
    color_devicons = true,
  }
end

function M.fd()
  local opts = themes.get_ivy { hidden = true }
  require('telescope.builtin').fd(opts)
end

function M.search_all_files()
  builtin.find_files {
    find_command = { 'rg', '--no-ignore', '--hidden', '--files' },
    hidden = true,
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
    require('telescope.builtin').find_files({
      prompt_title = prompt,
      cwd = cwd,

      attach_mappings = function(prompt_bufnr, map)
        select_background(prompt_bufnr, map)

        -- Please continue mapping (attaching additional key maps):
        -- Ctrl+n/p to move up and down the list.
        return true
      end,
    })
  end
end

M.change_background = image_selector('< Select Wallpaper > ',
                                     '~/Desktop/Github/wallpapers')

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return builtin[k]
    end
  end,
})
