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

    { --[[ windsurf.nvim ]]
        "Exafunction/windsurf.vim",
        event = "BufEnter",
        config = function()
            vim.g.codeium_filetypes_disabled_by_default = true
            vim.g.codeium_filetypes = {
                c = true,
                cpp = true,
                gitcommit = true,
                go = true,
                javascript = true,
                javascriptreact = true,
                lua = true,
                python = true,
                rust = true,
                typescript = true,
                typescriptreact = true,
                vim = true,
                yaml = true,
            }
            vim.keymap.set("i", "<Tab>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
        end,
    },

    { --[[ codecompanion.nvim ]]
        "olimorris/codecompanion.nvim",
        cmd = {
            "CodeCompanion",
            "CodeCompanionWithBuffers",
            "CodeCompanionChat",
            "CodeCompanionActions",
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
            strategies = {
                chat = {
                    adapter = "copilot",
                },
                inline = {
                    adapter = "copilot",
                },
                agent = {
                    adapter = "copilot",
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
            openai_api_key = os.getenv("OPENAI_API_KEY"),
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
                enabled = false,
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
    },

    { --[[ copilot-chat.nvim ]]
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        build = "make tiktoken",
        cmd = {
            "CopilotChat",
            "CopilotChatToggle",
            "CopilotChatPrompts",
            "CopilotChatCommit",
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
            model = "gpt-4o",
            -- model = "gpt-4o-mini",
            -- model = "gemini-2.0-flash-001",
            -- model = "claude-3.7-sonnet",
            -- model = "claude-3.7-sonnet-thought",
        },
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
        keys = {
            { "<localleader>aa", ":AvanteAsk<CR>", desc = "Avante Ask", silent = true, mode = { "n", "v" } },
            { "<localleader>ac", ":AvanteChat<CR>", desc = "Avante Chat", silent = true, mode = { "n", "v" } },
            { "<localleader>ai", ":AvanteInput<CR>", desc = "Avante Input", silent = true, mode = { "n", "v" } },
            { "<localleader>an", ":AvanteChatNew<CR>", desc = "Avante Chat", silent = true, mode = { "n", "v" } },
            { "<localleader>at", ":AvanteToggle<CR>", desc = "Avante Toggle", silent = true, mode = { "n", "v" } },
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
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
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
}
