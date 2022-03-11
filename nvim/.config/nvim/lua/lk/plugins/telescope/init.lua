local status_ok, telescope = lk.safe_require("telescope")
if not status_ok then
  vim.notify("telescope not found", "error", { title = "[telescope] error" })
  return
end

----------------------------------------------------------------------
-- NOTE: telescope mappings {{{
----------------------------------------------------------------------
require("lk/plugins/telescope/mappings")
-- }}}
----------------------------------------------------------------------

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
    prompt_prefix = "  ",
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
    file_ignore_patterns = {
      "%.otf",
      "%.ttf",
      "%.DS_Store",
      "%.git",
      "build",
      "node_modules",
    },
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
    openbrowser = {
      bookmarks = {
        ["lualine"] = "https://github.com/hoob3rt/lualine.nvim",
        ["neovim"] = "https://github.com/neovim/neovim",
        ["neovim-discource"] = "https://neovim.discourse.group/",
        ["nvim-telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
        ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
      },
      bookmark_filepath = "~/config/nvim/telescope_openbrowser_bookamarks",
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
