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
    RELOAD("telescope")
  end
end
reloader()

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local function get_border(opts)
  return vim.tbl_deep_extend("force", opts or {}, {
    borderchars = {
      { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
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
      "--trim",
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
        ["<C-e>"] = actions.move_to_bottom,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-s>"] = R("telescope").extensions.hop.hop,
        ["<C-u>"] = false,
        ["<C-y>"] = actions.move_to_top,
        ["<M-p>"] = action_layout.toggle_preview,
        ["<esc>"] = actions.close,
      },
      n = {
        ["e"] = actions.move_to_bottom,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["o"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["s"] = R("telescope").extensions.hop.hop,
        ["u"] = false,
        ["y"] = actions.move_to_top,
        ["p"] = action_layout.toggle_preview,
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
    buffers = dropdown({
      path_display = { "absolute", "smart" },
      previewer = false,
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      mappings = {
        i = { ["<c-d>"] = "delete_buffer" },
        n = { ["d"] = "delete_buffer" },
      },
    }),
    live_grep = {
      file_ignore_patterns = { ".git/" },
    },
    current_buffer_fuzzy_find = dropdown({
      previewer = false,
    }),
    lsp_code_actions = {
      theme = "cursor",
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
    hop = {
      sign_hl = { "Title" },
      line_hl = { "CursorLine" },
    },
    media_files = { find_cmd = "rg" },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
    frecency = {
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/node_modules/*" },
      workspaces = {
        ["nvim"] = "/home/lalitmee/.config/nvim/plugged",
        ["dotf"] = "/home/lalitmee/dotfiles",
        ["work"] = "/home/lalitmee/Desktop/koinearth",
        ["git"] = "/home/lalitmee/Desktop/Github",
        ["conf"] = "/home/lalitmee/.config",
        ["data"] = "/home/lalitmee/.local/share",
      },
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
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: autocmds {{{
----------------------------------------------------------------------
lk.augroup("telescope_au", {
  {
    event = { "Filetype" },
    pattern = { "TelescopeResults" },
    command = function()
      vim.cmd([[setlocal notfoldenable]])
    end,
  },
})
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
