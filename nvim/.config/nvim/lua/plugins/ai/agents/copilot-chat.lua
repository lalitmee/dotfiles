local M = {}
local config = require("plugins.ai.config")
local prompts = require("plugins.ai.prompts")

-- CopilotChat-specific provider management
local function get_providers()
    local Providers = require("CopilotChat.config.providers")
    local providers = {
        github_models = {
            disabled = true,
        },
    }

    -- Add OpenAI provider if API key is available
    if config.api_keys.openai and config.api_keys.openai ~= "" then
        providers.openai = {
            prepare_input = Providers.copilot.prepare_input,
            prepare_output = Providers.copilot.prepare_output,
            get_url = function()
                return "https://api.openai.com/v1/chat/completions"
            end,
            get_headers = function()
                return {
                    Authorization = "Bearer " .. config.api_keys.openai,
                    ["Content-Type"] = "application/json",
                }
            end,
            get_models = function(headers)
                local response, err = require("CopilotChat.utils").curl_get(
                    "https://api.openai.com/v1/models",
                    {
                        headers = headers,
                        json_response = true,
                    }
                )
                if err then
                    error(err)
                end
                return vim.iter(response.body.data)
                    :filter(function(model)
                        local exclude_patterns = {
                            "audio", "babbage", "dall%-e", "davinci",
                            "embedding", "image", "moderation", "realtime",
                            "transcribe", "tts", "whisper",
                        }
                        for _, pattern in ipairs(exclude_patterns) do
                            if model.id:match(pattern) then
                                return false
                            end
                        end
                        return true
                    end)
                    :map(function(model)
                        return {
                            id = model.id,
                            name = model.id,
                        }
                    end)
                    :totable()
            end,
            embed = function(inputs, headers)
                local response, err = require("CopilotChat.utils").curl_post(
                    "https://api.openai.com/v1/embeddings",
                    {
                        headers = headers,
                        json_request = true,
                        json_response = true,
                        body = {
                            model = "text-embedding-3-small",
                            input = inputs,
                        },
                    }
                )
                if err then
                    error(err)
                end
                return response.body.data
            end,
        }
    end

    -- Add Gemini provider if API key is available
    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        providers.gemini = {
            prepare_input = Providers.copilot.prepare_input,
            prepare_output = Providers.copilot.prepare_output,
            get_url = function()
                return "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
            end,
            get_headers = function()
                return {
                    Authorization = "Bearer " .. config.api_keys.gemini,
                    ["Content-Type"] = "application/json",
                }
            end,
            get_models = function(headers)
                local response, err = require("CopilotChat.utils").curl_get(
                    "https://generativelanguage.googleapis.com/v1beta/openai/models",
                    {
                        headers = headers,
                        json_response = true,
                    }
                )
                if err then
                    error(err)
                end
                return vim.tbl_map(function(model)
                    local id = model.id:gsub("^models/", "")
                    return {
                        id = id,
                        name = id,
                        streaming = true,
                        tools = true,
                    }
                end, response.body.data)
            end,
            embed = function(inputs, headers)
                local response, err = require("CopilotChat.utils").curl_post(
                    "https://generativelanguage.googleapis.com/v1beta/openai/embeddings",
                    {
                        headers = headers,
                        json_request = true,
                        json_response = true,
                        body = {
                            input = inputs,
                            model = "text-embedding-004",
                        },
                    }
                )
                if err then
                    error(err)
                end
                return response.body.data
            end,
        }
    end

    return providers
end

M.plugins = {
    -- Copilot.lua (code completion)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<Tab>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-]>",
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
            vim.g.copilot_hide_during_completion = false
            vim.g.copilot_settings = { selectedCompletionModel = config.default_models.github }
        end,
    },

    -- CopilotChat.nvim (chat interface)
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        build = "make tiktoken",
        cmd = {
            "CopilotChat",
            "CopilotChatAgents",
            "CopilotChatCommit",
            "CopilotChatModels",
            "CopilotChatPrompts",
            "CopilotChatToggle",
        },
        keys = {
            {
                "<leader>cg",
                ":CopilotChatToggle<CR>",
                desc = "Github Copilot Chat Toggle",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<leader>cp",
                ":CopilotChatPrompts<CR>",
                desc = "Github Copilot Chat Prompts",
                silent = true,
                mode = { "n", "v" },
            },
        },
        opts = {
            system_prompt = prompts.beast_mode,
        },
        config = function(_, opts)
            opts = opts or {}

            -- Use dynamic provider management
            opts.providers = get_providers()

            require("CopilotChat").setup(opts)
        end,
    },
}

return M.plugins
