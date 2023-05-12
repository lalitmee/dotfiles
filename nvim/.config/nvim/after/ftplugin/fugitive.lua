lk.augroup("fugitive_au", {
    {
        event = { "BufWinEnter" },
        buffer = 0,
        command = function()
            vim.cmd([[:wincmd K | resize 30]])
            vim.cmd([[:norm 4j]])
            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { buffer = bufnr, remap = false }
            lk.nnoremap("<leader>p", function()
                vim.cmd.Git("push")
            end, opts)

            -- rebase always
            lk.nnoremap("<leader>P", function()
                vim.cmd([[Git pull --rebase]])
            end, opts)

            lk.nnoremap("<leader>t", ":Git push -u origin ", opts)

            -- easy mapping to toggling diff
            lk.nmap("<TAB>", "=", { buffer = bufnr, remap = true })
        end,
    },
})
