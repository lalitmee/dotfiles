local status_ok, refactoring = lk.safe_require("refactoring")
if not status_ok then
  vim.notify("Failed to load refactoring module", "error", { title = "[refactoring] Error" })
  return
end

refactoring.setup({})

local map = vim.keymap.set
local map_opts = { noremap = true, silent = true, expr = false }

map("v", "<leader>rr", [[:lua require("lk/plugins/telescope").refactors()<CR>]], map_opts)
map("v", "<leader>re", [[:lua require("refactoring").refactor(106)<CR>]], map_opts)
map("n", "<leader>ri", [[:lua require("refactoring").refactor(123)<CR>]], map_opts)
map("n", "<leader>rh", [[:lua print(vim.inspect(require("refactoring").debug.get_path()))<CR>]], map_opts)
map("n", "<leader>rg", [[:lua require("refactoring").debug.printf({below=false})<CR>]], map_opts)
map("n", "<leader>rm", [[:lua require("refactoring").debug.printf({below=true})<CR>]], map_opts)
map("n", "<leader>rf", [[:lua require("refactoring").debug.print_var({below=false})<CR>]], map_opts)
map("n", "<leader>rb", [[:lua require("refactoring").debug.print_var({below=true})<CR>]], map_opts)
