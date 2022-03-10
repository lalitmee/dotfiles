local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local customs = {}

customs.coc_list = function()
  pickers.new({
    results_title = "Coc Maps",
    -- Run an external command and show the results in the finder window
    finder = finders.new_oneshot_job({ "CocList", "maps" }),
    sorter = sorters.get_fuzzy_file(),
    previewer = previewers.new_termopen_previewer({
      -- Execute another command using the highlighted entry
      get_command = function(entry)
        return { "CocList", "state", "list", entry.value }
      end,
    }),
  }):find()
end

return customs
