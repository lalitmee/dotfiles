local function sign_in(bufnr, client)
    client:request("signIn", vim.empty_dict(), function(err, result)
        if err then
            vim.notify(err.message, vim.log.levels.ERROR)
            return
        end
        if result.command then
            vim.fn.setreg("+", result.userCode)
            vim.fn.setreg("*", result.userCode)
            local continue = vim.fn.confirm(
                "Copied your one-time code to clipboard.\n" .. "Open the browser to complete the sign-in process?",
                "&Yes\n&No"
            )
            if continue == 1 then
                client:exec_cmd(result.command, { bufnr = bufnr }, function(cmd_err, cmd_result)
                    if cmd_err then
                        vim.notify(cmd_err.message, vim.log.levels.ERROR)
                        return
                    end
                    if cmd_result.status == "OK" then
                        vim.notify("Signed in as " .. cmd_result.user .. ".")
                    end
                end)
            end
        end

        if result.status == "PromptUserDeviceFlow" then
            vim.notify("Enter your one-time code " .. result.userCode .. " in " .. result.verificationUri)
        elseif result.status == "AlreadySignedIn" then
            vim.notify("Already signed in as " .. result.user .. ".")
        end
    end)
end

local function sign_out(_, client)
    client:request("signOut", vim.empty_dict(), function(err, result)
        if err then
            vim.notify(err.message, vim.log.levels.ERROR)
            return
        end
        if result.status == "NotSignedIn" then
            vim.notify("Not signed in.")
        end
    end)
end

return {
    { -- [[ sidekick.nvim ]] --
        "folke/sidekick.nvim",
        cmd = { "Sidekick" },
        event = "VeryLazy",
        opts = {
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
                win = {
                    split = {
                        width = 100,
                    },
                },
            },
        },
        config = function(_, opts)
            require("sidekick").setup(opts)

            -- NES dependency: copilot-language-server LSP client.
            -- Fully self-contained so NES works without touching servers.lua.
            vim.lsp.config("copilot", {
                cmd = { "copilot-language-server", "--stdio" },
                root_markers = { ".git" },
                on_attach = function(client, bufnr)
                    -- Keep windsurf as the sole insert-mode ghost text provider;
                    -- NES uses textDocument/copilotInlineEdit, which is unaffected.
                    if vim.lsp.inline_completion then
                        vim.lsp.inline_completion.enable(false, { client_id = client.id })
                    end
                    vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignIn", function()
                        sign_in(bufnr, client)
                    end, { desc = "Sign in Copilot with GitHub" })
                    vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignOut", function()
                        sign_out(bufnr, client)
                    end, { desc = "Sign out Copilot with GitHub" })
                end,
            })
            vim.lsp.enable("copilot")
        end,
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
