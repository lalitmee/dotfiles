local ok, telescope = lk.safe_require("telescope")
if not ok then
  return
end

telescope.load_extension("session-lens")

local actions = require("telescope.actions")

require("session-lens").setup({
  path_display = { "shorten" },
  theme_conf = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
})
