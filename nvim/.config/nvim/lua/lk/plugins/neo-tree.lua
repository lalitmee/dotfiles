local ok, neotree = lk.safe_require("neo-tree")

local nmap = lk.nmap
local icons = lk.style.icons.lsp
local fn = vim.fn
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: diagnostic signs {{{
----------------------------------------------------------------------
local diagnostic_types = {
  { "Error", icon = icons.error },
  { "Warn", icon = icons.warn },
  { "Hint", icon = icons.hint },
  { "Info", icon = icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = "DiagnosticSign" .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = fmt("%sLine", hl),
  }
end, diagnostic_types))
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
nmap([[\]], "<cmd>NeoTreeFocusToggle<cr>", { silent = true })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
neotree.setup({
  window = {
    position = "right",
    width = 50,
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = true,
  },
})
-- }}}
----------------------------------------------------------------------
