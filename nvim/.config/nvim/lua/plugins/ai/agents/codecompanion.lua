local M = {}
local notify = require("plugins.ai.utils.notifications")
local config = require("plugins.ai.codecompanion.config")
local prompts = require("plugins.ai.prompts")

-- CodeCompanion-specific provider management (standardized from adapters)
local function get_providers()
    local providers = {}
    for name, opts in pairs(config.providers) do
        if opts.enabled then
            local api_key = config.api_keys[name] or config.api_keys[opts.api_key or name]
            if api_key or config.special_providers[name] then
                providers[name] = function()
                    local adapter_type = name

                    -- Handle special adapter mappings
                    if name == "copilot_4o" then
                        adapter_type = "copilot"
                    elseif name == "claude_code" then
                        -- Use built-in anthropic adapter with Claude Code configuration
                        return require("codecompanion.adapters").extend("anthropic", {
                            name = "claude_code",
                            formatted_name = "Claude Code",
                            schema = {
                                model = {
                                    order = 1,
                                    mapping = "parameters",
                                    type = "enum",
                                    desc = "The Claude model to use",
                                    default = "claude-sonnet-4-20250514",
                                    choices = {
                                        "claude-sonnet-4-20250514",
                                        "claude-3-5-sonnet-20241022",
                                        "claude-3-5-haiku-20241022",
                                        "claude-3-opus-20240229",
                                    },
                                },
                            },
                        })
                    end

                    -- Use built-in CodeCompanion adapters for standard providers
                    return require("codecompanion.adapters").extend(adapter_type, {
                        schema = {
                            model = {
                                default = config.default_models[name] or config.default_models.copilot,
                            },
                        },
                    })
                end
            else
                notify.warn(
                    "CodeCompanion",
                    "CodeCompanion provider '" .. name .. "' is enabled but missing API key!",
                    vim.log.levels.WARN
                )
            end
        end
    end
    return providers
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
            "CodeCompanionCheckHealth",
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
            local providers = get_providers()
            local default_provider = "copilot" -- fallback

            -- Preferred provider/model selection logic
            -- 1. Use preferred provider if enabled and configured
            -- 2. If not, fall back to first available provider in priority order
            -- 3. Notify user if preferred provider is set but not enabled/configured
            local preferred = config.preferences.preferred_provider
            if preferred then
                if providers[preferred] then
                    default_provider = preferred
                else
                    notify.warn(
                        "CodeCompanion",
                        "CodeCompanion preferred provider '"
                            .. preferred
                            .. "' is not enabled or misconfigured. Falling back to available provider.",
                        vim.log.levels.WARN
                    )
                    local priority = { "claude_code", "anthropic", "openai", "gemini", "copilot" }
                    for _, name in ipairs(priority) do
                        if providers[name] then
                            default_provider = name
                            break
                        end
                    end
                end
            else
                local priority = { "claude_code", "anthropic", "openai", "gemini", "copilot" }
                for _, name in ipairs(priority) do
                    if providers[name] then
                        default_provider = name
                        break
                    end
                end
            end

            return {
                adapters = {
                    http = (function()
                        local http = vim.tbl_extend("force", {}, providers)
                        http.opts = { system_prompt = prompts.beast_mode }
                        return http
                    end)(),
                    acp = {
                        gemini_cli = function()
                            return require("codecompanion.adapters.acp").extend("gemini_cli", {
                                env = {
                                    GEMINI_API_KEY = config.api_keys.gemini
                                        or "cmd:op read op://personal/Gemini_API/credential --no-newline",
                                },
                            })
                        end,
                        claude_code = function()
                            return require("codecompanion.adapters.acp").extend("claude_code", {
                                env = {
                                    ANTHROPIC_API_KEY = config.api_keys.anthropic,
                                },
                            })
                        end,
                    },
                },
                strategies = {
                    chat = {
                        adapter = default_provider,
                        roles = {
                            user = "  lalitmee",
                            llm = function(adapter)
                                return "  CodeCompanion (" .. adapter.formatted_name .. ")"
                            end,
                        },
                        tools = {
                            opts = {
                                auto_submit_errors = true,
                                auto_submit_success = true,
                            },
                        },
                    },
                    inline = {
                        adapter = default_provider,
                    },
                    agent = {
                        adapter = default_provider,
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
                        enabled = true, -- Re-enabled with compatible adapter approach
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
                            -- Dynamically disabled for ACP adapters
                            auto_generate_title = true, -- Will be controlled by runtime check
                            title_generation_opts = {
                                ---Adapter for generating titles (defaults to current chat adapter)
                                adapter = "openai", -- "copilot"
                                ---Model for generating titles (defaults to current chat model)
                                model = "gpt-5", -- "gpt-4o"
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
                                -- Dynamically disabled for ACP adapters
                                create_summary_keymap = "gcs", -- Will be controlled by runtime check
                                -- Keymap to browse summaries (default: "gbs")
                                -- Dynamically disabled for ACP adapters
                                browse_summaries_keymap = "gbs", -- Will be controlled by runtime check

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
        config = function(_, opts)
            require("codecompanion").setup(opts)

            -- ACP adapter detection function
            local function is_acp_adapter(adapter_name)
                local acp_adapters = { gemini_cli = true, claude_code = true }
                return acp_adapters[adapter_name] or false
            end

            -- Get current active adapter
            local function get_current_adapter()
                local cc_config = require("codecompanion.config")
                return cc_config.options
                    and cc_config.options.strategies
                    and cc_config.options.strategies.chat
                    and cc_config.options.strategies.chat.adapter
            end

            -- Function to check adapter type and show warnings
            local function check_and_warn_acp()
                local current_adapter = get_current_adapter()
                if current_adapter and is_acp_adapter(current_adapter) then
                    notify.warn(
                        "CodeCompanion",
                        "Using ACP adapter '"
                            .. current_adapter
                            .. "'. Note: Title generation, summaries, and some history features are disabled for ACP adapters.",
                        vim.log.levels.WARN
                    )
                    return true
                end
                return false
            end

            -- ACP adapter warning system
            vim.api.nvim_create_augroup("CodeCompanion_ACP_Guard", { clear = true })

            -- Show warning when opening chat with ACP adapter
            vim.api.nvim_create_autocmd("User", {
                group = "CodeCompanion_ACP_Guard",
                pattern = "CodeCompanionChatOpened",
                callback = function()
                    check_and_warn_acp()
                end,
            })

            -- Also check when submitting
            vim.api.nvim_create_autocmd("User", {
                group = "CodeCompanion_ACP_Guard",
                pattern = "CodeCompanionRequest*",
                callback = function()
                    check_and_warn_acp()
                end,
            })

            vim.api.nvim_create_user_command("CodeCompanionCheckHealth", function()
                require("plugins.ai.codecompanion.config").check_health()
            end, { desc = "Check CodeCompanion adapter configuration health" })

            -- Debug command to check current adapter
            vim.api.nvim_create_user_command("CodeCompanionDebugAdapter", function()
                local current_adapter = get_current_adapter()
                local is_acp = is_acp_adapter(current_adapter)
                notify.info(
                    "CodeCompanion",
                    "Current adapter: " .. (current_adapter or "none") .. " | ACP: " .. tostring(is_acp)
                )
            end, { desc = "Debug current CodeCompanion adapter" })
        end,
    },
}

return M.plugins
