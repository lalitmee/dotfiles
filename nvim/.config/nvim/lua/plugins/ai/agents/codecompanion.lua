local M = {}
local config = require("plugins.ai.config")
local prompts = require("plugins.ai.prompts")

-- CodeCompanion-specific adapter management
local function get_adapters()
    local adapters = {
        copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
                schema = {
                    model = {
                        default = config.default_models.copilot,
                    },
                },
            })
        end,
        copilot_4o = function()
            return require("codecompanion.adapters").extend("copilot", {
                schema = {
                    model = {
                        default = config.default_models.openai,
                    },
                },
            })
        end,
    }

    -- Add BigModel adapter if API key is available
    if config.api_keys.ai_key and config.api_keys.ai_key ~= "" then
        adapters.bigmodel = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                    url = "https://open.bigmodel.cn/api/paas/",
                    api_key = config.api_keys.ai_key,
                    chat_url = "/v4/chat/completions",
                },
                schema = {
                    model = {
                        default = config.default_models.bigmodel,
                    },
                },
            })
        end
    end

    -- Add OpenRouter adapter if API key is available
    if config.api_keys.openrouter and config.api_keys.openrouter ~= "" then
        adapters.openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                    url = "https://openrouter.ai/api",
                    api_key = config.api_keys.openrouter,
                    chat_url = "/v1/chat/completions",
                },
                schema = {
                    model = {
                        default = config.default_models.openrouter,
                    },
                },
            })
        end
    end

    -- Add Tavily adapter if API key is available
    if config.api_keys.tavily and config.api_keys.tavily ~= "" then
        adapters.tavily = function()
            return require("codecompanion.adapters").extend("tavily", {
                env = {
                    api_key = config.api_keys.tavily,
                },
            })
        end
    end

    -- Add Gemini adapter if API key is available
    if config.api_keys.gemini and config.api_keys.gemini ~= "" then
        adapters.gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
                schema = {
                    model = {
                        default = config.default_models.gemini,
                    },
                },
            })
        end
    end

    -- Add Anthropic adapter if API key is available
    if config.api_keys.anthropic and config.api_keys.anthropic ~= "" then
        adapters.anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                    model = {
                        default = config.default_models.anthropic,
                    },
                },
            })
        end
    end

    return adapters
end

M.plugins = {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "ravitemer/mcphub.nvim",
            "jinzhongjia/codecompanion-gitcommit.nvim",
            "franco-ruggeri/codecompanion-spinner.nvim",
            {
                "Davidyz/VectorCode",
                version = "*",
                dependencies = { "nvim-lua/plenary.nvim" },
                cmd = "VectorCode",
            },
        },
        ft = { "gitcommit" },
        cmd = {
            "CodeCompanion",
            "CodeCompanionWithBuffers",
            "CodeCompanionChat",
            "CodeCompanionActions",
            "CodeCompanionGitCommit",
            "CCGitCommit",
        },
        -- stylua: ignore
        keys = {
            { "<leader>ca", ":CodeCompanionActions<CR>", desc = "Code Companion Actions",  silent = true, mode = { "n", "v" } },
            { "<leader>cc", ":CodeCompanionChat<CR>",    desc = "Code Companion Chat",     silent = true, mode = { "n", "v" } },
            { "<leader>cd", ":CodeCompanionCmd<CR>",     desc = "Code Companion Cmd",      silent = true, mode = { "n", "v" } },
            { "<leader>ci", ":CodeCompanion<CR>",        desc = "Code Companion (Inline)", silent = true, mode = { "n", "v" } },
        },
        init = function()
            vim.cmd([[cab cc CodeCompanion]])
        end,
        opts = function()
            local adapters = get_adapters()
            local default_adapter = "copilot" -- fallback

            -- Check if user has a preferred adapter and if it's available
            -- Falls back to dynamic selection if preferred adapter is not available
            if config.agent_preferences.codecompanion.preferred_adapter then
                local preferred = config.agent_preferences.codecompanion.preferred_adapter
                if adapters[preferred] then
                    default_adapter = preferred
                else
                    -- Preferred adapter not available, fall back to dynamic selection
                    if adapters.openai then
                        default_adapter = "openai"
                    elseif adapters.anthropic then
                        default_adapter = "anthropic"
                    elseif adapters.gemini then
                        default_adapter = "gemini"
                    end
                end
            else
                -- Use dynamic selection: Prefer OpenAI if available, then Anthropic, then Gemini, then copilot
                if adapters.openai then
                    default_adapter = "openai"
                elseif adapters.anthropic then
                    default_adapter = "anthropic"
                elseif adapters.gemini then
                    default_adapter = "gemini"
                end
            end

            return {
                opts = {
                    system_prompt = prompts.beast_mode,
                },
                adapters = adapters,
                strategies = {
                    chat = {
                        adapter = default_adapter,
                    },
                    inline = {
                        adapter = default_adapter,
                    },
                    agent = {
                        adapter = default_adapter,
                    },
                },
                extensions = {
                    vectorcode = {
                        opts = {
                            tool_group = {
                                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                                enabled = true,
                                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                                -- if you use @vectorcode_vectorise, it'll be very handy to include
                                -- `file_search` here.
                                extras = {},
                                collapse = true, -- whether the individual tools should be shown in the chat
                            },
                            tool_opts = {
                                ["*"] = {},
                                ls = {},
                                vectorise = {},
                                query = {
                                    max_num = { chunk = -1, document = -1 },
                                    default_num = { chunk = 50, document = 10 },
                                    include_stderr = false,
                                    use_lsp = false,
                                    no_duplicate = true,
                                    chunk_mode = true,
                                    summarise = {
                                        enabled = false,
                                        adapter = nil,
                                        query_augmented = true,
                                    },
                                },
                                files_ls = {},
                                files_rm = {},
                            },
                        },
                    },

                    mcphub = {
                        callback = "mcphub.extensions.codecompanion",
                        opts = {
                            make_vars = true,
                            make_slash_commands = true,
                            show_result_in_chat = true,
                        },
                    },
                    spinner = {},
                    gitcommit = {
                        callback = "codecompanion._extensions.gitcommit",
                        opts = {
                            adapter = "openai",
                            model = "gpt-4.1",
                            languages = { "English" },
                            exclude_files = config.exclude_files,
                            buffer = {
                                enabled = true,
                                keymap = "<leader>gc",
                                auto_generate = true,
                                auto_generate_delay = 200,
                                skip_auto_generate_on_amend = true,
                            },
                            add_slash_command = true,
                            add_git_tool = true,
                            enable_git_read = true,
                            enable_git_edit = true,
                            enable_git_bot = true,
                            add_git_commands = true,
                            git_tool_auto_submit_errors = false,
                            git_tool_auto_submit_success = true,
                            gitcommit_select_count = 100,
                            use_commit_history = true,
                            commit_history_count = 10,
                        },
                    },
                },
            }
        end,
    },
}

return M.plugins
