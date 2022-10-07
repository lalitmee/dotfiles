local ok, neorg = lk.require("neorg")

if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
neorg.setup({
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.integrations.telescope"] = {}, -- load telescope module
    ["core.norg.concealer"] = {
      config = {
        conceals = false,
      },
    }, -- Allows for use of icons
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          work = "~/Desktop/Github/work-notes",
        },
      },
    },
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: key mappings {{{
----------------------------------------------------------------------
local which_key_ok, wk = lk.require("which-key")
if which_key_ok then
  wk.register({
    ["f"] = { ":Telescope neorg insert_file_link<CR>", "insert-file" },
    ["h"] = { ":Telescope neorg search_headings<CR>", "search-heading" },
    ["i"] = { ":Telescope neorg insert_link<CR>", "insert-link" },
    ["l"] = { ":Telescope neorg find_linkable<CR>", "find-linkable" },
  }, { prefix = "m" })
end
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
