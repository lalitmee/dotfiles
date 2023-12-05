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
            "harpoon",
            "help",
            "log",
            "lspinfo",
            "man",
            "neotest-output",
            "neotest-summary",
            "oil",
            "qf",
            "query",
            "redir_output",
            "spectre_panel",
            "startuptime",
            "toggleterm",
            "tsplayground",
            "vim",
        },
        command = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {
                buffer = event.buf,
                silent = true,
            })
        end,
    },
    {
        event = { "BufEnter" },
        pattern = { "*.scriptease-verbose" },
        command = function(args)
            vim.keymap.set("n", "q", "<cmd>bd<cr>", {
                buffer = args.buf,
                silent = true,
            })
        end,
    },
})
