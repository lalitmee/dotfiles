-- Miscellaneous AI Tools
--
-- This file contains additional AI tools that complement CodeCompanion:
-- - GitHub Copilot for inline completions
-- - ChatGPT.nvim for additional chat functionality
-- - WTF.nvim for error diagnosis
-- - MCPHub.nvim for MCP protocol integration

local config = require("plugins.ai.config")

-- WTF.nvim provider configuration
local function get_wtf_providers()
    local providers = {}

    if config.api_keys.openai and config.api_keys.openai ~= "" then
        providers.openai = {
            api_key = config.api_keys.openai,
        }
    end

    if config.api_keys.anthropic and config.api_keys.anthropic ~= "" then
        providers.anthropic = {
            api_key = config.api_keys.anthropic,
        }
    end

    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        providers.gemini = {
            api_key = config.api_keys.gemini,
        }
    end

    return providers
end

return {
    { -- [[ copilot.lua ]]
        "zbirenbaum/copilot.lua",
        dependencies = {
            { -- [[ copilot-lsp ]]
                "copilotlsp-nvim/copilot-lsp",
                event = "InsertEnter",
                keys = {
                    { "<C-y>", desc = "Accept Copilot NES suggestion", mode = "n", silent = true },
                },
                init = function()
                    vim.g.copilot_nes_debounce = 500
                    vim.lsp.enable("copilot_ls")
                    vim.keymap.set("n", "<C-y>", function()
                        local bufnr = vim.api.nvim_get_current_buf()
                        local state = vim.b[bufnr].nes_state
                        if state then
                            -- Try to jump to the start of the suggestion edit.
                            -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
                            local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                                or (
                                    require("copilot-lsp.nes").apply_pending_nes()
                                    and require("copilot-lsp.nes").walk_cursor_end_edit()
                                )
                            return nil
                        else
                            -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
                            return "<C-i>"
                        end
                    end, { desc = "Accept Copilot NES suggestion", expr = true })
                end,
            },
        },
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = "<Tab>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-c>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
            vim.g.copilot_settings = { selectedCompletionModel = "gpt-5" }
        end,
    },

    -- ChatGPT.nvim for additional chat functionality
    {
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            {
                "<localleader>ca",
                ":ChatGPTRun add_tests<CR>",
                desc = "Add Tests",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cc",
                ":ChatGPT<CR>",
                desc = "Chatgpt",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cd",
                ":ChatGPTRun docstring<CR>",
                desc = "Docstring",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ce",
                ":ChatGPTEditWithInstructions<CR>",
                desc = "Edit Instructions",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cf",
                ":ChatGPTRun fix_bugs<CR>",
                desc = "Fix Bugs",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cg",
                ":ChatGPTRun grammar_correction<CR>",
                desc = "Grammar Correction",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ch",
                ":ChatGPTActAs<CR>",
                desc = "Act As",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>co",
                ":ChatGPTRun optimize_code<CR>",
                desc = "Optimize Code",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cr",
                ":ChatGPTRun<CR>",
                desc = "Chatgpt Run",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>cs",
                ":ChatGPTRun summarize<CR>",
                desc = "Summarize",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<localleader>ct",
                ":ChatGPTRun translate<CR>",
                desc = "Translate",
                silent = true,
                mode = { "n", "v" },
            },
        },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    -- WTF.nvim for error diagnosis and fixing
    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = function()
            return {
                providers = get_wtf_providers(),
                popup_type = "vertical",
            }
        end,
        keys = {
            {
                "<leader>ea",
                function()
                    require("wtf").diagnose()
                end,
                desc = "Debug diagnostic with AI",
                mode = { "n", "x" },
            },
            {
                "<leader>ef",
                function()
                    require("wtf").fix()
                end,
                desc = "Fix diagnostic with AI",
                mode = { "n", "x" },
            },
            {
                "<leader>es",
                function()
                    require("wtf").search()
                end,
                desc = "Search diagnostic with Google",
            },
            {
                "<leader>em",
                function()
                    require("wtf").pick_provider()
                end,
                desc = "Pick provider",
            },
            {
                "<leader>eh",
                function()
                    require("wtf").history()
                end,
                desc = "Populate the quickfix list with previous chat history",
            },
            {
                "<leader>eg",
                function()
                    require("wtf").grep_history()
                end,
                desc = "Grep previous chat history with Telescope",
            },
        },
    },

    { -- [[ mcphub.nvim ]]
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",
        cmd = {
            "MCPHub",
        },
        keys = {
            { "<leader>cm", ":MCPHub<CR>", desc = "MCP Hub", silent = true, mode = { "n", "v" } },
        },
        opts = {},
    },
}
