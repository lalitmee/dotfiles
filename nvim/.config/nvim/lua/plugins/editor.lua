local command = lk.command

return {
    { -- [[ blink.cmp ]]
        "saghen/blink.cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "xzbdmw/colorful-menu.nvim", config = {} },
            { "echasnovski/mini.icons", version = "*" },
            "mikavilpas/blink-ripgrep.nvim",
            "moyiz/blink-emoji.nvim",
            {
                "Kaiser-Yang/blink-cmp-dictionary",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        version = "*",
        opts = {
            keymap = {
                preset = "default",
                ["<Tab>"] = {
                    "snippet_forward",
                    function() -- sidekick next edit suggestion
                        return require("sidekick").nes_jump_or_apply()
                    end,
                    function() -- if you are using Neovim's native inline completions
                        return vim.lsp.inline_completion.get()
                    end,
                    "fallback",
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            sources = {
                default = {
                    "lazydev",
                    "snippets",
                    "lsp",
                    "buffer",
                    "ripgrep",
                    "path",
                },

                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },

                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        score_offset = -999,
                        opts = {
                            future_features = {
                                kill_previous_searches = true,
                            },
                        },
                    },

                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        min_keyword_length = 3,
                        opts = {},
                    },

                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 15,
                        opts = { insert = true },
                    },
                },
            },
            enabled = function()
                return not vim.tbl_contains(
                        { "TelescopePrompt", "DressingInput", "chatgpt-input" },
                        vim.bo.filetype
                    )
                    and vim.bo.buftype ~= "prompt"
                    and vim.b.completion ~= false
            end,

            completion = {

                list = {
                    selection = {
                        preselect = true,
                        auto_insert = function(ctx)
                            return ctx.mode == "cmdline"
                        end,
                    },
                },

                menu = {
                    border = "rounded",
                    -- NOTE: by blink.cmp for mini.icon
                    -- draw = {
                    --     columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                    --     components = {
                    --         kind_icon = {
                    --             ellipsis = false,
                    --             text = function(ctx)
                    --                 local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                    --                 return kind_icon
                    --             end,
                    --             -- Optionally, you may also use the highlights from mini.icons
                    --             highlight = function(ctx)
                    --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                    --                 return hl
                    --             end,
                    --         },
                    --     },
                    -- },

                    -- NOTE: by colorful-menu.nvim
                    draw = {
                        columns = { { "kind_icon" }, { "label" }, { "source_name" } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },

                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },
                },

                trigger = {
                    prefetch_on_insert = false,
                },
            },

            signature = {
                enabled = true,
                window = { border = "rounded" },
            },

            snippets = {
                preset = "luasnip",
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },
        },
        opts_extend = { "sources.default" },
    },

    { -- [[ ts-comments.nvim ]]
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    { --[[ luasnip ]]
        "L3MON4D3/LuaSnip",
        keys = {
            { "<leader>ie", ":LuaSnipEdit<CR>", desc = "Edit Snippets" },
        },
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
                provider_selector = function(_, filetype, _)
                    if filetype == "org" then
                        return nil
                    end
                    return { "treesitter", "indent" }
                end,
                disable_filetype = { "org" },
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
            { "<leader>ay", ":YankyRingHistory<CR>", desc = "Yank Ring History" },
            { "<leader>ty", ":Telescope yank_history<CR>", desc = "Yank History" },
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
        event = "VeryLazy",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>j", group = "jump", mode = { "n", "v" } },
            })
        end,
        keys = {
            {
                "<leader>jc",
                mode = { "n", "o", "x", "v" },
                function()
                    require("flash").jump({ continue = true })
                end,
                desc = "Continue Last Search",
            },

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
                "<leader>jj",
                function()
                    require("flash").jump()
                end,
                desc = "Jump",
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
                desc = "Line",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },

            {
                "<leader>jr",
                function()
                    require("flash").remote()
                end,
                desc = "Remote",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },

            {
                "<leader>jt",
                function()
                    require("flash").treesitter()
                end,
                desc = "Treesitter",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },

            {
                "<leader>jw",
                function()
                    require("flash").jump({ pattern = vim.fn.expand("<cword>") })
                end,
                desc = "Current Word",
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
                desc = "Beginning Of Words",
                silent = true,
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
                desc = "Select Word",
                mode = { "n", "v", "x", "o" },
            },

            {
                "<leader>jd",
                function()
                    -- highlights diagnostics and open float after
                    -- choosing the label
                    require("flash").jump({
                        matcher = function(win)
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
                desc = "Diagnostics",
                silent = true,
                mode = { "n", "v", "x", "o" },
            },

            {
                "<leader>jww",
                function()
                    local Flash = require("flash")

                    local function format(opts)
                        -- always show first and second label
                        return {
                            { opts.match.label1, "FlashMatch" },
                            { opts.match.label2, "FlashLabel" },
                        }
                    end

                    Flash.jump({
                        search = { mode = "search" },
                        label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                        pattern = [[\<]],
                        action = function(match, state)
                            state:hide()
                            Flash.jump({
                                search = { max_length = 0 },
                                highlight = { matches = false },
                                label = { format = format },
                                matcher = function(win)
                                    -- limit matches to the current label
                                    return vim.tbl_filter(function(m)
                                        return m.label == match.label and m.win == win
                                    end, state.results)
                                end,
                                labeler = function(matches)
                                    for _, m in ipairs(matches) do
                                        m.label = m.label2 -- use the second label
                                    end
                                end,
                            })
                        end,
                        labeler = function(matches, state)
                            local labels = state:labels()
                            for m, match in ipairs(matches) do
                                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                                match.label2 = labels[(m - 1) % #labels + 1]
                                match.label = match.label1
                            end
                        end,
                    })
                end,
                desc = "2 Char Jump",
                mode = { "n", "v", "x", "o" },
            },
        },
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
                chat = {
                    jump_labels = true,
                },
            },
        },
    },

    { --[[ grug-far ]]
        "MagicDuck/grug-far.nvim",
        event = "VeryLazy",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>ss", group = "grug-far-sar", mode = { "n", "v" } },
            })
        end,
        keys = {
            {
                "<leader>ss/",
                function()
                    require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
                end,
                desc = "File Search",
                silent = true,
            },
            {
                "<leader>sso",
                function()
                    require("grug-far").toggle_instance({ instanceName = "far", staticTitle = "Find and Replace" })
                end,
                desc = "Open",
                silent = true,
            },
            {
                "<leader>ssw",
                function()
                    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
                end,
                desc = "Current Word Search",
                silent = true,
                mode = { "n", "v" },
            },
            {
                "<leader>sse",
                function()
                    require("grug-far").open({ engine = "astgrep" })
                end,
                desc = "AST Grep Engine",
                silent = true,
            },
            {
                "<leader>sst",
                function()
                    require("grug-far").open({ transient = true })
                end,
                desc = "Transient",
                silent = true,
            },
            {
                "<leader>sss",
                [[:<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<CR>]],
                desc = "Current File Search With Visual Selection",
                silent = true,
                mode = { "n", "v" },
            },
        },
        opts = {},
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

    { --[[ oil.nvim ]]
        "stevearc/oil.nvim",
        cmd = { "Oil" },
        keys = {
            { "<leader>ae", ":Oil<CR>", desc = "File Browser", silent = true },
            { "<leader>ao", ":Oil --float<CR>", desc = "File Browser Float", silent = true },
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
            keymaps = {
                gr = {
                    callback = function()
                        -- get the current directory
                        local prefills = { paths = require("oil").get_current_dir() }

                        local grug_far = require("grug-far")
                        -- instance check
                        if not grug_far.has_instance("explorer") then
                            grug_far.open({
                                instanceName = "explorer",
                                prefills = prefills,
                                staticTitle = "Find and Replace from Explorer",
                            })
                        else
                            grug_far.open_instance("explorer")
                            -- updating the prefills without clearing the search and other fields
                            grug_far.update_instance_prefills("explorer", prefills, false)
                        end
                    end,
                    desc = "Oil: Search in directory",
                },
            },
        },
    },

    { --[[ nvim-bqf ]]
        "kevinhwang91/nvim-bqf",
        event = "VeryLazy",
        dependencies = {
            url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
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

    { --[[ vim-repeat ]]
        "tpope/vim-repeat",
        keys = { "." },
    },

    { --[[ scriptease ]]
        "tpope/vim-scriptease",
        cmd = { "Messages", "Runtime", "Scriptnames", "Time", "Verbose" },
        keys = {
            { "<leader>hm", ":Messages<CR>", desc = "Messages", silent = true },
            { "<leader>hv", ":Verbose<space>", desc = "Verbose", silent = true },
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
            { "crs", desc = "Snake Case", mode = { "n", "x", "o", "v" } },
            { "crm", desc = "Mixed Case", mode = { "n", "x", "o", "v" } },
            { "crc", desc = "Camel Case", mode = { "n", "x", "o", "v" } },
            { "cru", desc = "Upper Case", mode = { "n", "x", "o", "v" } },
            { "cr-", desc = "Dash Case", mode = { "n", "x", "o", "v" } },
            { "cr.", desc = "Dot Case", mode = { "n", "x", "o", "v" } },
            {
                "<leader>sl",
                ":S/<C-R><C-W>//<LEFT>",
                mode = "n",
                silent = false,
                desc = "Replace Word <cursor> (line)",
            },
            {
                "<leader>sf",
                ":%S/<C-r><C-w>//c<left><left>",
                mode = "n",
                silent = false,
                desc = "Replace Word <cursor> (file)",
            },
            {
                "<leader>sv",
                [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
                mode = "x",
                silent = false,
                desc = "Replace Word <cursor> (visual)",
            },
        },
    },

    { --[[ lualine.nvim ]]
        "nvim-lualine/lualine.nvim",
        event = "UIEnter",
        keys = {
            { "<leader>wr", ":LualineRenameTab<space>", desc = "Rename Lualine Tab", silent = true },
        },
        opts = {
            options = {
                theme = "cobalt2",
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
                            return str:sub(1, 30)
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
                            error = "E:", -- 
                            warn = "W:", -- 
                            hint = "H:", -- 
                            info = "I:", -- 
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

    { --[[ scope.nvim ]]
        "tiagovla/scope.nvim",
        event = { "TabEnter" },
        config = true,
    },

    { --[[ quicker.nvim ]]
        "stevearc/quicker.nvim",
        event = "FileType qf",
        opts = {},
    },

    { --[[ rip-substitute ]]
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        keys = {
            {
                "<leader>s/",
                function()
                    require("rip-substitute").sub()
                end,
                mode = { "n", "x" },
                desc = "Rip Substitute",
            },
        },
        opts = {},
    },

    { --[[ better-goto-file.nvim ]]
        "ve5li/better-goto-file.nvim",
        keys = {
            "gf",
            "gF",
            "<C-w>f",
            "<C-w>F",
            "<C-w>gf",
            "<C-w>gF",
        },
        opts = {},
    },

    { --[[ neoscroll.nvim ]]
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        opts = {
            duration_multiplier = 0.8,
            hide_cursor = false,
            easing = "linear",
        },
    },
}
