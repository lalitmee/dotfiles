lk.cmap("<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

vim.keymap.set("n", "<leader>pm", require("telescope.multi-ripgrep"), { desc = "multi-ripgrep" })
