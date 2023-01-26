lk.augroup("fugitive_au", {
    {
        event = { "BufWinEnter" },
        buffer = 0,
        command = [[ :wincmd K | resize 30]],
    },
    {
        event = { "BufWinEnter" },
        buffer = 0,
        command = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "<leader>p", function()
                vim.cmd.Git("push")
            end, opts)

            -- rebase always
            vim.keymap.set("n", "<leader>P", function()
                -- vim.cmd.Git({ "pull", "--rebase" })
                vim.cmd([[Git pull --rebase]])
            end, opts)

            -- NOTE: It allows me to easily set the branch i am pushing and any tracking
            -- needed if i did not set the branch up correctly
            vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
        end,
    },
})
