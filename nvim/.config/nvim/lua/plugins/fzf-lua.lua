return {
    { --[[ fzf-lua ]]
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<localleader>f", group = "fzf" },
                { "<localleader>fb", group = "buffers" },
                { "<localleader>ff", group = "files" },
                { "<localleader>fl", group = "lsp" },
                { "<localleader>fs", group = "search" },
            })
        end,

        keys = {
            { "<leader>aa", ":FzfLua<space>", desc = "Fzf Lua Builtin" },
            { "<leader>bB", ":FzfLua buffers<CR>", desc = "Fzf Buffers" },
            { "<leader>bL", ":FzfLua blines<CR>", desc = "Fzf Buffer Lines" },
            { "<leader>fF", ":FzfLua files<CR>", desc = "Files" },
            "<C-]>",
            "gd",

            { "<localleader>f/", ":FzfLua live_grep<CR>", desc = "Fzf Live Grep", silent = true },
            { "<localleader>fbL", ":FzfLua lines<CR>", desc = "Fzf Lines", silent = true },
            { "<localleader>fbb", ":FzfLua buffers<CR>", desc = "Fzf Buffers", silent = true },
            { "<localleader>fbl", ":FzfLua blines<CR>", desc = "Fzf Buffer Lines", silent = true },
            { "<localleader>fff", ":FzfLua files<CR>", desc = "Fzf Files", silent = true },
            {
                "<localleader>fle",
                ":FzfLua lsp_document_diagnostics<CR>",
                desc = "Fzf Lsp Document Diagnostics",
                silent = true,
            },
            {
                "<localleader>flE",
                ":FzfLua lsp_workspace_diagnostics<CR>",
                desc = "Fzf Lsp Workspace Diagnostics",
                silent = true,
            },
            { "<localleader>fll", ":FzfLua lsp_finder<CR>", desc = "Fzf Lsp Finder", silent = true },
            { "<localleader>flr", ":FzfLua lsp_references<CR>", desc = "Fzf Lsp References", silent = true },
            {
                "<localleader>flw",
                ":FzfLua lsp_document_symbols<CR>",
                desc = "Fzf Lsp Document Symbols",
                silent = true,
            },
            {
                "<localleader>flW",
                ":FzfLua lsp_workspace_symbols<CR>",
                desc = "Fzf Lsp Workspace Symbols",
                silent = true,
            },
            {
                "<localleader>fls",
                ":FzfLua lsp_live_workspace_symbols<CR>",
                desc = "fzf-lsp-live-workspace-symbols",
                silent = true,
            },
            { "<localleader>fsR", ":FzfLua live_grep_resume<CR>", desc = "Fzf Live Grep Resume", silent = true },
            { "<localleader>fsr", ":FzfLua resume<CR>", desc = "Fzf Resume", silent = true },
        },
        opts = {
            winopts = {
                width = 0.95,
                height = 0.95,
                preview = {
                    title_pos = "center",
                    scrollbar = "border",
                },
            },
            fzf_opts = {},
            files = { git_icons = false },
            grep = {
                rg_glob = true,
                rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
            },
            file_ignore_patterns = { "node_modules", ".git" },
        },
    },
}
