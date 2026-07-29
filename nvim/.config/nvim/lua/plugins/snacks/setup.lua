local wk = require("which-key")
wk.add({
    { "<leader>k", group = "scratch" },

    {
        "<leader>jn",
        function()
            Snacks.words.jump(1, true)
        end,
        desc = "Snacks: Jump to Word Reference Next",
    },
})

-- which-key groups from telescope
wk.add({
    { "<leader>s", group = "search" },
    { "<leader>v", group = "vim" },
    { "<leader>gh", group = "git-hunks", desc = "Git Hunks" },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions[1].type == "move" then
            Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
            Snacks.debug.inspect(...)
        end
        _G.bt = function()
            Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.line_number():map("<leader>tl")
        Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>tC")
        Snacks.toggle.treesitter():map("<leader>tt")
        Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>tb")
        Snacks.toggle.inlay_hints():map("<leader>th")
        Snacks.toggle.indent():map("<leader>ti")
        Snacks.toggle.dim():map("<leader>tD")
    end,
})