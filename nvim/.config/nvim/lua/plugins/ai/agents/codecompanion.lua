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

    -- Add OpenAI adapter if API key is available
    if config.api_keys.openai and config.api_keys.openai ~= "" then
        adapters.openai = function()
            return require("codecompanion.adapters").extend("openai", {
                schema = {
                    model = {
                        default = config.default_models.openai,
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
            "ravitemer/codecompanion-history.nvim",
            "jinzhongjia/codecompanion-gitcommit.nvim",
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
            require("plugins.ai.spinners.snacks-notifier").setup()
            require("plugins.ai.spinners.cursor-relative").setup()
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
                adapters = {
                    http = (function()
                        local http = vim.tbl_extend("force", {}, adapters)
                        http.opts = { system_prompt = prompts.beast_mode }
                        return http
                    end)(),
                },
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

                    history = {
                        enabled = true,
                        opts = {
                            -- Keymap to open history from chat buffer (default: gh)
                            keymap = "gh",
                            -- Keymap to save the current chat manually (when auto_save is disabled)
                            save_chat_keymap = "sc",
                            -- Save all chats by default (disable to save only manually using 'sc')
                            auto_save = true,
                            -- Number of days after which chats are automatically deleted (0 to disable)
                            expiration_days = 0,
                            -- Picker interface (auto resolved to a valid picker)
                            picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
                            ---Optional filter function to control which chats are shown when browsing
                            chat_filter = nil, -- function(chat_data) return boolean end
                            -- Customize picker keymaps (optional)
                            picker_keymaps = {
                                rename = { n = "r", i = "<M-r>" },
                                delete = { n = "d", i = "<M-d>" },
                                duplicate = { n = "<C-y>", i = "<C-y>" },
                            },
                            ---Automatically generate titles for new chats
                            auto_generate_title = true,
                            title_generation_opts = {
                                ---Adapter for generating titles (defaults to current chat adapter)
                                adapter = nil, -- "copilot"
                                ---Model for generating titles (defaults to current chat model)
                                model = nil, -- "gpt-4o"
                                ---Number of user prompts after which to refresh the title (0 to disable)
                                refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                                ---Maximum number of times to refresh the title (default: 3)
                                max_refreshes = 3,
                                format_title = function(original_title)
                                    -- this can be a custom function that applies some custom
                                    -- formatting to the title.
                                    return original_title
                                end,
                            },
                            ---On exiting and entering neovim, loads the last chat on opening chat
                            continue_last_chat = false,
                            ---When chat is cleared with `gx` delete the chat from history
                            delete_on_clearing_chat = false,
                            ---Directory path to save the chats
                            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                            ---Enable detailed logging for history extension
                            enable_logging = false,

                            -- Summary system
                            summary = {
                                -- Keymap to generate summary for current chat (default: "gcs")
                                create_summary_keymap = "gcs",
                                -- Keymap to browse summaries (default: "gbs")
                                browse_summaries_keymap = "gbs",

                                generation_opts = {
                                    adapter = nil, -- defaults to current chat adapter
                                    model = nil, -- defaults to current chat model
                                    context_size = 90000, -- max tokens that the model supports
                                    include_references = true, -- include slash command content
                                    include_tool_outputs = true, -- include tool execution results
                                    system_prompt = nil, -- custom system prompt (string or function)
                                    format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
                                },
                            },

                            -- Memory system (requires VectorCode CLI)
                            memory = {
                                -- Automatically index summaries when they are generated
                                auto_create_memories_on_summary_generation = true,
                                -- Path to the VectorCode executable
                                vectorcode_exe = "vectorcode",
                                -- Tool configuration
                                tool_opts = {
                                    -- Default number of memories to retrieve
                                    default_num = 10,
                                },
                                -- Enable notifications for indexing progress
                                notify = true,
                                -- Index all existing memories on startup
                                -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
                                index_on_startup = false,
                            },
                        },
                    },
                },
            }
        end,
    },
}

return M.plugins
