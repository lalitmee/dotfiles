local has_lir, lir = lk.safe_require("lir")
if not has_lir then
  return
end

local has_devicons, devicons = lk.safe_require("nvim-web-devicons")
if has_devicons then
  devicons.setup({
    override = {
      lir_folder_icon = {
        icon = "",
        color = "#00AAFF",
        name = "LirFolderNode",
      },
    },
  })
end

local actions = require("lir.actions")
local clipboard_actions = require("lir.clipboard.actions")

lir.setup({
  show_hidden_files = true,
  devicons_enable = true,

  float = {
    winblend = 15,
    win_opts = {
      border = "single",
    },
  },

  mappings = {
    ["<CR>"] = actions.edit,
    ["-"] = actions.up,
    ["q"] = actions.quit,

    ["<C-x>"] = actions.split,
    ["<C-v>"] = actions.vsplit,
    ["<C-t>"] = actions.tabedit,

    ["K"] = actions.mkdir,
    ["N"] = actions.newfile,
    ["R"] = actions.rename,
    ["Y"] = actions.yank_path,
    ["D"] = actions.delete,
    ["C"] = clipboard_actions.copy,
    ["X"] = clipboard_actions.cut,
    ["P"] = clipboard_actions.paste,
    ["."] = actions.toggle_show_hidden,
  },
})

require("lir.git_status").setup({
  show_ignored = false,
})

vim.api.nvim_set_keymap("n", "-", ":edit %:h<CR>", { noremap = true })

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local command = lk.command
command("LirFloatToggle", function()
  require("lir.float").toggle()
end)

command("LirFloatInit", function()
  require("lir.float").init()
end)
-- }}}
----------------------------------------------------------------------
