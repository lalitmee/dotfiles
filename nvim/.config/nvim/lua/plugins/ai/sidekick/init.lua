return {
    "folke/sidekick.nvim",
    opts = {
        cli = {
            mux = {
                backend = "tmux",
                enabled = false,
            },
        },
    },
    keys = {
        {
            "<tab>",
            function()
                -- if there is a next edit, jump to it, otherwise apply it if any
                if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>" -- fallback to normal tab
                end
            end,
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
                require("sidekick.cli").select_prompt()
            end,
            desc = "Sidekick Ask Prompt",
            mode = { "n", "v" },
        },
    },
}
