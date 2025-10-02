return {
    {
        "folke/sidekick.nvim",
        cmd = { "Sidekick" },
        opts = {
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
        },
        keys = {
            { "<localleader>a", group = "sidekick", mode = { "n", "v" } },
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if require("sidekick").nes_jump_or_apply() then
                        return -- jumped or applied
                    end

                    -- if you are using Neovim's native inline completions
                    if vim.lsp.inline_completion.get() then
                        return
                    end

                    -- any other things (like snippets) you want to do on <tab> go here.

                    -- fall back to normal tab
                    return "<tab>"
                end,
                mode = { "i", "n" },
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                desc = "Sidekick Switch Focus",
                mode = { "n", "v" },
            },
            {
                "<localleader>aa",
                function()
                    require("sidekick.cli").toggle({ focus = true })
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "v" },
            },
            {
                "<localleader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "claude", focus = true })
                end,
                desc = "Sidekick Claude Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ag",
                function()
                    require("sidekick.cli").toggle({ name = "gemini", focus = true })
                end,
                desc = "Sidekick Gemini Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ao",
                function()
                    require("sidekick.cli").toggle({ name = "opencode", focus = true })
                end,
                desc = "Sidekick Opencode Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ax",
                function()
                    require("sidekick.cli").toggle({ name = "codex", focus = true })
                end,
                desc = "Sidekick Codex Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ah",
                function()
                    require("sidekick.cli").toggle({ name = "copilot", focus = true })
                end,
                desc = "Sidekick Copilot Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ak",
                function()
                    require("sidekick.cli").toggle({ name = "grok", focus = true })
                end,
                desc = "Sidekick Grok Toggle",
                mode = { "n", "v" },
            },
            {
                "<localleader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                desc = "Sidekick Ask Prompt",
                mode = { "n", "v" },
            },
        },
    },
}
