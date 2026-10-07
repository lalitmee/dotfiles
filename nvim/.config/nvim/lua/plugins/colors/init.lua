require("plugins.colors.util")
require("colorizer").setup()

vim.keymap.set("n", "<leader>ac", "<cmd>ColorizerToggle<cr>", { desc = "Toggle Colorizer" })
