local status_ok, refactoring = lk.safe_require("refactoring")
if not status_ok then
  vim.notify("Failed to load refactoring module", "error", { title = "[refactoring] Error" })
  return
end

refactoring.setup({})

local command = lk.command

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local function refactor(prompt_bufnr)
  local content = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  require("refactoring").refactor(content.value)
end

command({
  "Refactors",
  function()
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
  end,
})

command({
  "RefactorExtractFunc",
  function()
    require("refactoring").refactor(106)
  end,
})

command({
  "RefactorExtractVar",
  function()
    require("refactoring").refactor(119)
  end,
})

command({
  "RefactorInlineVar",
  function()
    require("refactoring").refactor(123)
  end,
})

command({
  "RefactorDebugPath",
  function()
    print(vim.inspect(require("refactoring").debug.get_path()))
  end,
})

command({
  "RefactorDebugPrintAbove",
  function()
    require("refactoring").debug.printf({ below = false })
  end,
})

command({
  "RefactorDebugPrintfBelow",
  function()
    require("refactoring").debug.printf({ below = true })
  end,
})

command({
  "RefactorDebugPrintVarAbove",
  function()
    require("refactoring").debug.print_var({ below = false })
  end,
})

command({
  "RefactorDebugPrintVarBelow",
  function()
    require("refactoring").debug.print_var({ below = true })
  end,
})
-- }}}
----------------------------------------------------------------------
