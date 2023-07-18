return {

    { --[[ treesitter ]]
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                ft = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                },
            },
            {
                "nvim-treesitter/nvim-treesitter-context",
                event = "BufReadPost",
            },
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                event = "BufReadPost",
            },
            {
                "mrjones2014/nvim-ts-rainbow",
                event = "BufReadPost",
                enabled = false,
            },
            {
                "nvim-treesitter/playground",
                cmd = "TSPlaygroundToggle",
            },
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["d"] = {
                    ["name"] = "+docstrings",
                    ["a"] = "doc-node-at-cursor",
                    ["r"] = "doc-all-in-range",
                    ["v"] = "peek-function-definition",
                    ["V"] = "peek-class-definition",
                },
            }, { mode = { "n", "v" }, prefix = "<localleader>" })
        end,
        config = function()
            ----------------------------------------------------------------------
            -- NOTE: treesitter settings {{{
            ----------------------------------------------------------------------
            local parsers = require("nvim-treesitter.parsers")

            ----------------------------------------------------------------------
            -- NOTE: treesitter setup {{{
            ----------------------------------------------------------------------
            require("nvim-treesitter.configs").setup({
                ensure_installed = vim.g.enable_treesitter_ft,
                sync_install = true,
                -- Auto install parsers, if missing, for the current buffer
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "org" },
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                },
                matchup = { enable = true },
                autotag = { enable = true },
                indent = {
                    enable = true,
                    disable = { "css", "python" },
                },
                playground = {
                    enable = true,
                    updatetime = 25,
                    persist_queries = false,
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "[s",
                        node_incremental = "]s",
                        scope_incremental = "]v",
                        node_decremental = "[v",
                    },
                },
                textobjects = {
                    lookahead = true,
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aC"] = "@conditional.outer",
                            ["iC"] = "@conditional.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["]w"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["[w"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]k"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]K"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[k"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[K"] = "@class.outer",
                        },
                    },
                    tree_docs = {
                        enable = true,
                        keymaps = {
                            doc_node_at_cursor = "<localleader>da",
                            doc_all_in_range = "<localleader>dr",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "rounded",
                        peek_definition_code = {
                            ["<localleader>dv"] = "@function.outer",
                            ["<localleader>dV"] = "@class.outer",
                        },
                    },
                },
            })
            -- }}}
            ----------------------------------------------------------------------

            ----------------------------------------------------------------------
            -- NOTE: octo settings {{{
            -- this is to allow markdown highlighting in octo buffers
            ----------------------------------------------------------------------
            local parser_config = parsers.get_parser_configs()
            parser_config.markdown.filetype_to_parsername = "octo"
            -- }}}
            ----------------------------------------------------------------------

            -- }}}
            ----------------------------------------------------------------------
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
            { "gS", "<cmd>TSJSplit<CR>", desc = "split" },
            { "gJ", "<cmd>TSJJoin<CR>", desc = "join" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            max_join_length = 200,
            use_defaul_keymaps = true,
        },
    },

    { --[[ ts-node-action ]]
        "ckolkey/ts-node-action",
        event = { "VeryLazy" },
        dependencies = { "nvim-treesitter" },
        config = function()
            local helpers = require("ts-node-action.helpers")

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

-- vim:foldmethod=marker
