return {
    {
        "XXiaoA/atone.nvim",
        cmd = "Atone",
        keys = {
            { "<leader>tu", ":Atone toggle<CR>", desc = "Atone: Undotree", silent = true },
        },
        opts = {},
    },

    { --[[ tabular ]]
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },

    { --[[ surround ]]
        "kylechui/nvim-surround",
        keys = { "ds", "ys", "cs" },
        opts = {},
    },

    { --[[ iswap ]]
        "mizlan/iswap.nvim",
        keys = {
            { "<leader>ii", ":ISwap<CR>", desc = "Iswap", silent = true },
            { "<leader>il", ":ISwapWithLeft<CR>", desc = "Swap With Left", silent = true },
            { "<leader>in", ":ISwapNode<CR>", desc = "Swap Nodes", silent = true },
            { "<leader>ir", ":ISwapWithRight<CR>", desc = "Swap With Right", silent = true },
            { "<leader>iw", ":ISwapWith<CR>", desc = "Swap With", silent = true },
        },
    },

    { --[[ nap.nvim ]]
        "liangxianzhe/nap.nvim",
        keys = { "]", "[" },
        opts = {
            next_prefix = "]",
            prev_prefix = "[",
            next_repeat = "]]",
            prev_repeat = "[[",
            operators = {
                ["q"] = { -- [[ QuickFix Next/Prev ]]
                    next = { rhs = "<cmd>QNext<CR>", opts = { desc = "Next QF Item" } },
                    prev = { rhs = "<cmd>QPrev<CR>", opts = { desc = "Previous QF Item" } },
                },

                ["h"] = { -- [[ Gitsigns Hunk Next/Prev ]]
                    next = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Next hunk" } },
                    prev = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Previous hunk" } },
                },

                ["<Tab>"] = { -- [[ Tab Next/Prev ]]
                    next = { rhs = "<cmd>tabnext<cr>", opts = { desc = "Next tab" } },
                    prev = { rhs = "<cmd>tabprevious<cr>", opts = { desc = "Previous tab" } },
                },

                ["<Space>"] = { -- [[ Empty Line Next/Prev ]]
                    next = { rhs = [[<cmd>call append(line("."), [""])<CR>]], opts = { desc = "Empty line below" } },
                    prev = { rhs = [[<cmd>call append(line(".")-1, [""])<CR>]], opts = { desc = "Empty line above" } },
                },

                ["e"] = { -- [[ Move Line Next/Prev ]]
                    next = { rhs = [[<cmd>m .+1<CR>]], opts = { desc = "Move line down" } },
                    prev = { rhs = [[<cmd>m .-2<CR>]], opts = { desc = "Move line up" } },
                },

                ["t"] = { -- [[ Todo Comments Next/Prev ]]
                    next = {
                        rhs = function()
                            require("todo-comments").jump_next()
                        end,
                        opts = { desc = "Move line down" },
                    },
                    prev = {
                        rhs = function()
                            require("todo-comments").jump_next()
                        end,
                        opts = { desc = "Move line up" },
                    },
                },

                ["j"] = { -- [[ Word Jump Next/Prev ]]
                    next = {
                        rhs = function()
                            Snacks.words.jump(1, true)
                        end,
                        opts = { desc = "Next Word" },
                    },
                    prev = {
                        rhs = function()
                            Snacks.words.jump(-1, true)
                        end,
                        opts = { desc = "Previous Word" },
                    },
                },

                ["f"] = { -- [[ Fold Next/Prev ]]
                    -- Close current fold, jump to next, open it, refresh screen
                    next = { rhs = [[zczjzo<C-l>]], opts = { desc = "next fold" } },
                    -- Close current fold, jump to previous, open it, jump to match, go to line start, refresh
                    prev = { rhs = [[zczkzo%0<C-l>]], opts = { desc = "previous fold" } },
                },
            },
        },
    },

    { --[[ scratch.nvim ]]
        "LintaoAmons/scratch.nvim",
        keys = {
            { "<leader>ka", [[<cmd>Scratch<cr>]], desc = "New Scratch" },
            { "<leader>kc", [[<cmd>ScratchWithName<cr>]], desc = "New Named Scratch" },
            { "<leader>ko", [[<cmd>ScratchOpen<cr>]], desc = "Open Scratch" },
            { "<leader>kf", [[<cmd>ScratchOpenFzf<cr>]], desc = "Grep in Scratch Files" },
        },
        opts = {
            file_picker = "telescope",
            filetypes = { "js", "json", "lua", "org", "sh", "ts", "txt" },
            scratch_file_dir = require("utils.oslib").get_second_brain_path() .. "/scratch/",
        },
    },

    { --[[ navigator ]]
        "numToStr/Navigator.nvim",
        keys = {
            { "<C-h>", "<cmd>NavigatorLeft<cr>", silent = true },
            { "<C-l>", "<cmd>NavigatorRight<cr>", silent = true },
            { "<C-j>", "<cmd>NavigatorDown<cr>", silent = true },
            { "<C-k>", "<cmd>NavigatorUp<cr>", silent = true },
            { "<leader>wh", ":NavigatorLeft<CR>", desc = "Window Left", silent = true },
            { "<leader>wj", ":NavigatorDown<CR>", desc = "Window Down", silent = true },
            { "<leader>wk", ":NavigatorUp<CR>", desc = "Window Up", silent = true },
            { "<leader>wl", ":NavigatorRight<CR>", desc = "Window Right", silent = true },
            { "<leader>wp", ":NavigatorPrevious<CR>", desc = "Window Previous", silent = true },
        },
        opts = {
            auto_save = "all",
        },
    },

    { --[[ harpoon ]]
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        keys = {
            -- file
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "Goto File 1",
                silent = true,
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "Goto File 2",
                silent = true,
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "Goto File 3",
                silent = true,
            },
            {
                "<leader>4",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "Goto File 4",
                silent = true,
            },
            {
                "<leader>5",
                function()
                    require("harpoon"):list():select(5)
                end,
                desc = "Goto File 5",
                silent = true,
            },

            {
                "<leader>fa",
                function()
                    require("harpoon"):list():add()
                end,
                desc = "Add File",
                silent = true,
            },
            {
                "<leader>fm",
                function()
                    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
                end,
                desc = "Toggle Harpoon",
                silent = true,
            },
        },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
            })

            harpoon:extend({
                UI_CREATE = function(cx)
                    vim.keymap.set("n", "<C-v>", function()
                        harpoon.ui:select_menu_item({ vsplit = true })
                    end, { buffer = cx.bufnr })

                    vim.keymap.set("n", "<C-x>", function()
                        harpoon.ui:select_menu_item({ split = true })
                    end, { buffer = cx.bufnr })

                    vim.keymap.set("n", "<C-t>", function()
                        harpoon.ui:select_menu_item({ tabedit = true })
                    end, { buffer = cx.bufnr })
                end,
            })
        end,
    },

    { --[[ browse.nvim ]]
        "lalitmee/browse.nvim",
        dev = true,
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<localleader>b", group = "browse" },
            })
        end,
        cmd = {
            "Browse",
        },
        keys = {
            {
                "<localleader>ba",
                "<cmd>Browse bookmarks<CR>",
                desc = "All Bookmarks (manual + browser)",
                mode = { "n", "x" },
            },
            {
                "<localleader>bb",
                "<cmd>Browse<CR>",
                desc = "Browse",
                mode = { "n", "x" },
            },
            {
                "<localleader>bc",
                function()
                    require("utils.cht").cht()
                end,
                desc = "Cheatsheet",
            },
            {
                "<localleader>bd",
                "<cmd>Browse devdocs<CR>",
                desc = "Devdocs Search",
                mode = { "n", "x" },
            },
            {
                "<localleader>bf",
                "<cmd>Browse devdocs_ft<CR>",
                desc = "Devdocs Filetype Search",
                mode = { "n", "x" },
            },
            {
                "<localleader>bi",
                "<cmd>Browse input<CR>",
                desc = "Input Search",
                mode = { "n", "x" },
            },
            {
                "<localleader>bl",
                "<cmd>Browse bookmarks_manual<CR>",
                desc = "Manual Bookmarks",
                mode = { "n", "x" },
            },
            {
                "<localleader>bB",
                "<cmd>Browse bookmarks_browser<CR>",
                desc = "Browser Bookmarks",
                mode = { "n", "x" },
            },
            {
                "<localleader>bm",
                "<cmd>Browse mdn<CR>",
                desc = "Mdn Search",
                mode = { "n", "x" },
            },
            {
                "<localleader>bM",
                "<cmd>Browse mdn_ft<CR>",
                desc = "Mdn Filetype Search",
                mode = { "n", "x" },
            },
            {
                "<localleader>bs",
                function()
                    require("utils.cht").stack_overflow()
                end,
                desc = "Stackoverflow",
            },
        },
        opts = {
            provider = "duckduckgo", -- google or bing
            persist_grouped_bookmarks_query = false,
            browser_bookmarks = {
                enabled = true,
                browsers = {
                    chrome = true,
                    firefox = true,
                    brave = true,
                },
                group_by_folder = true,
                auto_detect = true,
            },
            themes = {
                browse = "dropdown",
                manual_bookmarks = "dropdown",
                browser_bookmarks = nil, -- nil uses the default Telescope theme
            },
            bookmark_picker = {
                show_nested = true,
            },
        },
        config = function(_, opts)
            local bookmarks = {
                ["work"] = {
                    name = "Work",
                    ["github_pulls"] = "https://github.com/pulls",
                    ["mui"] = "https://mui.com/",
                    ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
                    ["v4-mui"] = "https://v4.mui.com/",
                    ["npm_search"] = "https://npmjs.com/search?q=%s",
                    ["bootstrap"] = "https://getbootstrap.com",
                },
                ["dots"] = {
                    name = "Dotfiles",
                    ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
                    ["akinsho"] = "https://github.com/akinsho/dotfiles",
                    ["tjdevries"] = "https://github.com/tjdevries/config_manager",
                    ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
                    ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
                },
                ["dev"] = {
                    name = "Development",
                    ["pkg.go.dev"] = "https://pkg.go.dev/search?q=%s",
                },
                ["github"] = {
                    name = "GitHub",
                    ["code_search"] = "https://github.com/search?q=%s&type=code",
                    ["issues_search"] = "https://github.com/search?q=%s&type=issues",
                    ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
                    ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
                    ["spec-kit"] = "https://github.com/github/spec-kit",
                },
                ["neovim"] = {
                    name = "Neovim",
                    ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
                    ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
                    ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
                    ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua",
                    ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
                    ["neovim_github"] = "https://github.com/neovim/neovim",
                    ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
                    ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
                },
                ["ai-tools"] = {
                    name = "AI Tools",
                    ["gemini-cli"] = "https://github.com/google-gemini/gemini-cli",
                    ["spec-kit"] = "https://github.com/github/spec-kit",
                    ["chatgpt-web"] = "https://chat.com",
                    ["chatgpt-plus"] = "https://chat.openai.com/",
                    ["claude"] = "https://claude.ai/",
                    ["gemini"] = "https://gemini.google.com/",
                    ["perplexity"] = "https://www.perplexity.ai/",
                    ["opencode"] = "https://opencode.com/",
                },
                ["docs"] = {
                    name = "Documentation",
                    ["devdocs.io"] = "https://devdocs.io/search?q=%s",
                    ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
                    ["mdn"] = "https://developer.mozilla.org/search?q=%s",
                    ["i3wm-docs"] = "https://i3wm.org/docs/",
                    ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
                    ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
                    ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
                },
                ["misc"] = {
                    name = "Miscellaneous",
                    ["i3wm-discussions"] = "https://github.com/i3/i3/discussions",
                    ["dNotes"] = "https://github.com/lalitmee/dNotes",
                    ["amazon.in"] = "https://www.amazon.in/s?k=%s",
                    ["youtube"] = "https://www.youtube.com/results?search_query=%s",
                    ["wikipedia"] = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
                    ["stackoverflow"] = "https://stackoverflow.com/search?q=%s",
                },
                ["reddit"] = {
                    name = "Reddit",
                    ["search"] = "https://www.reddit.com/search?q=%s",
                    ["sub-reddit-search"] = "https://www.reddit.com/search?q=%s&type=sr",
                    ["neovim"] = "https://www.reddit.com/r/neovim",
                    ["workspaces"] = "https://www.reddit.com/r/workspaces",
                    ["vim_porn"] = "https://www.reddit.com/r/vimporn",
                    ["gemini-cli"] = "https://www.reddit.com/r/GeminiCLI",
                    ["claude-ai"] = "https://www.reddit.com/r/ClaudeAI/",
                    ["gemini-ai"] = "https://www.reddit.com/r/GeminiAI",
                },
            }
            opts.bookmarks = vim.tbl_deep_extend("force", opts.bookmarks or {}, bookmarks)
            opts = vim.tbl_deep_extend("force", opts or {}, opts)
            require("browse").setup(opts)
        end,
    },

    { --[[ hardtime ]]
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<leader>tv", ":HardTime toggle<CR>", desc = "Hardtime Toggle", silent = true },
        },
        opts = {
            disabled_filetypes = {
                codecompanion = true,
                harpoon = true,
                lazy = true,
                mason = true,
                toggleterm = true,
                undotree = true,
            },
        },
    },

    { --[[ text-case ]]
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
            require("telescope").load_extension("textcase")
        end,
        keys = {
            { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope", silent = true },
        },
    },

    { --[[ codesnap ]]
        "mistricky/codesnap.nvim",
        build = "make build_generator",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>x", group = "codesnap" },
            })
        end,
        keys = {
            { "<leader>xa", ":CodeSnapASCII<CR>", mode = { "n", "v" }, desc = "Codesnap Ascii", silent = true },
            { "<leader>xh", ":CodeSnapHighlight<CR>", mode = { "n", "v" }, desc = "Codesnap Highlight", silent = true },
            {
                "<leader>xH",
                ":CodeSnapSaveHighlight<CR>",
                mode = { "n", "v" },
                desc = "Codesnap Save Highlight",
                silent = true,
            },
            { "<leader>xs", ":CodeSnap<CR>", mode = { "n", "v" }, desc = "Codesnap", silent = true },
            { "<leader>xS", ":CodeSnapSave<CR>", mode = { "n", "v" }, desc = "Codesnap Save", silent = true },
        },
        opts = {
            save_path = vim.env.HOME .. "/Projects/Personal/Github/code-screenshots",
            -- code_font_family = "MonoLisa Nerd Font",
            -- code_font_family = "JetBrainsMono Nerd Font",
            code_font_family = "SauceCodePro Nerd Font",
            has_line_number = true,
            watermark = "",
        },
    },

    { --[[ trouble.nvim ]]
        "folke/trouble.nvim",
        keys = {
            { "<leader>qx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            {
                "<leader>qX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>qw",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>qL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>qQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {
            focus = true,
        },
    },

    { --[[ marks.nvim ]]
        enabled = false,
        "chentoast/marks.nvim",
        event = "VeryLazy",
        -- stylua: ignore
        keys = {
            { "<leader>ml", ":MarksQFListAll<cr>", desc = "List All Marks Qf", silent = true },
            { "<leader>mq", ":MarksQFListBuf<cr>", desc = "List Buf Marks Qf", silent = true },
            { "<leader>mL", ":MarksQFListGlobal<cr>", desc = "List Global Marks Qf", silent = true },
            { "<leader>ma", ":MarksListAll<cr>", desc = "List All Marks", silent = true },
            { "<leader>mb", ":MarksListBuf<cr>", desc = "List Buf Marks", silent = true },
            { "<leader>mg", ":MarksListGlobal<cr>", desc = "List Global Marks", silent = true },
            { "<leader>mt", ":MarksToggleSigns<cr>", desc = "Toggle Signs", silent = true },
        },
        opts = {
            excluded_filetypes = { "NeogitStatus", "NeogitCommitMessage", "toggleterm" },
        },
    },

    { --[[ flatten.nvim ]]
        "willothy/flatten.nvim",
        lazy = false,
        priority = 1001,
        opts = function()
            local saved_terminal

            return {
                window = {
                    open = "alternate",
                },
                hooks = {
                    should_block = function(argv)
                        -- Note that argv contains all the parts of the CLI command, including
                        -- Neovim's path, commands, options and files.
                        -- See: :help v:argv

                        -- In this case, we would block if we find the `-b` flag
                        -- This allows you to use `nvim -b file1` instead of
                        -- `nvim --cmd 'let g:flatten_wait=1' file1`
                        return vim.tbl_contains(argv, "-b")

                        -- Alternatively, we can block if we find the diff-mode option
                        -- return vim.tbl_contains(argv, "-d")
                    end,
                    pre_open = function()
                        local term = require("toggleterm.terminal")
                        local termid = term.get_focused_id()
                        saved_terminal = term.get(termid)
                    end,
                    post_open = function(bufnr, winnr, ft, is_blocking)
                        if is_blocking and saved_terminal then
                            -- Hide the terminal while it's blocking
                            saved_terminal:close()
                        else
                            -- If it's a normal file, just switch to its window
                            vim.api.nvim_set_current_win(winnr)

                            -- If we're in a different wezterm pane/tab, switch to the current one
                            -- Requires willothy/wezterm.nvim
                            require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
                        end

                        -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
                        -- If you just want the toggleable terminal integration, ignore this bit
                        if ft == "gitcommit" or ft == "gitrebase" then
                            vim.api.nvim_create_autocmd("BufWritePost", {
                                buffer = bufnr,
                                once = true,
                                callback = vim.schedule_wrap(function()
                                    vim.api.nvim_buf_delete(bufnr, {})
                                end),
                            })
                        end
                    end,
                    block_end = function()
                        -- After blocking ends (for a git commit, etc), reopen the terminal
                        vim.schedule(function()
                            if saved_terminal then
                                saved_terminal:open()
                                saved_terminal = nil
                            end
                        end)
                    end,
                },
            }
        end,
    },

    { --[[ http-codes ]]
        "barrett-ruth/http-codes.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>sh", ":HTTPCodes<CR>", desc = "Http Codes", silent = true },
        },
        opts = {
            use = "telescope",
        },
    },

    { --[[ todo-comments.nvim ]]
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        cmd = {
            "TodoTrouble",
            "TodoTelescope",
            "TodoQuickFix",
            "TodoLocList",
            "TodoFzfLua",
        },
        keys = {
            { "<leader>qa", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
            { "<leader>qt", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
            { "<leader>qf", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "TODO/FIX Telescope" },
            { "<leader>qe", "<cmd>TodoTelescope keywords=ERROR,WARN<cr>", desc = "ERROR/WARN Telescope" },
            { "<leader>qN", "<cmd>TodoTelescope keywords=NOTE<cr>", desc = "NOTE Telescope" },
            { "<leader>qF", "<cmd>TodoTelescope keywords=FIXME<cr>", desc = "FIXME Telescope" },
            { "<leader>qP", "<cmd>TodoTelescope keywords=PERF<cr>", desc = "PERF Telescope" },
            { "<leader>qh", "<cmd>TodoTelescope keywords=HACK<cr>", desc = "HACK Telescope" },
            { "<leader>qq", "<cmd>TodoQuickFix<cr>", desc = "Todo Quickfix" },
        },
        opts = {},
    },

    { --[[ persistence.nvim ]]
        "folke/persistence.nvim",
        event = "BufReadPre",

        -- stylua: ignore
        keys = {
            -- load the session for the current directory
            { "<leader>qs", function() require("persistence").load() end, desc = "Load Session" },

            -- select a session to load
            { "<leader>qo", function() require("persistence").select() end, desc = "Select Session" },

            -- load the last session
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load Last Session" },

            -- stop Persistence => session won't be saved on exit
            { "<leader>qd", function() require("persistence").stop() end, desc = "Stop Session" },
        },
        opts = {},
    },

    { --[[ tome ]]
        "laktak/tome",
        cmd = { "TomePlayBook", "TomeScratchPad" },
        keys = {
            {
                "<leader>bt",
                function()
                    vim.cmd("TomePlayBook")
                    vim.notify("Enabled Playbook", vim.log.levels.INFO, { title = "Tome" })
                end,
                desc = "Tome Playbook",
                silent = true,
            },
            { "<localleader>p", "<Plug>(TomePlayLine)", desc = "Tome Play Line", silent = true },
            { "<localleader>P", "<Plug>(TomePlayParagraph)", desc = "Tome Play Paragraph", silent = true },
            { "<localleader>p", "<Plug>(TomePlaySelection)", desc = "Tome Play Selection", silent = true, mode = "x" },
        },
    },

    { --[[ cloak.nvim ]]
        enabled = false,
        "laytan/cloak.nvim",
        event = "VeryLazy",
        opts = {
            patterns = {
                file_pattern = { ".env.*", "credentials*", ".secret-tokens*" },
            },
        },
    },

    { --[[ screenkey.nvim ]]
        "NStefan002/screenkey.nvim",
        keys = {
            { "<leader>tr", ":Screenkey toggle<CR>", desc = "Screenkey Toggle", silent = true },
            { "<leader>tR", ":Screenkey redraw<CR>", desc = "Screenkey Redraw", silent = true },
        },
    },

    { --[[ checkmate.nvim ]]
        "bngarren/checkmate.nvim",
        dependencies = { "folke/snacks.nvim" },
        ft = "markdown",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>T", group = "todo" },
            })
        end,
        keys = {
            {
                "<leader>T.",
                function()
                    -- Get the dynamic file path from our new utility function
                    local todo_file = require("utils.oslib").get_project_todo_path()
                    -- Use the Snacks API to open the specific file
                    Snacks.scratch.open({ icon = " ", ft = "markdown", name = "Todo", file = todo_file })
                end,
                desc = "Toggle Project/Branch Todo",
            },
        },
        opts = {
            files = { "todo.md", "**/todo-*.md" },
            todo_states = {
                unchecked = {
                    marker = "[ ]",
                },
                checked = {
                    marker = "[x]",
                },
            },
            -- todo_states = {
            --     -- Built-in states (cannot change markdown or type)
            --     unchecked = { marker = "□" },
            --     checked = { marker = "✔" },
            --
            --     -- Custom states
            --     in_progress = {
            --         marker = "◐",
            --         markdown = ".", -- Saved as `- [.]`
            --         type = "incomplete", -- Counts as "not done"
            --         order = 50,
            --     },
            --     cancelled = {
            --         marker = "✗",
            --         markdown = "c", -- Saved as `- [c]`
            --         type = "complete", -- Counts as "done"
            --         order = 2,
            --     },
            --     on_hold = {
            --         marker = "⏸",
            --         markdown = "/", -- Saved as `- [/]`
            --         type = "inactive", -- Ignored in counts
            --         order = 100,
            --     },
            -- },
            todo_count_formatter = function(completed, total)
                if completed and total then
                    return string.format("[%d/%d]", completed, total)
                else
                    return ""
                end
            end,
        },
    },
}
