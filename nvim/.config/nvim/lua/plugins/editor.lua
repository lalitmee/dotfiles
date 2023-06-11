return {
    { -- [[ nvim-cmp ]]
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "onsails/lspkind.nvim",
            "petertriho/cmp-git",
            "roobert/tailwindcss-colorizer-cmp.nvim",
            "saadparwaiz1/cmp_luasnip",
            "tzachar/fuzzy.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")
            local compare = require("cmp.config.compare")

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
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp", keyword_length = 3 },
                    { name = "nvim_lua", keyword_length = 3 },
                    { name = "luasnip" },
                    { name = "buffer", keyword_length = 3 },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                }),

                sorting = {
                    priority_weight = 2,
                    comparators = {
                        compare.score,
                        compare.recently_used,
                        compare.offset,
                        compare.exact,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
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
                            luasnip = "[SNIP]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[API]",
                            path = "[PATH]",
                        },
                    }),
                },

                experimental = { ghost_text = false },
            })
            require("cmp").config.formatting = {
                format = require("tailwindcss-colorizer-cmp").formatter,
            }

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
        config = function()
            require("Comment").setup({
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
            })

            local comment_ft = require("Comment.ft")
            comment_ft.set("lua", { "--%s", "--[[%s]]" })
            comment_ft.set("kdl", { "//%s" })
        end,
    },

    { --[[ luasnip ]]
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter" },
        dependencies = {
            "rafamadriz/friendly-snippets",
            "honza/vim-snippets",
        },
        config = function()
            local ls = require("luasnip")
            local types = require("luasnip.util.types")
            local extras = require("luasnip.extras")
            local fmt = require("luasnip.extras.fmt").fmt

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
                    local name = vim.split(snip.snippet.env.TM_FILENAME, ".", true)
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
            lk.command("LuaSnipEdit", function()
                require("luasnip.loaders.from_lua").edit_snippet_files()
            end, {})
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
            vim.keymap.set("i", "<c-l>", function()
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

    { --[[ comment frame ]]
        "s1n7ax/nvim-comment-frame",
        opts = {
            keymap = "<localleader>cc",
            multiline_keymap = "<localleader>cC",
        },
        keys = {
            "<localleader>cc",
            "<localleader>cC",
        },
    },

    { --[[ auto-pairs ]]
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

    { --[[ ufo ]]
        "kevinhwang91/nvim-ufo",
        event = { "VeryLazy" },
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
            lk.nnoremap("zk", function()
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
                close_fold_kinds = { "imports" },
                open_fold_hl_timeout = 0,
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    { --[[ yanky ]]
        "gbprod/yanky.nvim",
        event = "VeryLazy",
        dependencies = { "kkharji/sqlite.lua" },
        init = function()
            vim.g.clipboard = {
                name = "xsel_override",
                copy = {
                    ["+"] = "xsel --input --clipboard",
                    ["*"] = "xsel --input --primary",
                },
                paste = {
                    ["+"] = "xsel --output --clipboard",
                    ["*"] = "xsel --output --primary",
                },
                cache_enabled = 1,
            }
        end,
        config = function()
            -- NOTE: setup {{{
            require("yanky").setup({
                highlight = {
                    timer = 40,
                },
                system_clipboard = {
                    sync_with_ring = false,
                },
            })

            -- yanky extension
            require("telescope").load_extension("yank_history")
            -- }}}

            -- NOTE: mappings {{{
            local nmap = lk.nmap
            local xmap = lk.xmap

            -- put mappings
            nmap("P", "<Plug>(YankyPutBefore)", {})
            nmap("gP", "<Plug>(YankyGPutBefore)", {})
            nmap("gp", "<Plug>(YankyGPutAfter)", {})
            nmap("p", "<Plug>(YankyPutAfter)", {})
            xmap("P", "<Plug>(YankyPutBefore)", {})
            xmap("gP", "<Plug>(YankyGPutBefore)", {})
            xmap("gp", "<Plug>(YankyGPutAfter)", {})
            xmap("p", "<Plug>(YankyPutAfter)", {})

            -- yanking mappings
            nmap("y", "<Plug>(YankyYank)", {})
            xmap("y", "<Plug>(YankyYank)", {})

            -- cycle mappings
            nmap("<c-n>", "<Plug>(YankyCycleForward)", {})
            nmap("<c-p>", "<Plug>(YankyCycleBackward)", {})
            -- }}}
        end,
    },

    { --[[ matchup ]]
        "andymass/vim-matchup",
        event = { "VeryLazy" },
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
        cmd = { "Bdelete", "Bwipeout" },
    },

    { --[[ hop ]]
        "phaazon/hop.nvim",
        branch = "v2",
        cmd = {
            "HopPattern",
            "HopChar1AC",
            "HopChar1BC",
            "HopChar1",
            "HopChar2",
            "HopLineStart",
            "HopLine",
            "HopChar2AC",
            "HopChar2BC",
            "HopWord",
            "HopWordMW",
        },
        config = true,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["j"] = {
                    ["name"] = "+jump",
                    ["/"] = { ":HopPattern<CR>", "pattern" },
                    ["a"] = { ":HopAnywhere<CR>", "anywhere" },
                    ["f"] = { ":HopChar1AC<CR>", "char1-ac" },
                    ["F"] = { ":HopChar1BC<CR>", "char1-bc" },
                    ["j"] = { ":HopChar1<CR>", "char1" },
                    ["k"] = { ":HopChar2<CR>", "char2" },
                    ["l"] = { ":HopLineStart<CR>", "line-start" },
                    ["L"] = { ":HopLine<CR>", "line" },
                    ["t"] = { ":HopChar2AC<CR>", "char2-ac" },
                    ["T"] = { ":HopChar2BC<CR>", "char2-bc" },
                    ["w"] = { ":HopWord<CR>", "word" },
                    ["W"] = { ":HopWordMW<CR>", "word-mw" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },

    { --[[ spectre ]]
        "nvim-pack/nvim-spectre",
        cmd = {
            "Spectre",
            "SpectreOpen",
            "SpectreCurWord",
            "SpectreVisual",
            "SpectreCurFileSearch",
        },
        config = function()
            local spectre = require("spectre")

            spectre.setup({
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
            })

            ----------------------------------------------------------------------
            -- NOTE: commands {{{
            ----------------------------------------------------------------------
            local command = lk.command

            command("SpectreOpen", function()
                spectre.open()
            end, {})

            command("SpectreCurWord", function()
                spectre.open_visual({ select_word = true })
            end, {})

            command("SpectreVisual", function()
                spectre.open_visual()
            end, { range = "%" })

            command("SpectreCurFileSearch", function()
                spectre.open_file_search()
            end, { range = "%" })

            -- }}}
            ----------------------------------------------------------------------
        end,
    },

    { --[[ vim-cool ]]
        "romainl/vim-cool",
        event = { "VeryLazy" },
    },

    { --[[ neo-composer ]]
        "ecthelionvi/NeoComposer.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        init = function()
            require("telescope").load_extension("macros")
        end,
        opts = {},
        enabled = false,
    },

    { --[[ oil ]]
        "stevearc/oil.nvim",
        keys = { "-" },
        cmd = { "Oil" },
        config = function()
            require("oil").setup({
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
            })
        end,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = {
                    ["e"] = { ":Oil<CR>", "file-browser" },
                    ["o"] = { ":Oil --float<CR>", "file-browser" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
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

    { --[[ targets ]]
        "wellle/targets.vim",
        event = { "VeryLazy" },
    },

    { --[[ repeat ]]
        "tpope/vim-repeat",
        keys = { "." },
    },

    { --[[ scrptease ]]
        "tpope/vim-scriptease",
        cmd = { "Messages", "Runtime", "Scriptnames", "Time", "Verbose" },
    },

    { --[[ unimpaired ]]
        "tpope/vim-unimpaired",
        event = "VeryLazy",
        enabled = false,
    },

    { --[[ abolish ]]
        "tpope/vim-abolish",
        cmd = { "Abolish", "Subvert", "S" },
        keys = { "crs", "crm", "crc", "cru", "cr-", "cr." },
    },

    { --[[ lualine ]]
        "nvim-lualine/lualine.nvim",
        event = { "BufEnter" },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = {
                    -- ["s"] = {
                    --     function()
                    --         require("lualine").refresh({ scope = "all" })
                    --     end,
                    --     "refresh-lualine",
                    -- },
                    ["r"] = { ":LualineRenameTab<space>", "rename-lualine-tab" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
        config = function()
            local function get_trailing_whitespace()
                local space = vim.fn.search([[\s\+$]], "nwc")
                return space ~= 0 and "TW:" .. space or ""
            end

            local function get_mixed_indent()
                local space_pat = [[\v^ +]]
                local tab_pat = [[\v^\t+]]
                local space_indent = vim.fn.search(space_pat, "nwc")
                local tab_indent = vim.fn.search(tab_pat, "nwc")
                local mixed = (space_indent > 0 and tab_indent > 0)
                local mixed_same_line
                if not mixed then
                    mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
                    mixed = mixed_same_line > 0
                end
                if not mixed then
                    return ""
                end
                if mixed_same_line ~= nil and mixed_same_line > 0 then
                    return "MI:" .. mixed_same_line
                end
                local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
                local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
                if space_indent_cnt > tab_indent_cnt then
                    return "MI:" .. tab_indent
                else
                    return "MI:" .. space_indent
                end
            end

            require("lualine").setup({
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
                        { get_trailing_whitespace },
                        { get_mixed_indent },
                    },
                    lualine_y = {
                        { "tabs", mode = 1 },
                    },
                    lualine_z = {
                        { "progress", color = { gui = "bold" } },
                    },
                },
                extensions = {
                    "fugitive",
                    "fzf",
                    "lazy",
                    "man",
                    "mundo",
                    "nvim-dap-ui",
                    "nvim-tree",
                    "overseer",
                    "quickfix",
                    "toggleterm",
                },
            })
        end,
    },

    { --[[ tabby ]]
        enabled = false,
        "nanozuki/tabby.nvim",
        event = { "VimEnter" },
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
    },

    { --[[ scope.nvim ]]
        "tiagovla/scope.nvim",
        event = { "TabEnter" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        init = function()
            require("telescope").load_extension("scope")
        end,
        config = true,
    },

    { --[[ edgy ]]
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
