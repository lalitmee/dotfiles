local status_ok, telescope = lk.safe_require("telescope")
if not status_ok then
  vim.notify("telescope not found", "error", { title = "[telescope] error" })
  return
end

local should_reload = true
local reloader = function()
  if should_reload then
    RELOAD("plenary")
    RELOAD("popup")
    RELOAD("telescope")
  end
end
reloader()

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local function get_border(opts)
  return vim.tbl_deep_extend("force", opts or {}, {
    borderchars = {
      { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
  })
end

---@param opts table
---@return table
local function dropdown(opts)
  return themes.get_dropdown(get_border(opts))
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--hidden",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = " ",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    dynamic_preview_title = true,
    path_display = {
      "absolute",
      -- "smart",
    },
    history = {
      path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
    },

    set_env = {
      ["COLORTERM"] = "truecolor",
    }, -- default = nil,

    mappings = {
      i = {
        ["<C-a>"] = actions.cycle_previewers_prev,
        ["<C-e>"] = actions.move_to_bottom,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-y>"] = actions.move_to_top,
        ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-h>"] = R("telescope").extensions.hop.hop,
        ["<esc>"] = actions.close,
      },
    },
    borderchars = {
      { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    file_ignore_patterns = { "%.otf", "%.ttf", "%.DS_Store" },

    layout_config = {
      width = 0.90,
      height = 0.90,
      prompt_position = "top",
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
      flex = {
        horizontal = {
          preview_width = 0.8,
        },
      },
    },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
  },
  pickers = {
    buffers = {
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      mappings = {
        i = { ["<c-x>"] = "delete_buffer" },
        n = { ["<c-x>"] = "delete_buffer" },
      },
    },
    live_grep = {
      file_ignore_patterns = { ".git/" },
    },
    -- current_buffer_fuzzy_find = dropdown({
    --   previewer = false,
    --   shorten_path = false,
    -- }),
    lsp_code_actions = {
      theme = "cursor",
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      hidden = true,
    },
    git_bcommits = {
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    },
    git_commits = {
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
    },
    reloader = dropdown(),
  },
  extensions = {
    extensions = {
      hop = {
        sign_hl = { "WarningMsg", "Title" },
        line_hl = { "CursorLine", "Normal" },
      },
    },
    windowizer = { find_cmd = "rg" },
    media_files = { find_cmd = "rg" },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
    },
    frecency = {
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/node_modules/*" },
      workspaces = {
        ["nvim"] = "/home/lalitmee/.config/nvim/plugged",
        ["dotf"] = "/home/lalitmee/Desktop/Github/dotfiles",
        ["work"] = "/home/lalitmee/Desktop/koinearth",
        ["git"] = "/home/lalitmee/Desktop/Github",
        ["conf"] = "/home/lalitmee/.config",
        ["data"] = "/home/lalitmee/.local/share",
      },
    },
    bookmarks = {
      -- Available: 'brave', 'google_chrome', 'safari', 'firefox', 'firefox_dev'
      selected_browser = "brave",

      -- Either provide a shell command to open the URL
      url_open_command = "xdg-open",

      -- Or provide the plugin name which is already installed
      -- Available: 'vim_external', 'open_browser'
      url_open_plugin = nil,
      firefox_profile_name = nil,
    },
    openbrowser = {
      bookmarks = {
        -- work related bookmards
        ["B2BOrdersWorkflowServer"] = "https://github.com/koinearth/B2BOrdersWorkflowServer",
        ["dNotes"] = "https://github.com/lalitmee/dNotes",
        ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
        ["marketsn-api-service"] = "https://github.com/koinearth/marketsn-api-service",
        ["marketsn-pdf-service"] = "https://github.com/koinearth/marketsn-pdf-service",
        ["marketsn-pwa-service"] = "https://github.com/koinearth/marketsn-pwa-service",
        ["marketsn-webapp-service"] = "https://github.com/koinearth/marketsn-webapp-service-nextjs",
        ["material-ui"] = "https://material-ui.com/",
        ["material-ui-icons"] = "https://material-ui.com/components/material-icons/#material-icons",
        ["my-pull-requests"] = "https://github.com/pulls",
        ["wf-pwa-service"] = "https://github.com/koinearth/wf-pwa-service",
        ["wf-webapp-service"] = "https://github.com/koinearth/wf-webapp-service",
        ["google-meet-1"] = "https://meet.google.com/czd-juio-jvf",

        -- neovim related bookmards
        ["lualine"] = "https://github.com/hoob3rt/lualine.nvim",
        ["neovim"] = "https://github.com/neovim/neovim",
        ["neovim-discource"] = "https://neovim.discourse.group/",
        ["nvim-telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
        ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",

        -- general
        ["clang_func_dict"] = "https://www.c-tipsref.com/cgi-bin/index.cgi?q={query}&b.x=0&b.y=0",
        ["crates_io"] = "https://crates.io/search?q={query}",
        ["devdocs"] = "https://devdocs.io/#q={query}",
        ["duckduckgo"] = "https://duckduckgo.com/?q={query}",
        ["github"] = "https://github.com/search?q={query}",
        ["luaroks"] = "https://luarocks.org/search?q={query}",
        ["mdnwebdocs"] = "https://developer.mozilla.org/ja/search?q={query}",
        ["memo"] = "https://scrapbox.io/tamago324vim/search/page?q={query}",
        ["neovim_patch"] = "https://github.com/neovim/neovim/issues?q=is%3Aopen+sort%3Aupdated-desc+{query}",
        ["python"] = "https://docs.python.org/3/search.html?q={query}",
        ["rust_doc_std"] = "https://doc.rust-lang.org/std/index.html?search={query}",
        ["utf8_icons"] = "https://www.utf8icons.com/search?query={query}",
        ["vim_commits"] = "https://github.com/vim/vim/search?q={query}&type=commits",
        ["vimawesome"] = "https://vimawesome.com/?q={query}",
        ["google"] = "https://www.google.com/search?q={query}",
      },
    },
    arecibo = {
      ["selected_engine"] = "google",
      ["url_open_command"] = "xdg-open",
      ["show_http_headers"] = false,
      ["show_domain_icons"] = false,
    },
    project = {
      base_dirs = {
        { "~/", max_depth = 7 },
      },
      hidden_files = true,
    },
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: loading extensions {{{
----------------------------------------------------------------------

-- -- coc integration in telescope
-- require('telescope').load_extension('coc')

-- -- debugger
-- require('telescope').load_extension('dap')

-- hop integration
require("telescope").load_extension("hop")

-- windowizer integration in telescope
require("telescope").load_extension("windowizer")

-- tmux integration in telescope
require("telescope").load_extension("tmux")

-- tmuxinator
require("telescope").load_extension("tmuxinator")

-- scratch buffer
require("telescope").load_extension("ui-select")

-- media files
require("telescope").load_extension("media_files")

-- scratch buffer
require("telescope").load_extension("scratch")

-- smart history in telescope
require("telescope").load_extension("smart_history")

-- packer integration with telescope
require("telescope").load_extension("packer")

-- project management in `telescope-project`
require("telescope").load_extension("project")

-- projects integration `ahmedkhalf/project.nvim`
require("telescope").load_extension("projects")

-- recent files or history or files visited
require("telescope").load_extension("frecency")

-- FZF sorter for telescope written in c
require("telescope").load_extension("fzf")

-- git worktree
require("telescope").load_extension("git_worktree")

-- harpoon
require("telescope").load_extension("harpoon")

-- open browser
require("telescope").load_extension("openbrowser")

-- emoji search
require("telescope").load_extension("emoji")

-- file browser
require("telescope").load_extension("file_browser")

-- repo list
require("telescope").load_extension("repo")

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: custom commands {{{
----------------------------------------------------------------------

local M = {}

function M.edit_neovim()
  builtin.find_files({
    prompt_title = "~ neovim ~",
    cwd = "~/.config/nvim",

    layout_strategy = "horizontal",
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
  })
end

function M.edit_dotfiles()
  builtin.find_files({
    prompt_title = "~ dotfiles ~",
    hidden = true,
    cwd = "~/dotfiles",

    layout_strategy = "horizontal",
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
  })
end

function M.installed_plugins()
  builtin.find_files({
    cwd = vim.fn.stdpath("data") .. "/site/pack/packer/start/",
  })
end

function M.curbuf()
  local opts = themes.get_dropdown({
    winblend = 0,
    border = true,
    previewer = false,
  })
  builtin.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  builtin.help_tags({
    show_version = true,
  })
end

function M.find_files()
  builtin.find_files({
    hidden = true,
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
  })
end

function M.fd()
  local opts = themes.get_ivy({
    hidden = true,
  })
  require("telescope.builtin").fd(opts)
end

function M.search_all_files()
  builtin.find_files({
    find_command = { "rg", "--no-ignore", "--hidden", "--files" },
    hidden = true,
  })
end

function M.lsp_workspace_symbols()
  builtin.lsp_workspace_symbols({
    query = vim.fn.input("Query > "),
  })
end

----------------------------------------------------------------------
-- NOTE: ThePrimeagen/refactoring.nvim setup {{{
----------------------------------------------------------------------
local function refactor(prompt_bufnr)
  local content = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  require("refactoring").refactor(content.value)
end

M.refactors = function()
  require("telescope.pickers").new({}, {
    prompt_title = "refactors",
    finder = require("telescope.finders").new_table({
      results = require("refactoring").get_refactors(),
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", refactor)
      map("n", "<CR>", refactor)
      return true
    end,
  }):find()
end
-- }}}
----------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

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

-- vim:foldmethod=marker
