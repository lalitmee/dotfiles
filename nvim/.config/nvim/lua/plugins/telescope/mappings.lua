local builtin = require("telescope.builtin")

lk.cmap("<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

vim.keymap.set("n", "<leader>pm", require("telescope.multi-ripgrep"), { desc = "Telescope Multi Ripgrep" })

vim.keymap.set("n", "<leader>nf", function()
    builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end, { desc = "Find Files of Installed Plugins" })
