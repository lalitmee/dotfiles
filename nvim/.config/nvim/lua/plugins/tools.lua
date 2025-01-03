local command = lk.command
local fn = vim.fn

local float_dimensions_opts = { width = 200, height = 50 }

return {
    { --[[ undotree ]]
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
        keys = {
            { "<leader>au", ":UndotreeToggle<CR>", desc = "undo-tree", silent = true },
        },
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
            { "<leader>ii", ":ISwap<CR>", desc = "iswap", silent = true },
            { "<leader>il", ":ISwapWithLeft<CR>", desc = "swap-with-left", silent = true },
            { "<leader>in", ":ISwapNode<CR>", desc = "swap-nodes", silent = true },
            { "<leader>ir", ":ISwapWithRight<CR>", desc = "swap-with-right", silent = true },
            { "<leader>iw", ":ISwapWith<CR>", desc = "swap-with", silent = true },
        },
    },

    { --[[ nap ]]
        "liangxianzhe/nap.nvim",
        keys = { "]", "[" },
        opts = {
            next_prefix = "]",
            prev_prefix = "[",
            next_repeat = "<C-j>",
            prev_repeat = "<C-k>",
            operators = {
                ["q"] = {
                    next = { rhs = "<cmd>QNext<CR>", opts = { desc = "Next QF Item" } },
                    prev = { rhs = "<cmd>QPrev<CR>", opts = { desc = "Previous QF Item" } },
                },
                ["h"] = {
                    next = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Next hunk" } },
                    prev = { rhs = "<cmd>Gitsigns next_hunk<CR>", opts = { desc = "Previous hunk" } },
                },
                ["<Tab>"] = {
                    next = { rhs = "<cmd>tabnext<cr>", opts = { desc = "Next tab" } },
                    prev = { rhs = "<cmd>tabprevious<cr>", opts = { desc = "Previous tab" } },
                },
                ["<Space>"] = {
                    next = { rhs = [[<cmd>call append(line("."), [""])<CR>]], opts = { desc = "Empty line below" } },
                    prev = { rhs = [[<cmd>call append(line(".")-1, [""])<CR>]], opts = { desc = "Empty line above" } },
                },
                ["e"] = {
                    next = { rhs = [[<cmd>m .+1<CR>]], opts = { desc = "Move line down" } },
                    prev = { rhs = [[<cmd>m .-2<CR>]], opts = { desc = "Move line up" } },
                },
                ["t"] = {
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
            },
        },
    },

    { --[[ toggleterm ]]
        "akinsho/toggleterm.nvim",
        keys = {
            [[<C-\>]],
            { "<leader>a/", ":Serpl<CR>", desc = "search-and-replace", silent = true },
            { "<leader>ab", ":Bottom<CR>", desc = "bottom", silent = true },
            { "<leader>ad", ":LazyDocker<CR>", desc = "lazydocker", silent = true },
            { "<leader>ag", ":LazyGit<CR>", desc = "lazygit", silent = true },
            { "<leader>ah", ":ToggleTerm direction=horizontal<CR>", desc = "horizontal-terminal", silent = true },
            { "<leader>ai", ":ChatGPTSh<CR>", desc = "chatgpt", silent = true },
            { "<leader>af", ":GhDash<CR>", desc = "gh-dash", silent = true },
            { "<leader>av", ":ToggleTerm direction=vertical<CR>", desc = "vertical-terminal", silent = true },
            { "<leader>gt", ":Tig<CR>", desc = "tig", silent = true },
        },
        cmd = { "ToggleTerm" },
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            autochdir = true,
            persist_mode = true,
            insert_mappings = false,
            start_in_insert = true,
            winbar = { enabled = lk.ui.winbar.enable },
            float_opts = vim.tbl_extend("keep", {
                border = lk.style.border.rounded,
                winblend = 3,
            }, float_dimensions_opts),
            shade_terminals = false,
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return math.floor(vim.api.nvim_get_option_value("columns", { scope = "local" }) * 0.5)
                end
            end,
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            local float_handler = function(term)
                if not lk.falsy(fn.mapcheck("jk", "t")) then
                    vim.keymap.del("t", "jk", { buffer = term.bufnr })
                    vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
                end
            end

            local Terminal = require("toggleterm.terminal").Terminal

            local serpl = Terminal:new({
                cmd = "serpl",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local chatgpt = Terminal:new({
                cmd = "chatgpt -i",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local gh_dash = Terminal:new({
                cmd = "gh dash",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local bottom = Terminal:new({
                cmd = "btm",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local tig = Terminal:new({
                cmd = "tig",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            command("Serpl", function()
                serpl:toggle()
            end)
            command("LazyDocker", function()
                lazydocker:toggle()
            end)
            command("LazyGit", function()
                lazygit:toggle()
            end)
            command("Bottom", function()
                bottom:toggle()
            end)
            command("ChatGPTSh", function()
                chatgpt:toggle()
            end)
            command("GhDash", function()
                gh_dash:toggle()
            end)
            command("Tig", function()
                tig:toggle()
            end)
        end,
    },

    { --[[ neozoom ]]
        "nyngwang/NeoZoom.lua",
        cmd = { "NeoZoomToggle" },
        config = function()
            require("neo-zoom").setup({
                winopts = {
                    border = "rounded",
                    offset = {
                        height = 0.9,
                        width = 220,
                    },
                },
            })
        end,
    },

    { --[[ orgmode ]]
        "nvim-orgmode/orgmode",
        event = "BufReadPre",
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                config = true,
            },
        },
        opts = {
            org_agenda_files = { "~/Desktop/Github/notes/*.org", "~/Desktop/Github/todos/inbox.org" },
            org_default_notes_file = "~/Desktop/Github/todos/inbox.org",
        },
    },

    { --[[ project ]]
        "ahmedkhalf/project.nvim",
        keys = { "<leader>pp" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern", "lsp" },
                patterns = { ".git" },
                show_hidden = true,
                -- show the message on changing the directory
                silent_chdir = false,
                -- change to the directory of the file in the current tab
                scope_chdir = "tab",
            })
            require("telescope").load_extension("projects")
        end,
        enabled = false,
    },

    { --[[ scretch ]]
        "Sonicfury/scretch.nvim",
        -- stylua: ignore
        keys = {
            { "<leader>ka", function() require("scretch").new() end, desc = "New" },
            { "<leader>kt", function() require("scretch").save_as_template() end, desc = "Save As Template" },
            { "<leader>ke", function() require("scretch").edit_template() end, desc = "Edit Template" },
            { "<leader>kE", function() require("scretch").explore() end, desc = "Explore" },
            { "<leader>ks", function() require("scretch").search() end, desc = "Search" },
            { "<leader>kf", function() require("scretch").new_from_template() end, desc = "From Template" },
            { "<leader>kg", function() require("scretch").grep() end, desc = "Grep" },
            { "<leader>kl", function() require("scretch").last() end, desc = "Last" },
            { "<leader>kn", function() require("scretch").new_named() end, desc = "With Name" },
        },
        opts = {
            scretch_dir = vim.env.HOME .. "/Desktop/Github/notes/",
            templte_dir = vim.env.HOME .. "/Desktop/Github/notes/templates/",
            default_type = "org",
        },
    },

    { --[[ fzf-lua ]]
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        -- stylua: ignore
        keys = {
            "<C-]>",
            "gd",
            { "<leader>F/", ":FzfLua live_grep<CR>", desc = "fzf-live-grep", silent = true },
            { "<leader>FbL", ":FzfLua lines<CR>", desc = "fzf-lines", silent = true },
            { "<leader>Fbb", ":FzfLua buffers<CR>", desc = "fzf-buffers", silent = true },
            { "<leader>Fbl", ":FzfLua blines<CR>", desc = "fzf-buffer-lines", silent = true },
            { "<leader>Fff", ":FzfLua files<CR>", desc = "fzf-files", silent = true },
            { "<leader>Fle", ":FzfLua lsp_document_diagnostics<CR>", desc = "fzf-lsp-document-diagnostics", silent = true },
            { "<leader>FlE", ":FzfLua lsp_workspace_diagnostics<CR>", desc = "fzf-lsp-workspace-diagnostics", silent = true },
            { "<leader>Fll", ":FzfLua lsp_finder<CR>", desc = "fzf-lsp-finder", silent = true },
            { "<leader>Flr", ":FzfLua lsp_references<CR>", desc = "fzf-lsp-references", silent = true },
            { "<leader>Flw", ":FzfLua lsp_document_symbols<CR>", desc = "fzf-lsp-document-symbols", silent = true },
            { "<leader>FlW", ":FzfLua lsp_workspace_symbols<CR>", desc = "fzf-lsp-workspace-symbols", silent = true },
            { "<leader>Fls", ":FzfLua lsp_live_workspace_symbols<CR>", desc = "fzf-lsp-live-workspace-symbols", silent = true },
            { "<leader>FsR", ":FzfLua live_grep_resume<CR>", desc = "fzf-live-grep-resume", silent = true },
            { "<leader>Fsr", ":FzfLua resume<CR>", desc = "fzf-resume", silent = true },
        },
        opts = {
            winopts = {
                width = 0.95,
                height = 0.95,
                preview = {
                    title_pos = "center",
                    scrollbar = "border",
                },
            },
            fzf_opts = {},
            files = { git_icons = false },
            grep = {
                rg_glob = true,
                rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
            },
            file_ignore_patterns = { "node_modules", ".git" },
        },
    },

    { --[[ navigator ]]
        "numToStr/Navigator.nvim",
        keys = {
            { "<C-h>", "<cmd>NavigatorLeft<cr>", silent = true },
            { "<C-l>", "<cmd>NavigatorRight<cr>", silent = true },
            { "<C-j>", "<cmd>NavigatorDown<cr>", silent = true },
            { "<C-k>", "<cmd>NavigatorUp<cr>", silent = true },
            { "<leader>wh", ":NavigatorLeft<CR>", desc = "window-left", silent = true },
            { "<leader>wj", ":NavigatorDown<CR>", desc = "window-down", silent = true },
            { "<leader>wk", ":NavigatorUp<CR>", desc = "window-up", silent = true },
            { "<leader>wl", ":NavigatorRight<CR>", desc = "window-right", silent = true },
            { "<leader>wp", ":NavigatorPrevious<CR>", desc = "window-previous", silent = true },
        },
        opts = {
            auto_save = "all",
        },
    },

    { --[[ harpoon ]]
        "kimabrandt-flx/harpoon",
        -- "ThePrimeagen/harpoon",
        -- branch = "harpoon2",
        branch = "fix_initialization",
        keys = {
            -- file
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "goto-file-1",
                silent = true,
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "goto-file-2",
                silent = true,
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "goto-file-3",
                silent = true,
            },
            {
                "<leader>4",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "goto-file-4",
                silent = true,
            },
            {
                "<leader>5",
                function()
                    require("harpoon"):list():select(5)
                end,
                desc = "goto-file-5",
                silent = true,
            },

            {
                "<leader>fa",
                function()
                    require("harpoon"):list():add()
                end,
                desc = "add-file",
                silent = true,
            },
            {
                "<leader>fm",
                function()
                    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
                end,
                desc = "toggle-harpoon",
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
        -- stylua: ignore
        keys = {
            { "<localleader>bb", function() require("browse").browse() end, desc = "browse", mode = { "n", "x" } },
            { "<localleader>bc", function() require("utils.cht").cht() end, desc = "cheatsheet" },
            { "<localleader>bd", function() require("browse").devdocs.search() end, desc = "devdocs-search" },
            { "<localleader>bf", function() require("browse").devdocs.search_with_filetype() end, desc = "devdocs-filetype-search" },
            { "<localleader>bi", function() require("browse").input_search() end, desc = "input-search", mode = { "n", "x" } },
            { "<localleader>bl", function() require("browse").open_bookmarks() end, desc = "bookmarks", mode = { "n", "x" } },
            { "<localleader>bm", function() require("browse").mdn.search() end, desc = "mdn-search", mode = { "n", "x" } },
            { "<localleader>bs", function() require("utils.cht").stack_overflow() end, desc = "stackoverflow" },
        },
        config = function()
            -- local bookmarks = {
            --     ["docs"] = {
            --         ["name"] = "docs for everything",
            --         ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
            --         ["devdocs.io"] = "https://devdocs.io/search?q=%s",
            --         ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
            --         ["mdn"] = "https://developer.mozilla.org/search?q=%s",
            --         ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
            --         ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
            --     },
            --     ["work"] = {
            --         ["name"] = "work related",
            --         ["github_pulls"] = "https://github.com/pulls",
            --         ["mui"] = "https://mui.com/",
            --         ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
            --         ["v4-mui"] = "https://v4.mui.com/",
            --         ["npm_search"] = "https://npmjs.com/search?q=%s",
            --     },
            --     ["lalitmee"] = {
            --         ["name"] = "personal repositories",
            --         ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
            --         ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
            --         ["dNotes"] = "https://github.com/lalitmee/dNotes",
            --         ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
            --     },
            --     ["neovim"] = {
            --         ["name"] = "most visited repositories for neovim",
            --         ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
            --         ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
            --         ["neovim"] = "https://github.com/neovim/neovim",
            --         ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
            --         ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
            --         ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua",
            --     },
            --     ["configs"] = {
            --         ["name"] = "dotfiles repositories of my favourites",
            --         ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
            --         ["akinsho"] = "https://github.com/akinsho/dotfiles",
            --         ["tjdevries"] = "https://github.com/tjdevries/config_manager",
            --         ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
            --     },
            --     ["github"] = {
            --         ["name"] = "search github from neovim",
            --         ["code_search"] = "https://github.com/search?q=%s&type=code",
            --         ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            --         ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            --         ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
            --     },
            --     ["reddit"] = {
            --         ["name"] = "reddit search",
            --         ["query"] = "https://www.reddit.com/search?q=%s",
            --         ["sr_query"] = "https://www.reddit.com/search?q=%s&type=sr",
            --         ["neovim"] = "https://www.reddit.com/r/neovim",
            --         ["workspaces"] = "https://www.reddit.com/r/workspaces",
            --         ["vim_porn"] = "https://www.reddit.com/r/vimporn",
            --     },
            -- }

            local bookmarks = {
                ["i3wm-docs"] = "https://i3wm.org/docs/",
                ["i3wm-discussions"] = "https://github.com/i3/i3/discussions",
                ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
                ["akinsho"] = "https://github.com/akinsho/dotfiles",
                ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
                ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
                ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
                ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
                ["code_search"] = "https://github.com/search?q=%s&type=code",
                ["dNotes"] = "https://github.com/lalitmee/dNotes",
                ["devdocs.io"] = "https://devdocs.io/search?q=%s",
                ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
                ["fzf-lua"] = "https://github.com/ibhagwan/fzf-lua",
                ["github_pulls"] = "https://github.com/pulls",
                ["issues_search"] = "https://github.com/search?q=%s&type=issues",
                ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
                ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
                ["mdn"] = "https://developer.mozilla.org/search?q=%s",
                ["mui"] = "https://mui.com/",
                ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
                ["neovim_github"] = "https://github.com/neovim/neovim",
                ["neovim_reddit"] = "https://www.reddit.com/r/neovim",
                ["npm_search"] = "https://npmjs.com/search?q=%s",
                ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
                ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
                ["reddit_community_query"] = "https://www.reddit.com/search?q=%s&type=sr",
                ["reddit_query"] = "https://www.reddit.com/search?q=%s",
                ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
                ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
                ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
                ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
                ["tjdevries"] = "https://github.com/tjdevries/config_manager",
                ["v4-mui"] = "https://v4.mui.com/",
                ["vim_porn"] = "https://www.reddit.com/r/vimporn",
                ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
                ["workspaces"] = "https://www.reddit.com/r/workspaces",
                ["bootstrap"] = "https://getbootstrap.com",
                ["pkg.go.dev"] = "https://pkg.go.dev/search?q=%s",
            }
            require("browse").setup({
                provider = "duckduckgo", -- google or bing
                bookmarks = bookmarks,
                persist_grouped_bookmarks_query = true,
            })
        end,
    },

    { --[[ hardtime ]]
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        -- enabled = false,
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
        -- stylua: ignore
        keys = {
            { "<leader>xa", ":CodeSnapASCII<CR>", mode = { "n", "v" }, desc = "codesnap-ascii", silent = true },
            { "<leader>xh", ":CodeSnapHighlight<CR>", mode = { "n", "v" }, desc = "codesnap-highlight", silent = true },
            { "<leader>xH", ":CodeSnapSaveHighlight<CR>", mode = { "n", "v" }, desc = "codesnap-save-highlight", silent = true },
            { "<leader>xs", ":CodeSnap<CR>", mode = { "n", "v" }, desc = "codesnap", silent = true },
            { "<leader>xS", ":CodeSnapSave<CR>", mode = { "n", "v" }, desc = "codesnap-save", silent = true },
        },
        opts = {
            save_path = vim.env.HOME .. "/Desktop/Github/code-screenshots",
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
                "<leader>qs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>ql",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
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

    { --[[ vim-apm ]]
        enabled = false,
        "ThePrimeagen/vim-apm",
        keys = {
            {
                "<leader>ax",
                function()
                    require("vim-apm"):toggle_monitor()
                end,
                desc = "toggle vim apm",
            },
        },
        config = function()
            require("vim-apm"):setup({})
        end,
    },

    { --[[ marks.nvim ]]
        enabled = false,
        "chentoast/marks.nvim",
        event = "VeryLazy",
        -- stylua: ignore
        keys = {
            { "<leader>ml", ":MarksQFListAll<cr>", desc = "list-all-marks-qf", silent = true },
            { "<leader>mq", ":MarksQFListBuf<cr>", desc = "list-buf-marks-qf", silent = true },
            { "<leader>mL", ":MarksQFListGlobal<cr>", desc = "list-global-marks-qf", silent = true },
            { "<leader>ma", ":MarksListAll<cr>", desc = "list-all-marks", silent = true },
            { "<leader>mb", ":MarksListBuf<cr>", desc = "list-buf-marks", silent = true },
            { "<leader>mg", ":MarksListGlobal<cr>", desc = "list-global-marks", silent = true },
            { "<leader>mt", ":MarksToggleSigns<cr>", desc = "toggle-signs", silent = true },
        },
        opts = {
            excluded_filetypes = { "NeogitStatus", "NeogitCommitMessage", "toggleterm" },
        },
    },

    { --[[ flatten.nvim ]]
        "willothy/flatten.nvim",
        lazy = false,
        priority = 1001,
        opts = {},
    },

    { --[[ http-codes ]]
        "barrett-ruth/http-codes.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>sh", ":HTTPCodes<CR>", desc = "http-codes", silent = true },
        },
        opts = {
            use = "telescope",
        },
    },

    { --[[ demicolon.nvim ]]
        enabled = false,
        "mawkler/demicolon.nvim",
        dependencies = {
            "jinh0/eyeliner.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        keys = { ";", ",", "t", "f", "T", "F", "]", "[", "]d", "[d" },
        config = function()
            require("demicolon").setup({
                keymaps = {
                    horizontal_motions = false,
                },
            })

            local function eyeliner_jump(key)
                local forward = vim.list_contains({ "t", "f" }, key)
                return function()
                    require("eyeliner").highlight({ forward = forward })
                    return require("demicolon.jump").horizontal_jump(key)()
                end
            end

            local nxo = { "n", "x", "o" }
            local opts = { expr = true }

            vim.keymap.set(nxo, "f", eyeliner_jump("f"), opts)
            vim.keymap.set(nxo, "F", eyeliner_jump("F"), opts)
            vim.keymap.set(nxo, "t", eyeliner_jump("t"), opts)
            vim.keymap.set(nxo, "T", eyeliner_jump("T"), opts)
        end,
    },

    { --[[ eyeliner.nvim ]]
        enabled = false,
        "jinh0/eyeliner.nvim",
        keys = { "t", "f", "T", "F" },
        opts = {
            highlight_on_key = true,
            dim = true,
            default_keymaps = false,
        },
    },

    { --[[ orphans.nvim ]]
        "ZWindL/orphans.nvim",
        cmd = "Orphans",
        opts = {},
    },

    { --[[ todo-comments.nvim ]]
        "folke/todo-comments.nvim",
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
            { "<leader>qP", "<cmd>TodoTelescope keywords=PERF<cr>", desc = "PERF Telescope" },
            { "<leader>qh", "<cmd>TodoTelescope keywords=HACK<cr>", desc = "HACK Telescope" },
            { "<leader>qq", "<cmd>TodoQuickFix<cr>", desc = "Todo Quickfix" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
}
