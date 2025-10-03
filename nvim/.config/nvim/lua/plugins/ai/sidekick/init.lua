return {
    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
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
                    -- If a sidekick suggestion is available, jump to or apply it.
                    if require("sidekick").nes_jump_or_apply() then
                        return "" -- Keypress handled, do nothing more.
                    end
                    -- If no suggestion, return an empty string to prevent fallback to <C-i>.
                    return ""
                end,
                mode = "n", -- IMPORTANT: Only applies to normal mode.
                expr = true,
                desc = "Sidekick: Goto/Apply Next Edit Suggestion",
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
