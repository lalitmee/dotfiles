lk.augroup("quit_q_au", {
    {
        event = { "FileType" },
        pattern = {
            "OverseerForm",
            "OverseerList",
            "checkhealth",
            "floggraph",
            "fugitive",
            "git",
            "gitcommit",
            "help",
            "log",
            "lspinfo",
            "man",
            "neotest-output",
            "neotest-summary",
            "oil",
            "qf",
            "query",
            "spectre_panel",
            "startuptime",
            "toggleterm",
            "tsplayground",
            "vim",
        },
        command = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set(
                "n",
                "q",
                "<cmd>close<cr>",
                { buffer = event.buf, silent = true }
            )
        end,
    },
    {
        event = { "BufEnter" },
        -- buffer = 0,
        pattern = { "scriptease-verbose", "startup-log" },
        command = function()
            lk.nnoremap("q", ":bd<cr>")
        end,
    },
})
