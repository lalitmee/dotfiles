local command = lk.command

return {
    { -- [[ nvim-cmp ]]
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "saadparwaiz1/cmp_luasnip",
            "sourcegraph/sg.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            -- Don't show the dumb matching stuff.
            vim.opt.shortmess:append("c")

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = {
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                    -- ["<Tab>"] = cmp.mapping({ i = tab }),
                    -- ["<S-Tab>"] = cmp.mapping({ i = s_tab }),
                    ["<Tab>"] = nil,
                    ["<S-Tab>"] = nil,
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<c-space>"] = cmp.mapping({
                        i = cmp.mapping.complete(),
                        c = function(
                            _ --[[fallback]]
                        )
                            if cmp.visible() then
                                if not cmp.confirm({ select = true }) then
                                    return
                                end
                            else
                                cmp.complete()
                            end
                        end,
                    }),

                    ["<M-y>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        }),
                        { "i", "c" }
                    ),

                    -- Cody completion
                    ["<C-a>"] = cmp.mapping.complete({
                        config = {
                            sources = {
                                { name = "cody" },
                            },
                        },
                    }),

                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                },

                sources = cmp.config.sources({
                    { name = "cody" },
                    {
                        name = "nvim_lsp",
                        keyword_length = 1,
                        entry_filter = function(entry)
                            if
                                entry:get_kind() == require("cmp.types").lsp.CompletionItemKind.Snippet
                                and entry.source:get_debug_name() == "nvim_lsp:emmet_ls"
                            then
                                return false
                            end
                            return true
                        end,
                    },
                    { name = "nvim_lua", keyword_length = 1 },
                    {
                        name = "luasnip",
                        group_index = 1,
                        option = { use_show_condition = true },
                        entry_filter = function()
                            local context = require("cmp.config.context")
                            return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
                        end,
                    },
                    { name = "buffer", keyword_length = 5 },
                    { name = "path" },
                }),

                -- NOTE: copied from TJ
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        -- copied from cmp-under, but I don't think I need the plugin for this.
                        -- I might add some more of my own.
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find("^_+")
                            local _, entry2_under = entry2.completion_item.label:find("^_+")
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                formatting = {
                    format = lspkind.cmp_format({
                        menu = {
                            buffer = "[BUF]",
                            cody = "[CODY]",
                            luasnip = "[SNIP]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[API]",
                            path = "[PATH]",
                        },
                    }),
                },

                experimental = { ghost_text = false },
            })

            -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline({ "/", "?" }, {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = "buffer" },
            --     },
            -- })

            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(":", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = "path" },
            --     }, {
            --         { name = "cmdline" },
            --     }),
            -- })

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" },
                }, {
                    { name = "buffer" },
                    { name = "luasnip" },
                }),
            })
        end,
    },

    { --[[ codeium ]]
        enabled = false,
        "Exafunction/codeium.vim",
        event = { "InsertEnter" },
        cmd = { "Codeium" },
        init = function()
            vim.keymap.set("i", "<Tab>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })

            vim.g.codeium_filetypes = {
                TelescopePrompt = false,
                DressingInput = false,
            }
        end,
        -- enabled = false,
    },

    { --[[ comment.nvim ]]
        "numToStr/Comment.nvim",
        event = { "VeryLazy" },
        opts = {
            ignore = "^$",
            pre_hook = function(ctx)
                local U = require("Comment.utils")

                local location = nil
                if ctx.ctype == U.ctype.blockwise then
                    location = require("ts_context_commentstring.utils").get_cursor_location()
                elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                    location = require("ts_context_commentstring.utils").get_visual_start_location()
                end

                return require("ts_context_commentstring.internal").calculate_commentstring({
                    key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
                    location = location,
                })
            end,
        },
        config = function(_, opts)
            require("Comment").setup(opts)

            local comment_ft = require("Comment.ft")
            comment_ft.set("lua", { "--%s", "--[[%s]]" })
            comment_ft.set("kdl", { "//%s" })
        end,
    },

    { --[[ luasnip ]]
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
            -- "honza/vim-snippets",
        },
        config = function()
            local ls = require("luasnip")
            local types = require("luasnip.util.types")
            local extras = require("luasnip.extras")
            local fmt = require("luasnip.extras.fmt").fmt
            local fmta = require("luasnip.extras.fmt").fmta

            local t, i, c, d, f, s, sn =
                ls.text_node,
                ls.insert_node,
                ls.choice_node,
                ls.dynamic_node,
                ls.function_node,
                ls.snippet,
                ls.snippet_node

            -- NOTE: helper functions {{{
            local firstToUpper = function(str)
                return (str[1]:sub(1, 1):upper() .. str[1]:sub(2))
            end

            -- repeat the same word
            local same = function(index, words)
                words = words or {}
                local first_char_capital = words.first
                return f(function(args)
                    if first_char_capital then
                        return firstToUpper(args[1])
                    end
                    return args[1]
                end, { index })
            end

            -- get the file name of the current file
            local filename = function()
                return f(function(_, snip)
                    local name = vim.split(snip.snippet.env.TM_FILENAME, ".")
                    return name[1] or ""
                end)
            end
            -- }}}

            -- NOTE: configurations {{{
            ls.config.set_config({
                -- This tells LuaSnip to remember to keep around the last snippet.
                -- You can jump back into it even if you move outside of the selection
                history = true,

                updateevents = "TextChanged,TextChangedI",

                enable_autosnippets = true,

                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            hl_mode = "combine",
                            virt_text = { { "● ", "Error" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            hl_mode = "combine",
                            virt_text = { { "● ", "WarningMsg" } },
                        },
                    },
                },
                snip_env = {
                    fmt = fmt,
                    fmta = fmta,
                    match = extras.match,
                    rep = extras.rep,
                    t = t,
                    f = f,
                    c = c,
                    d = d,
                    i = i,
                    s = s,
                    sn = sn,
                    same = same,
                    filename = filename,
                },
            })
            -- }}}

            -- NOTE: loading snippets {{{
            -- NOTE: snippets from extension and from `snippet` dir
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
            ls.filetype_extend("all", { "_" })

            -- NOTE: custom snippets created in `lua` format
            require("luasnip.loaders.from_lua").lazy_load()
            command("LuaSnipEdit", function()
                require("luasnip.loaders").edit_snippet_files()
            end)
            -- }}}

            -- NOTE: key mappings {{{
            -- <c-j> is my forward key
            -- this will jump to the next item within the snippet.
            vim.keymap.set({ "i", "s" }, "<c-j>", function()
                if ls.jumpable(1) then
                    ls.jump(1)
                end
            end, { silent = true })

            -- <c-k> is my jump backwards key.
            -- this always moves to the previous item within the snippet
            vim.keymap.set({ "i", "s" }, "<c-k>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true })

            -- <c-y> is my expansion key
            -- this will expand the current item or jump to the next item within the snippet.
            vim.keymap.set({ "i", "s" }, "<c-y>", function()
                if ls.expandable() then
                    ls.expand()
                end
            end, { silent = true })

            -- <c-l> is selecting within a list of options.
            -- This is useful for choice nodes (introduced in the forthcoming episode 2)
            vim.keymap.set({ "i", "s" }, "<c-l>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end)

            vim.keymap.set("i", "<c-u>", function()
                require("luasnip.extras.select_choice")()
            end)
            -- }}}
        end,
    },

    { --[[ auto-pairs ]]
        enabled = false,
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function()
            local auto_pairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")
            local ts_conds = require("nvim-autopairs.ts-conds")

            auto_pairs.setup({
                enable_abbr = true,
                check_ts = true,
                enable_moveright = true,
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Typing space when (|) -> ( | )
            local brackets = {
                { "(", ")" },
                { "[", "]" },
                { "{", "}" },
            }
            auto_pairs.add_rules({
                Rule(" ", " "):with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),

                -- rule for iabbrev
                Rule(" ", " "):replace_endpair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    if vim.tbl_contains({ "()", "{}", "[]" }, pair) then
                        return " " -- it return space here
                    end
                    return "" -- return empty
                end):with_del(function(opts)
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local context = opts.line:sub(col - 1, col + 2)
                    return vim.tbl_contains({ "(  )", "{  }", "[  ]" }, context)
                end),
            })

            for _, bracket in pairs(brackets) do
                auto_pairs.add_rules({
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(opts)
                            return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                })
            end

            auto_pairs.add_rules({
                -- Typing { when {| -> {{ | }} in Vue files
                Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),

                -- Typing = when () -> () => {|}
                Rule("%(.*%)%s*%=$", "> {}", { "typescript", "typescriptreact", "javascript", "vue" })
                    :use_regex(true)
                    :set_end_pair_length(1),

                -- Typing n when the| -> then|end
                Rule("then", "end", "lua"):end_wise(function(opts)
                    return string.match(opts.line, "^%s*if") ~= nil
                end),
            })
        end,
    },

    { --[[ mini.pairs ]]
        "echasnovski/mini.pairs",
        version = "*",
        config = true,
        event = "VeryLazy",
        -- enabled = false,
    },

    { --[[ ufo ]]
        "kevinhwang91/nvim-ufo",
        event = "BufRead",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            local ufo = require("ufo")

            vim.opt.sessionoptions:append("folds")
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            lk.nnoremap("zR", ufo.openAllFolds, { desc = "open all folds" })
            lk.nnoremap("zM", ufo.closeAllFolds, { desc = "close all folds" })
            lk.nnoremap("zr", require("ufo").openFoldsExceptKinds, { desc = "open folds except kinds" })
            lk.nnoremap("zm", require("ufo").closeFoldsWith, { desc = "close folds with" })
            lk.nnoremap("zK", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end, { desc = "preview fold" })

            ufo.setup({
                fold_virt_text_handler = function(virt_text, lnum, end_lnum, width)
                    local suffix = " {...} ┣━━"
                    local lines = ("┫ %d lines ┣━━"):format(end_lnum - lnum)

                    local cur_width = 0
                    for _, section in ipairs(virt_text) do
                        cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
                    end

                    suffix = suffix .. ("━"):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 10)

                    table.insert(virt_text, { suffix, "Normal" })
                    table.insert(virt_text, { lines, "Normal" })
                    return virt_text
                end,
                close_fold_kinds_for_ft = {
                    javascript = { "imports", "comment" },
                    javascriptreact = { "imports", "comment" },
                    typescript = { "imports", "comment" },
                    typescriptreact = { "imports", "comment" },
                },
                open_fold_hl_timeout = 0,
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    { --[[ yanky ]]
        "gbprod/yanky.nvim",
        keys = {
            { "<c-n>", "<Plug>(YankyCycleForward)", mode = { "n" } },
            { "<c-p>", "<Plug>(YankyCycleBackward)", mode = { "n" } },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n" } },
            { "P", "<Plug>(YankyPutBefore)", mode = { "x" } },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n" } },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "x" } },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n" } },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "x" } },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n" } },
            { "p", "<Plug>(YankyPutAfter)", mode = { "x" } },
            { "y", "<Plug>(YankyYank)", mode = { "n" } },
            { "y", "<Plug>(YankyYank)", mode = { "x" } },
            { "<leader>ay", ":YankyRingHistory<CR>", desc = "yank-ring-history", mode = { "n", "x" } },
            { "<leader>ty", ":Telescope yank_history<CR>", desc = "yank-history", mode = { "n", "x" } },
        },
        dependencies = { "kkharji/sqlite.lua" },
        opts = {
            highlight = {
                timer = 40,
            },
            system_clipboard = {
                sync_with_ring = false,
            },
        },
        config = function(_, opts)
            require("yanky").setup(opts)
            require("telescope").load_extension("yank_history")
        end,
    },

    { --[[ matchup ]]
        "andymass/vim-matchup",
        event = "BufRead",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },

    { --[[ sort ]]
        "christoomey/vim-sort-motion",
        keys = {
            "gs",
            { "gs", mode = "v" },
        },
    },

    { --[[ bufdelete ]]
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete", "Bwipyout" },
    },

    { --[[ flash.nvim ]]
        "folke/flash.nvim",
        keys = {
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
            {
                "<leader>jd",
                function()
                    -- highlights diagnostics and open float after
                    -- choosing the label
                    require("flash").jump({
                        matcher = function(win)
                            ---@param diag Diagnostic
                            return vim.tbl_map(function(diag)
                                return {
                                    pos = { diag.lnum + 1, diag.col },
                                    end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                                }
                            end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
                        end,
                        action = function(match, state)
                            vim.api.nvim_win_call(match.win, function()
                                vim.api.nvim_win_set_cursor(match.win, match.pos)
                                vim.diagnostic.open_float()
                                vim.api.nvim_win_set_cursor(match.win, state.pos)
                            end)
                        end,
                    })
                end,
                desc = "diagnostics",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jj",
                function()
                    require("flash").jump()
                end,
                desc = "jump",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jl",
                function()
                    require("flash").jump({
                        search = { mode = "search" },
                        label = { after = { 0, 0 } },
                        pattern = "^",
                    })
                end,
                desc = "line",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jr",
                function()
                    require("flash").remote()
                end,
                desc = "remote",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>js",
                function()
                    require("flash").jump({
                        search = {
                            mode = function(str)
                                return "\\<" .. str
                            end,
                        },
                    })
                end,
                desc = "beginning-of-words",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jt",
                function()
                    require("flash").treesitter()
                end,
                desc = "treesitter",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jw",
                function()
                    require("flash").jump({
                        pattern = vim.fn.expand("<cword>"),
                    })
                end,
                desc = "current-word",
                mode = { "n", "v", "x", "o" },
            },
            {
                "<leader>jW",
                function()
                    require("flash").jump({
                        pattern = ".", -- initialize pattern with any char
                        search = {
                            mode = function(pattern)
                                -- remove leading dot
                                if pattern:sub(1, 1) == "." then
                                    pattern = pattern:sub(2)
                                end
                                -- return word pattern and proper skip pattern
                                return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
                            end,
                        },
                        -- select the range
                        jump = { pos = "range" },
                    })
                end,
                desc = "select-word",
                mode = { "n", "v", "x", "o" },
            },
        },
        opts = {},
    },

    { --[[ spectre ]]
        "nvim-pack/nvim-spectre",
        keys = {
            {
                "<leader>s/",
                function()
                    require("spectre").open_file_search()
                end,
                desc = "file-search",
                silent = true,
            },
            {
                "<leader>so",
                function()
                    require("spectre").open()
                end,
                desc = "open",
                silent = true,
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "current-word-search",
                silent = true,
            },
            {
                "<leader>so",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "spectre-visual-search",
                silent = true,
                mode = "v",
            },
        },
        opts = {
            default = {
                find = {
                    options = { "ignore-case", "hidden", "line-number" },
                },
            },
            highlight = {
                ui = "String",
                search = "DiffDelete",
                replace = "DiffChange",
            },
        },
    },

    { --[[ muren ]]
        "AckslD/muren.nvim",
        keys = {
            { "<leader>sj", "<CMD>MurenToggle<CR>", desc = "toggle-muren", silent = true },
        },
        opts = {
            patterns_width = 50,
            patterns_height = 20,
            options_width = 30,
            preview_height = 20,
        },
    },

    { --[[ ssr.nvim ]]
        "cshuaimin/ssr.nvim",
        keys = {
            {
                "<leader>se",
                function()
                    require("ssr").open()
                end,
                mode = { "n", "v" },
                desc = "open ssr",
            },
        },
        opts = {
            border = "rounded",
            min_width = 50,
            min_height = 5,
            max_width = 120,
            max_height = 25,
            adjust_window = true,
            keymaps = {
                close = "q",
                next_match = "n",
                prev_match = "N",
                replace_confirm = "<cr>",
                replace_all = "<leader><cr>",
            },
        },
    },

    { --[[ vim-cool ]]
        "romainl/vim-cool",
        event = "BufRead",
    },

    { --[[ neo-composer ]]
        "ecthelionvi/NeoComposer.nvim",
        event = "VeryLazy",
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
            require("NeoComposer").setup()
            require("telescope").load_extension("macros")
        end,
    },

    { --[[ oil ]]
        "stevearc/oil.nvim",
        keys = {
            { "<leader>ae", ":Oil<CR>", desc = "file-browser", silent = true },
            { "<leader>ao", ":Oil --float<CR>", desc = "file-browser-float", silent = true },
        },
        opts = {
            columns = { "icon" },
            float = {
                win_options = {
                    winblend = 0,
                },
                padding = 5,
                max_height = 120,
                max_width = 160,
            },
            view_options = {
                show_hidden = true,
            },
            skip_confirm_for_simple_edits = true,
        },
    },

    { --[[ bqf ]]
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = {
            url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
            ft = "qf",
            config = true,
        },
        opts = {
            auto_enable = true,
            preview = { auto_previw = true, win_height = 25, win_vheight = 25 },
            filter = {
                fzf = {
                    extra_opts = {
                        "--bind",
                        "ctrl-s:select-all,ctrl-d:deselect-all",
                        "--prompt",
                        "Filter > ",
                    },
                },
            },
        },
    },

    { --[[ repeat ]]
        "tpope/vim-repeat",
        keys = { "." },
    },

    { --[[ scrptease ]]
        "tpope/vim-scriptease",
        cmd = { "Messages", "Runtime", "Scriptnames", "Time", "Verbose" },
        keys = {
            { "<leader>hm", ":Messages<CR>", desc = "messages", silent = true },
            { "<leader>hv", ":Verbose<space>", desc = "verbose", silent = true },
        },
    },

    { --[[ unimpaired ]]
        "tpope/vim-unimpaired",
        keys = {
            { "]", mode = { "n", "o", "x" } },
            { "[", mode = { "n", "o", "x" } },
        },
        enabled = false,
    },

    { --[[ abolish ]]
        "tpope/vim-abolish",
        cmd = { "Abolish", "Subvert", "S" },
        keys = {
            { "crs", mode = { "n", "x" } },
            { "crm", mode = { "n", "x" } },
            { "crc", mode = { "n", "x" } },
            { "cru", mode = { "n", "x" } },
            { "cr-", mode = { "n", "x" } },
            { "cr.", mode = { "n", "x" } },
            {
                "<leader>[",
                ":S/<C-R><C-W>//<LEFT>",
                mode = "n",
                silent = false,
                desc = "abolish: replace word under the cursor (line)",
            },
            {
                "<leader>]",
                ":%S/<C-r><C-w>//c<left><left>",
                mode = "n",
                silent = false,
                desc = "abolish: replace word under the cursor (file)",
            },
            {
                "<leader>[",
                [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
                mode = "x",
                silent = false,
                desc = "abolish: replace word under the cursor (visual)",
            },
        },
        config = function()
            vim.cmd([[
                Abolish afterword{,s}                         afterward{}
                Abolish anomol{y,ies}                         anomal{}
                Abolish austrail{a,an,ia,ian}                 austral{ia,ian}
                Abolish cal{a,e}nder{,s}                      cal{e}ndar{}
                Abolish {c,m}arraige{,s}                      {}arriage{}
                Abolish {,in}consistan{cy,cies,t,tly}         {}consisten{}
                Abolish destionation{,s}                      destination{}
                Abolish delimeter{,s}                         delimiter{}
                Abolish {,non}existan{ce,t}                   {}existen{}
                Abolish despara{te,tely,tion}                 despera{}
                Abolish d{e,i}screp{e,a}nc{y,ies}             d{i}screp{a}nc{}
                Abolish euphamis{m,ms,tic,tically}            euphemis{}
                Abolish hense                                 hence
                Abolish {,re}impliment{,s,ing,ed,ation}       {}implement{}
                Abolish improvment{,s}                        improvement{}
                Abolish inherant{,ly}                         inherent{}
                Abolish lastest                               latest
                Abolish {les,compar,compari}sion{,s}          {les,compari,compari}son{}
                Abolish {,un}nec{ce,ces,e}sar{y,ily}          {}nec{es}sar{}
                Abolish {,un}orgin{,al}                       {}origin{}
                Abolish persistan{ce,t,tly}                   persisten{}
                Abolish referesh{,es}                         refresh{}
                Abolish {,ir}releven{ce,cy,t,tly}             {}relevan{}
                Abolish rec{co,com,o}mend{,s,ed,ing,ation}    rec{om}mend{}
                Abolish reproducable                          reproducible
                Abolish resouce{,s}                           resource{}
                Abolish restraunt{,s}                         restaurant{}
                Abolish seperat{e,es,ed,ing,ely,ion,ions,or}  separat{}
                Abolish segument{,s,ed,ation}                 segment{}
                Abolish scflead     supercalifragilisticexpialidocious
                Abolish Tqbf        The quick, brown fox jumps over the lazy dog
                Abolish Lidsa       Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum

                Abolish pattners patterns
                Abolish configuratoin configuration

                Abolish functoin function
                Abolish funtcion function
                Abolish functin function

                Abolish respositories repositories
            ]])
        end,
    },

    { --[[ lualine ]]
        "nvim-lualine/lualine.nvim",
        event = "BufEnter",
        keys = {
            { "<leader>wr", ":LualineRenameTab<space>", desc = "rename-lualine-tab" },
        },
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = {
                    {
                        "searchcount",
                        color = "lualine_b_normal",
                    },
                    {
                        "selectioncount",
                        color = "lualine_b_normal",
                    },
                    {
                        "mode",
                        fmt = function(str)
                            return "<" .. str:sub(1, 1) .. ">"
                        end,
                        color = {
                            gui = "bold",
                        },
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        fmt = function(str)
                            return str:sub(1, 20)
                        end,
                    },
                },
                lualine_c = {
                    { "%=", type = "stl" },
                    {
                        "filetype",
                        icon_only = true,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        path = 4,
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = "E:",
                            warn = "W:",
                            hint = "H:",
                            info = "I:",
                        },
                        always_visible = false,
                    },
                },
                lualine_x = {
                    { require("utils.lualine").get_trailing_whitespace },
                    { require("utils.lualine").get_mixed_indent },
                },
                lualine_y = {
                    { "tabs", mode = 1 },
                },
                lualine_z = {
                    { "progress", color = { gui = "bold" } },
                },
            },
            extensions = { "lazy", "man", "quickfix", "toggleterm" },
        },
    },

    { --[[ tabby ]]
        "nanozuki/tabby.nvim",
        event = "VeryLazy",
        config = function()
            vim.opt.showtabline = 2
            local palette = require("cobalt2.palette")

            local separators = {
                -- right = "",
                -- left = "",
                right = " ",
                left = "",
            }
            local icons = {
                tab = { active = "", inactive = "" },
                win = { top = "", normal = "" },
                tail = "  ",
            }

            local theme = {
                line = { fg = palette.black, bg = palette.cursor_line },
                head = { fg = palette.black, bg = palette.yellow, style = "bold" },
                current_tab = {
                    fg = palette.yellow,
                    bg = palette.darker_blue,
                    style = "bold",
                },
                tab = { fg = palette.white, bg = palette.darker_blue },
                win = { fg = palette.white, bg = palette.darker_blue },
                tail = { fg = palette.black, bg = palette.yellow, style = "bold" },
            }

            local line = function(line)
                local cwd = " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
                return {
                    {
                        { cwd, hl = theme.head },
                        line.sep(separators.right, theme.head, theme.line),
                    },
                    line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current_tab or theme.tab
                        return {
                            line.sep(separators.left, hl, theme.line),
                            tab.is_current() and icons.tab.active or icons.tab.inactive,
                            string.format("%s:", tab.number()),
                            tab.name(),
                            line.sep(separators.right, hl, theme.line),
                            margin = " ",
                            hl = hl,
                        }
                    end),
                    line.spacer(),
                    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                        return {
                            line.sep(separators.left, theme.win, theme.line),
                            win.is_current() and icons.win.top or icons.win.normal,
                            win.buf_name(),
                            line.sep(separators.right, theme.win, theme.line),
                            margin = " ",
                            hl = theme.win,
                        }
                    end),
                    {
                        line.sep(separators.left, theme.tail, theme.line),
                        { icons.tail, hl = theme.tail },
                    },
                    hl = theme.line,
                }
            end

            require("tabby.tabline").set(line, {
                buf_name = { mode = "unique" },
            })
        end,
        enabled = false,
    },

    { --[[ scope.nvim ]]
        "tiagovla/scope.nvim",
        event = { "TabEnter" },
        config = true,
    },

    { --[[ edgy ]]
        enabled = false,
        "folke/edgy.nvim",
        event = "VeryLazy",
        opts = {
            top = {
                {
                    ft = "help",
                    size = { height = 45 },
                    -- only show help buffers
                    filter = function(buf)
                        return vim.bo[buf].buftype == "help"
                    end,
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "gitcommit",
                    size = { height = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
            },

            bottom = {
                {
                    ft = "NeogitPopup",
                    size = { height = 0.4 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "qf",
                    title = "QuickFix",
                    size = { height = 0.4 },
                },
            },

            right = {
                -- {
                --     ft = "NeogitStatus",
                --     size = { width = 0.5 },
                --     wo = { signcolumn = "yes:2" },
                -- },
                {
                    ft = "fugitive",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "spectre_panel",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "oil",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                    filter = function(_, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
            },

            left = {},

            animate = {
                enabled = false,
            },
        },
    },
}
