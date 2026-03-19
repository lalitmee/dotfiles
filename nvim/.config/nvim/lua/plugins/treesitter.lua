return {
    { -- 1. Main Treesitter Plugin
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            local parsers = {
                "angular",
                "bash",
                "c",
                "comment",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "editorconfig",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "graphql",
                "html",
                "http",
                "javascript",
                "jsdoc",
                "json",
                "kdl",
                "liquid",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            }

            require("nvim-treesitter.configs").setup({
                ensure_installed = parsers,
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true, disable = { "css", "python" } },
                matchup = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<localleader>hs",
                        node_incremental = "<localleader>hi",
                        scope_incremental = "<localleader>hc",
                        node_decremental = "<localleader>hd",
                    },
                },
            })

            vim.treesitter.language.register("markdown", "octo")
            vim.treesitter.language.register("bash", "zsh")

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match) or args.match
                    local ok, _ = pcall(vim.treesitter.language.inspect, lang)
                    if ok then
                        vim.treesitter.start()
                    end
                end,
            })
        end,
    },

    { -- 2. Autotag (Standalone)
        enabled = false,
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    { -- 3. Textobjects (Standalone Config)
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main", -- Must match main branch of treesitter
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- Manual Keymap Setup for Main Branch
            -- The main branch of nvim-treesitter-textobjects (required for nvim-treesitter v1.0 main)
            -- no longer supports nested configuration within nvim-treesitter.configs.setup.
            -- Instead, we must use the standalone setup() function and define keymaps manually using vim.keymap.set.
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    include_surrounding_whitespace = false,
                },
                move = {
                    set_jumps = true,
                },
            })

            -- Helper modules
            local ts_select = require("nvim-treesitter-textobjects.select")
            local ts_swap = require("nvim-treesitter-textobjects.swap")
            local ts_move = require("nvim-treesitter-textobjects.move")
            local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

            -- Select Keymaps
            vim.keymap.set({ "x", "o" }, "af", function()
                ts_select.select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                ts_select.select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                ts_select.select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                ts_select.select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "aC", function()
                ts_select.select_textobject("@conditional.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "iC", function()
                ts_select.select_textobject("@conditional.inner", "textobjects")
            end)

            -- Swap Keymaps
            vim.keymap.set("n", "]w", function()
                ts_swap.swap_next("@parameter.inner")
            end)
            vim.keymap.set("n", "[w", function()
                ts_swap.swap_previous("@parameter.inner")
            end)

            -- Move Keymaps
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                ts_move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]k", function()
                ts_move.goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                ts_move.goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]K", function()
                ts_move.goto_next_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                ts_move.goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[k", function()
                ts_move.goto_previous_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                ts_move.goto_previous_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[K", function()
                ts_move.goto_previous_end("@class.outer", "textobjects")
            end)

            -- Repeatable Moves
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })

            -- LSP Interop Keymaps
            vim.keymap.set("n", "<leader>lf", function()
                ts_move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set("n", "<leader>lc", function()
                ts_move.goto_next_start("@class.outer", "textobjects")
            end)
        end,
    },

    { --[[ treesj ]]
        "Wansmer/treesj",
        cmd = {
            "TSJToggle",
            "TSJSplit",
            "TSJJoin",
        },
        keys = {
            { "gS", "<cmd>TSJSplit<CR>", desc = "Split" },
            { "gJ", "<cmd>TSJJoin<CR>", desc = "Join" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            max_join_length = 500,
            use_default_keymaps = false,
        },
    },

    { --[[ ts-node-action ]]
        "ckolkey/ts-node-action",
        keys = {
            {
                "<leader>tk",
                function()
                    require("ts-node-action").node_action()
                end,
                desc = "Trigger Node Action",
                silent = true,
            },
        },
        config = function()
            local helpers = require("ts-node-action.helpers")

            -- Custom Action Definitions
            -- We override specific operators for Javascript to provide
            -- more intuitive toggling behavior (e.g., ++ <-> +=1).
            require("ts-node-action").setup({
                javascript = {
                    ["update_expression"] = function(node)
                        local default_increment_operators = {
                            ["++"] = "+=1",
                            ["+=1"] = "++",
                            ["--"] = "-=1",
                            ["-=1"] = "--",
                        }
                        local replacement = {}
                        for child, _ in node:iter_children() do
                            local text = helpers.node_text(child)
                            if default_increment_operators[text] then
                                table.insert(replacement, default_increment_operators[text])
                            else
                                table.insert(replacement, text)
                            end
                        end
                        return table.concat(replacement, " ")
                    end,
                    ["augmented_assignment_expression"] = function(node)
                        local default_increment_operators = {
                            ["+="] = "++",
                            ["-="] = "--",
                        }
                        local replacement = {}
                        for child, _ in node:iter_children() do
                            local text = helpers.node_text(child)
                            if default_increment_operators[text] then
                                table.insert(replacement, default_increment_operators[text])
                            else
                                table.insert(replacement, text)
                            end
                        end
                        return table.concat(replacement, " ")
                    end,
                },
            })
        end,
    },
}
