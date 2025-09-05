local M = {}
local config = require("plugins.ai.copilot-chat.config")
local prompts = require("plugins.ai.prompts")
local notify = require("plugins.ai.utils.notifications")
local health = require("plugins.ai.utils.health")

-- CopilotChat-specific provider management using enable/disable flags
local function get_providers()
    local Providers = require("CopilotChat.config.providers")
    local providers = {}

    for name, opts in pairs(config.providers) do
        if opts.enabled then
            local api_key = config.api_keys[name]
            if name == "github_models" or api_key then
                if name == "openai" then
                    providers.openai = {
                        prepare_input = Providers.copilot.prepare_input,
                        prepare_output = Providers.copilot.prepare_output,
                        get_url = function()
                            return "https://api.openai.com/v1/chat/completions"
                        end,
                        get_headers = function()
                            return {
                                Authorization = "Bearer " .. api_key,
                                ["Content-Type"] = "application/json",
                            }
                        end,
                        get_models = function()
                            return { "gpt-4.1", "gpt-4o", "gpt-4o-mini", "gpt-3.5-turbo" }
                        end,
                        embed = function()
                            return {
                                get_url = function()
                                    return "https://api.openai.com/v1/embeddings"
                                end,
                                get_headers = function()
                                    return {
                                        Authorization = "Bearer " .. api_key,
                                        ["Content-Type"] = "application/json",
                                    }
                                end,
                                get_model = function()
                                    return "text-embedding-3-small"
                                end,
                            }
                        end,
                    }
                elseif name == "gemini" then
                    providers.gemini = {
                        prepare_input = Providers.copilot.prepare_input,
                        prepare_output = Providers.copilot.prepare_output,
                        get_url = function()
                            return "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
                        end,
                        get_headers = function()
                            return {
                                Authorization = "Bearer " .. api_key,
                                ["Content-Type"] = "application/json",
                            }
                        end,
                        get_models = function()
                            return { "gemini-2.5-pro", "gemini-2.0-flash", "gemini-1.5-pro", "gemini-1.5-flash" }
                        end,
                        embed = function()
                            return {
                                get_url = function()
                                    return "https://generativelanguage.googleapis.com/v1beta/models/embedding-001:embedContent"
                                end,
                                get_headers = function()
                                    return {
                                        Authorization = "Bearer " .. api_key,
                                        ["Content-Type"] = "application/json",
                                    }
                                end,
                                get_model = function()
                                    return "embedding-001"
                                end,
                            }
                        end,
                    }
                elseif name == "github_models" then
                    providers.github_models = {
                        disabled = true,
                    }
                end
            else
                notify.provider_missing_key("CopilotChat", name)
            end
        end
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
            {
                "Davidyz/VectorCode",
                version = "*",
                dependencies = { "nvim-lua/plenary.nvim" },
                cmd = "VectorCode",
            },
        },
        build = "make tiktoken",
        cmd = {
            "CopilotChat",
            "CopilotChatAgents",
            "CopilotChatCommit",
            "CopilotChatModels",
            "CopilotChatPrompts",
            "CopilotChatToggle",
            "CopilotChatCheckHealth",
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
        init = function()
            -- Setup spinner integration
            require("plugins.ai.spinners.snacks-notifier").setup()
            require("plugins.ai.spinners.cursor-relative").setup()

            -- Create health check command
            vim.api.nvim_create_user_command("CopilotChatCheckHealth", function()
                config.check_health()
            end, { desc = "Check CopilotChat provider configuration health" })
        end,
        opts = {
            system_prompt = prompts.beast_mode,
        },
        config = function(_, opts)
            opts = opts or {}

            -- Use dynamic provider management
            opts.providers = get_providers()

            -- Preferred provider selection logic
            local preferred = config.preferences.preferred_provider or "openai"
            if not opts.providers[preferred] then
                notify.provider_fallback("CopilotChat", preferred, "available provider")
                for name, _ in pairs(opts.providers) do
                    preferred = name
                    break
                end
            end
            opts.provider = preferred

            -- VectorCode integration for enhanced context
            local vectorcode_ctx = require("vectorcode.integrations.copilotchat").make_context_provider({
                prompt_header = "Here are relevant files from the repository:",
                prompt_footer = "\nConsider this context when answering:",
                skip_empty = true,
            })

            opts.contexts = {
                vectorcode = vectorcode_ctx,
            }

            opts.prompts = {
                Explain = {
                    prompt = "Explain the following code in detail:\n$input",
                    context = { "selection", "vectorcode" },
                },
                Review = {
                    prompt = "Review the following code and provide feedback:\n$input",
                    context = { "selection", "vectorcode" },
                },
                Fix = {
                    prompt = "Fix the following code issues:\n$input",
                    context = { "selection", "vectorcode" },
                },
                Optimize = {
                    prompt = "Optimize the following code for better performance:\n$input",
                    context = { "selection", "vectorcode" },
                },
            }

            require("CopilotChat").setup(opts)
        end,
    },
}

return M.plugins
