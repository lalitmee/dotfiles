local prompts = require("plugins.ai.prompts")

return {
    { --[[ chatgpt.nvim ]]
        "jackMort/ChatGPT.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<localleader>ca", ":ChatGPTRun add_tests<CR>", desc = "Add Tests", silent = true },
            { "<localleader>cc", ":ChatGPT<CR>", desc = "Chatgpt", silent = true },
            { "<localleader>cd", ":ChatGPTRun docstring<CR>", desc = "Docstring", silent = true },
            { "<localleader>ce", ":ChatGPTEditWithInstructions<CR>", desc = "Edit Instructions", silent = true },
            { "<localleader>cf", ":ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", silent = true },
            { "<localleader>cg", ":ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", silent = true },
            { "<localleader>ch", ":ChatGPTActAs<CR>", desc = "Act As", silent = true },
            { "<localleader>co", ":ChatGPTRun optimize_code<CR>", desc = "Optimize Code", silent = true },
            { "<localleader>cr", ":ChatGPTRun<CR>", desc = "Chatgpt Run", silent = true },
            { "<localleader>cs", ":ChatGPTRun summarize<CR>", desc = "Summarize", silent = true },
            { "<localleader>ct", ":ChatGPTRun translate<CR>", desc = "Translate", silent = true },
        },
        opts = {
            popup_input = {
                submit = "<Enter>",
            },
        },
    },

    { --[[ codecompanion.nvim ]]
        "olimorris/codecompanion.nvim",
        dependencies = {
            "ravitemer/mcphub.nvim",
            "franco-ruggeri/codecompanion-spinner.nvim",
            "jinzhongjia/codecompanion-gitcommit.nvim",
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
            { "<leader>ca", ":CodeCompanionActions<CR>", desc = "Code Companion Actions", silent = true, mode = { "n", "v" } },
            { "<leader>cc", ":CodeCompanionChat<CR>", desc = "Code Companion Chat", silent = true, mode = { "n", "v" } },
            { "<leader>cd", ":CodeCompanionCmd<CR>", desc = "Code Companion Cmd", silent = true, mode = { "n", "v" } },
            { "<leader>ci", ":CodeCompanion<CR>", desc = "Code Companion (Inline)", silent = true, mode = { "n", "v" } },
        },
        init = function()
            vim.cmd([[cab cc CodeCompanion]])
        end,
        opts = {
            opts = {
                system_prompt = prompts.beast_mode,
            },
            strategies = {

                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
                agent = {
                    adapter = "gemini",
                },
            },

            extensions = {
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

                        exclude_files = {
                            "*.pb.go",
                            "*.min.js",
                            "*.min.css",
                            "package-lock.json",
                            "yarn.lock",
                            "*.log",
                            "dist/*",
                            "build/*",
                            ".next/*",
                            "node_modules/*",
                            "vendor/*",
                        },

                        -- Buffer integration
                        buffer = {
                            enabled = true, -- Enable gitcommit buffer keymaps
                            keymap = "<leader>gc", -- Keymap for generating commit messages
                            auto_generate = true, -- Auto-generate on buffer enter
                            auto_generate_delay = 200, -- Auto-generation delay (ms)
                            skip_auto_generate_on_amend = true, -- Skip auto-generation during git commit --amend
                        },

                        -- Feature toggles
                        add_slash_command = true, -- Add /gitcommit slash command
                        add_git_tool = true, -- Add @{git_read} and @{git_edit} tools
                        enable_git_read = true, -- Enable read-only Git operations
                        enable_git_edit = true, -- Enable write-access Git operations
                        enable_git_bot = true, -- Enable @{git_bot} tool group (requires both read/write enabled)
                        add_git_commands = true, -- Add :CodeCompanionGitCommit commands
                        git_tool_auto_submit_errors = false, -- Auto-submit errors to LLM
                        git_tool_auto_submit_success = true, -- Auto-submit success to LLM
                        gitcommit_select_count = 100, -- Number of commits shown in /gitcommit

                        -- Commit history context (optional)
                        use_commit_history = true, -- Enable commit history context
                        commit_history_count = 10, -- Number of recent commits for context
                    },
                },
            },
        },
    },

    { --[[ wtf.nvim ]]
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            providers = {
                openai = {
                    api_key = os.getenv("OPENAI_API_KEY"),
                },
            },
            popup_type = "vertical",
        },
        -- stylua: ignore
        keys = {
            { "<leader>ea", function() require("wtf").diagnose() end, desc = "Debug diagnostic with AI", mode = { "n", "x" } },
            { "<leader>ef", function() require("wtf").fix() end, desc = "Fix diagnostic with AI", mode = { "n", "x" } },
            { "<leader>es", function() require("wtf").search() end, desc = "Search diagnostic with Google" },
            { "<leader>em", function() require("wtf").pick_provider() end, desc = "Pick provider" },
            { "<leader>eh", function() require("wtf").history() end, desc = "Populate the quickfix list with previous chat history" },
            { "<leader>eg", function() require("wtf").grep_history() end, desc = "Grep previous chat history with Telescope" },
        },
    },

    { -- [[ copilot.lua ]]
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
            vim.g.copilot_settings = { selectedCompletionModel = "gpt-4.1-copilot" }
        end,
    },

    { --[[ copilot-chat.nvim ]]
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
            -- model = "gpt-4o",
            -- model = "gemini-2.5-pro",
        },
        config = function(_, opts)
            local Providers = require("CopilotChat.config.providers")

            opts = opts or {}

            opts.providers = {
                github_models = {
                    disabled = true,
                },
                openai = {
                    prepare_input = Providers.copilot.prepare_input,
                    prepare_output = Providers.copilot.prepare_output,

                    get_url = function()
                        return "https://api.openai.com/v1/chat/completions"
                    end,

                    get_headers = function()
                        local api_key = assert(os.getenv("OPENAI_API_KEY"), "OPENAI_API_KEY env var not set")
                        return {
                            Authorization = "Bearer " .. api_key,
                            ["Content-Type"] = "application/json",
                        }
                    end,

                    get_models = function(headers)
                        local response, err =
                            require("CopilotChat.utils").curl_get("https://api.openai.com/v1/models", {
                                headers = headers,
                                json_response = true,
                            })
                        if err then
                            error(err)
                        end
                        return vim.iter(response.body.data)
                            :filter(function(model)
                                local exclude_patterns = {
                                    "audio",
                                    "babbage",
                                    "dall%-e",
                                    "davinci",
                                    "embedding",
                                    "image",
                                    "moderation",
                                    "realtime",
                                    "transcribe",
                                    "tts",
                                    "whisper",
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
                        local response, err =
                            require("CopilotChat.utils").curl_post("https://api.openai.com/v1/embeddings", {
                                headers = headers,
                                json_request = true,
                                json_response = true,
                                body = {
                                    model = "text-embedding-3-small",
                                    input = inputs,
                                },
                            })
                        if err then
                            error(err)
                        end
                        return response.body.data
                    end,
                },

                gemini = {
                    prepare_input = Providers.copilot.prepare_input,
                    prepare_output = Providers.copilot.prepare_output,

                    get_url = function()
                        return "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
                    end,

                    get_headers = function()
                        local api_key = assert(os.getenv("GEMINI_API_KEY"), "GEMINI_API_KEY env not set")
                        return {
                            Authorization = "Bearer " .. api_key,
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
                },
            }

            require("CopilotChat").setup(opts)
        end,
    },

    { --[[ avante.nvim ]]
        "yetone/avante.nvim",
        build = "make",
        version = false,
        cmd = {
            "AvanteAsk",
            "AvanteChat",
            "AvanteInput",
            "AvanteChatNew",
            "AvanteToggle",
        },
        -- stylua: ignore
        keys = {
            { "<localleader>aI", ":AvanteSwitchInputProvider<CR>", desc = "Avante Switch Input Provider", silent = true, mode = { "n", "v" } },
            { "<localleader>aM", ":AvanteModels<CR>", desc = "Avante Models", silent = true, mode = { "n", "v" } },
            { "<localleader>aP", ":AvanteSwitchProvider<CR>", desc = "Avante Switch Provider", silent = true, mode = { "n", "v" } },
            { "<localleader>aa", ":AvanteAsk<CR>", desc = "Avante Ask", silent = true, mode = { "n", "v" } },
            { "<localleader>ab", ":AvanteBuild<CR>", desc = "Avante Build", silent = true, mode = { "n", "v" } },
            { "<localleader>ac", ":AvanteChat<CR>", desc = "Avante Chat", silent = true, mode = { "n", "v" } },
            { "<localleader>ah", ":AvanteHistory<CR>", desc = "Avante History", silent = true, mode = { "n", "v" } },
            { "<localleader>ai", ":AvanteInput<CR>", desc = "Avante Input", silent = true, mode = { "n", "v" } },
            { "<localleader>an", ":AvanteChatNew<CR>", desc = "Avante Chat New", silent = true, mode = { "n", "v" } },
            { "<localleader>ar", ":AvanteClear<CR>", desc = "Avante Clear", silent = true, mode = { "n", "v" } },
            { "<localleader>as", ":AvanteShowRepoMap<CR>", desc = "Avante Show Repo Map", silent = true, mode = { "n", "v" } },
            { "<localleader>at", ":AvanteToggle<CR>", desc = "Avante Toggle", silent = true, mode = { "n", "v" } },
            { "<localleader>ax", ":AvanteStop<CR>", desc = "Avante Stop", silent = true, mode = { "n", "v" } },
        },
        opts = {
            provider = "copilot",
            selector = {
                provider = "telescope",
                provider_opts = {},
                exclude_auto_select = {},
            },
            input = {
                provider = "dressing",
                provider_opts = {},
            },
            windows = {
                width = 40,
            },

            personas = {
                beast_mode = {
                    prompt = prompts.beast_mode,
                    icon = "🔥",
                    provider = "openai",
                    model = "gpt-4.1",
                },

                default = {
                    prompt = "You are a helpful AI assistant.",
                    icon = "🤖",
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
    },

    { --[[ mcphub.nvim ]]
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",
        cmd = {
            "MCPHub",
        },
        keys = {
            { "<localleader>am", ":MCPHub<CR>", desc = "MCP Hub", silent = true, mode = { "n", "v" } },
        },
        opts = {},
    },
}
