-- CodeCompanion AI Assistant Configuration
--
-- Primary AI coding assistant with comprehensive tooling support.
-- Features:
-- - Multiple provider support (Anthropic, OpenAI, Gemini, Copilot)
-- - VectorCode integration for enhanced context
-- - Git integration for commit messages
-- - History management with search/filtering
-- - MCPHub integration for tool extensions
-- - UI spinners for better user experience

local config = require("plugins.ai.config")

-- Provider configuration with enable/disable flags
local providers = {
    copilot = { enabled = true },
    copilot_4o = { enabled = true },
    openai = { enabled = true },
    anthropic = { enabled = true },
    gemini = { enabled = true },
    gemini_cli = { enabled = true }, -- ACP adapter
    claude_code = { enabled = true }, -- ACP adapter
    bigmodel = { enabled = false },
    openrouter = { enabled = false },
    tavily = { enabled = false },
}

-- User preferences
local preferences = {

    --------------------------------------------------------------------------------
    -- NOTE: Provider: anthropic {{{
    --------------------------------------------------------------------------------

    -- preferred_provider = "anthropic",
    -- preferred_model = "claude-3-5-haiku-20241022",

    -- preferred_provider = "anthropic",
    -- preferred_model = "claude-3-5-sonnet-20241022",

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- NOTE: Provider: gemini {{{
    --------------------------------------------------------------------------------

    -- preferred_provider = "gemini",
    -- preferred_model = "gemini-2.5-pro",

    -- preferred_provider = "gemini_cli",
    -- preferred_model = "gemini-2.5-pro",

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- NOTE: Provider: openai {{{
    --------------------------------------------------------------------------------

    -- preferred_provider = "openai",
    -- preferred_model = "gpt-4.1",

    preferred_provider = "openai",
    preferred_model = "gpt-5",

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- NOTE: Provider: openrouter {{{
    --------------------------------------------------------------------------------

    -- preferred_provider = "openrouter",
    -- preferred_model = "claude-3-5-sonnet-20241022",

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------
}

-- Beast mode prompt for advanced AI assistance
local beast_mode_prompt = [[
---
description: '4.1 Beast Mode (Neovim CodeCompanion)'
tools: ['read_file', 'create_file', 'insert_edit_into_file', 'grep_search', 'file_search', 'cmd_runner', 'get_changed_files', 'search_web', 'fetch_webpage', 'vectorcode_toolbox', 'mcp']
---

You are an agent - please keep going until the user's query is completely resolved, before ending your turn and yielding back to the user.

Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.

You MUST iterate and keep going until the problem is solved.

I want you to fully solve this autonomously before coming back to me.

Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.

Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.

Available tools:
- read_file: Read contents of files in the project
- create_file: Create new files with specified content
- insert_edit_into_file: Edit existing files with precise changes
- grep_search: Search for patterns across files using grep
- file_search: Search for files by name or pattern
- cmd_runner: Execute shell commands
- get_changed_files: Get list of changed files (useful for git workflows)
- search_web: Search the web for information
- fetch_webpage: Fetch content from web pages
- vectorcode_toolbox: Advanced semantic code search and analysis (includes vectorcode_ls, vectorcode_query, vectorcode_vectorise)
- mcp: Access tools and resources from MCP servers (use_mcp_tool, access_mcp_resource)
]]

-- Generate available providers based on API key availability
local function get_available_providers()
    local available = {}

    for name, opts in pairs(providers) do
        if opts.enabled then
            local api_key = config.api_keys[name] or config.api_keys[opts.api_key or name]
            if api_key or config.special_providers[name] then
                available[name] = function()
                    local adapter_type = name

                    -- Handle special adapter mappings
                    if name == "copilot_4o" then
                        adapter_type = "copilot"
                    end

                    -- Use built-in CodeCompanion adapters
                    return require("codecompanion.adapters").extend(adapter_type, {
                        schema = {
                            model = {
                                default = config.default_models[name] or config.default_models.copilot,
                            },
                        },
                    })
                end
            end
        end
    end

    return available
end

-- Determine default provider with fallback logic
local function get_default_provider(available_providers)
    -- Use preferred if available
    if preferences.preferred_provider and available_providers[preferences.preferred_provider] then
        return preferences.preferred_provider
    end

    -- Fallback priority order
    local priority = { "anthropic", "claude_code", "openai", "gemini", "copilot" }
    for _, name in ipairs(priority) do
        if available_providers[name] then
            return name
        end
    end

    return "copilot" -- Ultimate fallback
end

return {
    "olimorris/codecompanion.nvim",
    build = function()
        local plugin_path = vim.fn.stdpath("data") .. "/lazy/codecompanion.nvim"
        local patch_file = vim.fn.stdpath("config") .. "/patches/codecompanion/skip_oauth.patch"
        vim.system({ "patch", "-d", plugin_path, "-p1", "-i", patch_file }, { text = true }, function(obj)
            vim.schedule(function()
                if obj.code == 0 then
                    vim.notify("Patched codecompanion.nvim successfully", vim.log.levels.INFO)
                end
            end)
        end)
    end,
    dependencies = {
        "ravitemer/mcphub.nvim",
        "ravitemer/codecompanion-history.nvim",
        {
            "jinzhongjia/codecompanion-gitcommit.nvim",
            tag = "0.0.17",
        },
        {
            "Davidyz/VectorCode",
            version = "*",
            cmd = "VectorCode",
        },
        {
            "hakonharnes/img-clip.nvim",
            keys = {
                {
                    "<leader>cp",
                    "<cmd>PasteImage<CR>",
                    desc = "Paste Image from system's Clipboard",
                    silent = true,
                },
            },
            opts = {},
        },
        {
            "lalitmee/codecompanion-spinners.nvim",
            dev = true,
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
    keys = {
        {
            "<leader>ca",
            ":CodeCompanionActions<CR>",
            desc = "Code Companion Actions",
            silent = true,
            mode = { "n", "v" },
        },
        { "<leader>cc", ":CodeCompanionChat<CR>", desc = "Code Companion Chat", silent = true, mode = { "n", "v" } },
        { "<leader>cd", ":CodeCompanionCmd<CR>", desc = "Code Companion Cmd", silent = true, mode = { "n", "v" } },
        { "<leader>ci", ":CodeCompanion<CR>", desc = "Code Companion (Inline)", silent = true, mode = { "n", "v" } },
    },
    init = function()
        vim.cmd([[cab cc CodeCompanion]])
    end,
    opts = function()
        local available_providers = get_available_providers()
        local default_provider = get_default_provider(available_providers)

        return {
            adapters = {
                http = (function()
                    local http = vim.tbl_extend("force", {}, available_providers)
                    http.opts = { system_prompt = beast_mode_prompt }
                    return http
                end)(),
                acp = {
                    gemini_cli = function()
                        return require("codecompanion.adapters").extend("gemini_cli", {
                            commands = {
                                flash = {
                                    "gemini",
                                    "--experimental-acp",
                                    "-m",
                                    "gemini-2.5-flash",
                                },
                                pro = {
                                    "gemini",
                                    "--experimental-acp",
                                    "-m",
                                    "gemini-2.5-pro",
                                },
                            },
                            defaults = {
                                auth_method = "oauth-personal", -- "oauth-personal" | "gemini-api-key" | "vertex-ai"
                            },

                            env = {
                                GEMINI_API_KEY = config.api_keys.gemini,
                            },
                        })
                    end,
                    claude_code = function()
                        return require("codecompanion.adapters").extend("claude_code", {
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
                        user = lk.style.icons.ui.User .. "  " .. "lalitmee",
                        llm = function(adapter)
                            return lk.style.icons.ui.Bot .. "  " .. "CodeCompanion (" .. adapter.formatted_name .. ")"
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
                spinner = {
                    enabled = true,
                    opts = {
                        -- style = "cursor-relative",
                        -- style = "native",
                        -- style = "lualine",
                        -- style = "fidget",
                        style = "snacks",
                        -- style = "none",
                    },
                },

                -- VectorCode integration for enhanced context
                vectorcode = {
                    opts = {
                        tool_group = {
                            enabled = true,
                            extras = {},
                            collapse = true,
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

                -- MCPHub integration for additional tools
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true,
                    },
                },

                -- Git integration
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

                -- History management
                history = {
                    enabled = true,
                    opts = {
                        keymap = "gh",
                        save_chat_keymap = "sc",
                        auto_save = true,
                        expiration_days = 0,
                        picker = "telescope",
                        chat_filter = nil,
                        picker_keymaps = {
                            rename = { n = "r", i = "<M-r>" },
                            delete = { n = "d", i = "<M-d>" },
                            duplicate = { n = "<C-y>", i = "<C-y>" },
                        },
                        auto_generate_title = true,
                        title_generation_opts = {
                            adapter = "openai",
                            model = "gpt-4o",
                            refresh_every_n_prompts = 0,
                            max_refreshes = 3,
                            format_title = function(original_title)
                                return original_title
                            end,
                        },
                        continue_last_chat = false,
                        delete_on_clearing_chat = false,
                        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                        enable_logging = false,

                        -- Summary system
                        summary = {
                            create_summary_keymap = "gcs",
                            browse_summaries_keymap = "gbs",
                            generation_opts = {
                                adapter = nil,
                                model = nil,
                                context_size = 90000,
                                include_references = true,
                                include_tool_outputs = true,
                                system_prompt = nil,
                                format_summary = nil,
                            },
                        },

                        -- Memory system (requires VectorCode CLI)
                        memory = {
                            auto_create_memories_on_summary_generation = true,
                            vectorcode_exe = "vectorcode",
                            tool_opts = {
                                default_num = 10,
                            },
                            notify = true,
                            index_on_startup = false,
                        },
                    },
                },
            },
            prompt_library = {
                ["Custom Commit"] = {
                    prompt = require("plugins.ai.codecompanion.commit"),
                    description = "Generate git commit message and commit it",
                    opts = {
                        is_slash_cmd = true,
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        require("codecompanion").setup(opts)

        -- Create health check command
        vim.api.nvim_create_user_command("CodeCompanionCheckHealth", function()
            local available = 0
            local total = 0
            local issues = {}

            for name, provider_opts in pairs(providers) do
                total = total + 1
                if provider_opts.enabled then
                    local api_key = config.api_keys[name] or config.api_keys[provider_opts.api_key or name]
                    if api_key or config.special_providers[name] then
                        available = available + 1
                        vim.notify(string.format("✅ Provider '%s' is configured", name))
                    else
                        table.insert(issues, name)
                        vim.notify(
                            string.format("❌ Provider '%s' is enabled but missing API key", name),
                            vim.log.levels.WARN
                        )
                    end
                else
                    vim.notify(string.format("⚪ Provider '%s' is disabled", name))
                end
            end

            vim.notify(
                string.format("🤖 CodeCompanion Health: %d/%d providers available", available, total),
                vim.log.levels.INFO
            )

            if #issues > 0 then
                vim.notify("⚠️  Issues found with: " .. table.concat(issues, ", "), vim.log.levels.WARN)
            end
        end, { desc = "Check CodeCompanion provider health" })
    end,
}
