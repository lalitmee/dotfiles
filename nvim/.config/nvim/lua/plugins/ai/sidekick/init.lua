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
                win = {
                    split = {
                        width = 85,
                    },
                },
            },
        },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<localleader>a", group = "sidekick", mode = { "n", "v" } },
            })
        end,
        keys = {
            { -- [[ Next Edit Suggestion ]] --
                "<leader>,",
                function()
                    require("sidekick").nes_jump_or_apply()
                end,
                mode = "n",
                desc = "Sidekick: NES",
            },
            { -- [[ Sidekick Toggle ]] --
                "<leader>.",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle",
                mode = { "n", "x" },
            },
            { -- [[ Sidekick CLI Toggle With Focus ]] --
                "<localleader>aa",
                function()
                    require("sidekick.cli").toggle({ focus = true })
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Select CLI ]] --
                "<localleader>as",
                function()
                    -- require("sidekick.cli").select()
                    require("sidekick.cli").select({ filter = { installed = true } })
                end,
                desc = "Select CLI",
            },
            { -- [[ Sidekick Detach CLI Session ]] --
                "<localleader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
            },

            { -- [[ Sidekick Claude CLI Toggle ]] --
                "<localleader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "claude", focus = true })
                end,
                desc = "Sidekick Claude Toggle",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Gemini CLI Toggle ]] --
                "<localleader>ag",
                function()
                    require("sidekick.cli").toggle({ name = "gemini", focus = true })
                end,
                desc = "Sidekick Gemini Toggle",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Opencode CLI Toggle ]] --
                "<localleader>ao",
                function()
                    require("sidekick.cli").toggle({ name = "opencode", focus = true })
                end,
                desc = "Sidekick Opencode Toggle",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Codex CLI Toggle ]] --
                "<localleader>ax",
                function()
                    require("sidekick.cli").toggle({ name = "codex", focus = true })
                end,
                desc = "Sidekick Codex Toggle",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Copilot CLI Toggle ]] --
                "<localleader>ah",
                function()
                    require("sidekick.cli").toggle({ name = "copilot", focus = true })
                end,
                desc = "Sidekick Copilot Toggle",
                mode = { "n", "v" },
            },
            { -- [[ Sidekick Grok CLI Toggle ]] --
                "<localleader>ak",
                function()
                    require("sidekick.cli").toggle({ name = "grok", focus = true })
                end,
                desc = "Sidekick Grok Toggle",
                mode = { "n", "v" },
            },

            { -- [[ Sidekick Ask Prompt ]] --
                "<localleader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                desc = "Sidekick Ask Prompt",
                mode = { "n", "x" },
            },

            { -- [[ Sidekick Send Commands ]] --
                "<localleader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "n", "x" },
                desc = "Send This",
            },
            { -- [[ Sidekick Send File ]] --
                "<localleader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                mode = { "n", "x" },
                desc = "Send File",
            },
            { -- [[ Sidekick Send Visual Selection ]] --
                "<localleader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
        },
    },
}
