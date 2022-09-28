local status_ok, telescope = lk.require("telescope")
if not status_ok then
  return
end

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
local action_utils = require("telescope.actions.utils")
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

------------------------------------------------------------------------------------------------------------------------
-- action to open entried in the results
------------------------------------------------------------------------------------------------------------------------
local open_entries = function(prompt_bufnr)
  local bufs = vim.tbl_map(function(b)
    return vim.api.nvim_buf_get_name(b)
  end, vim.api.nvim_list_bufs())
  local entries = {}
  action_utils.map_entries(prompt_bufnr, function(entry)
    table.insert(entries, entry)
  end)
  -- we have to close telescope picker beforehand
  -- otherwise window config of previewer subsumed
  actions.close(prompt_bufnr)
  for _, e in ipairs(entries) do
    if vim.tbl_isempty(vim.tbl_filter(function(b)
      return b == e[1]
    end, bufs)) then
      vim.cmd(string.format("e %s", e[1]))
    end
  end
end

----------------------------------------------------------------------
-- NOTE: maker for buffers list {{{
----------------------------------------------------------------------
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job
    :new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local mime_class = vim.split(j:result()[1], "/")[1]
        local mime_type = j:result()[1]
        if mime_class == "text" or (mime_class == "application" and mime_type ~= "application/x-pie-executable") then
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        else
          -- maybe we want to write something to the buffer here
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
          end)
        end
      end,
    })
    :sync()
end
-- }}}
----------------------------------------------------------------------

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
    prompt_prefix = "   ", --   
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    dynamic_preview_title = true,
    path_display = { "absolute", "truncate" },
    history = {
      path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
    },
    buffer_previewer_maker = new_maker,

    set_env = {
      ["COLORTERM"] = "truecolor",
    }, -- default = nil,

    mappings = {
      i = {
        ["<C-b>"] = open_entries,
        ["<C-e>"] = actions.move_to_bottom,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-y>"] = actions.move_to_top,
        ["<M-p>"] = action_layout.toggle_preview,
        ["<M-v>"] = action_layout.toggle_mirror,
        ["<M-o>"] = action_layout.toggle_prompt_position,
        ["<esc>"] = actions.close,
      },
      n = {
        ["e"] = actions.move_to_bottom,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["o"] = actions.send_selected_to_qflist + actions.open_qflist,
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
      path_display = { "absolute", shorten = 2 },
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
    reloader = dropdown({}),
  },
  extensions = {
    howdoi = {
      num_answers = 3,
      explain_answer = true,
    },
    media_files = { find_cmd = "rg" },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
    frecency = {
      default_workspace = "CWD",
      show_unindexed = false, -- Show all files or only those that have been indexed
      ignore_patterns = { "*.git/*", "*/tmp/*", "*node_modules/*", "*vendor/*" },
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
-- NOTE: load extensions {{{
----------------------------------------------------------------------
-- projects extension
require("telescope").load_extension("projects")

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: custom commands {{{
----------------------------------------------------------------------
local command = lk.command

command("TelescopeEditNeovim", function()
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
end, {})

command("TelescopeEditDotfiles", function()
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
end, {})

command("TelescopeInstalledPlugins", function()
  builtin.find_files({
    cwd = vim.fn.stdpath("data") .. "/site/pack/packer/start/",
  })
end, {})

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
lk.cmap("<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })
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
  {
    event = { "User" },
    pattern = { "TelescopePreviewerLoaded" },
    command = function()
      vim.cmd([[setlocal wrap]])
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
