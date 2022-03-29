local ok, neorg = lk.safe_require("neorg")

if not ok then
  return
end

neorg.setup({
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
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
