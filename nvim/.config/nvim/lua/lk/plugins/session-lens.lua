local ok, telescope = lk.require("telescope")
if not ok then
  return
end

telescope.load_extension("session-lens")

local actions = require("telescope.actions")

require("session-lens").setup({
  theme_conf = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
})
