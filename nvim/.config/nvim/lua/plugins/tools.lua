local fn = vim.fn

return {
    { --[[ undotree ]]
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
    },

    { --[[ genghis ]]
        "chrisgrieser/nvim-genghis",
        cmd = {
            "Chmodx",
            "CopyFilename",
            "CopyFilepath",
            "Duplicate",
            "Move",
            "New",
            "NewFromSelection",
            "Rename",
            "Trash",
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = {
                    ["a"] = { ":New<cr>", "create-file" },
                    ["d"] = { ":Trash<cr>", "trash-file" },
                    ["f"] = { ":CopyFilepath<cr>", "copy-file-path" },
                    ["m"] = { ":Move<cr>", "move-and-rename-file" },
                    ["n"] = { ":CopyFilename<cr>", "copy-file-name" },
                    ["r"] = { ":Rename<cr>", "rename-file" },
                    ["s"] = { ":Duplicate<cr>", "duplicate-file" },
                    ["x"] = { ":Chmodx<cr>", "make-executable" },
                },
            }, { mode = "n", prefix = "<localleader>" })

            wk.register({
                ["a"] = {
                    ["s"] = { ":NewFromSelection<cr>", "move-selection-to-file" },
                },
            }, { mode = "x", prefix = "<localleader>" })
        end,
    },

    { --[[ autolist ]]
        "gaoDean/autolist.nvim",
        ft = {
            "gitcommit",
            "markdown",
            "plaintex",
            "tex",
            "text",
        },
        config = true,
        init = function()
            local autolist = require("autolist")
            autolist.create_mapping_hook("i", "<CR>", autolist.new)
            autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
            autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
            autolist.create_mapping_hook("n", "dd", autolist.force_recalculate)
            autolist.create_mapping_hook("n", "o", autolist.new)
            autolist.create_mapping_hook("n", "O", autolist.new_before)
            autolist.create_mapping_hook("n", ">>", autolist.indent)
            autolist.create_mapping_hook("n", "<<", autolist.indent)
            autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
            autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
        end,
    },

    { --[[ tabular ]]
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },

    { --[[ surround ]]
        "kylechui/nvim-surround",
        keys = {
            "ds",
            "ys",
            "cs",
        },
        opts = {},
    },

    { --[[ iswap ]]
        "mizlan/iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
    },

    { --[[ nap ]]
        "liangxianzhe/nap.nvim",
        keys = { "]", "[" },
        config = function()
            require("nap").setup({
                next_prefix = "]",
                prev_prefix = "[",
                next_repeat = "]",
                prev_repeat = "[",
            })

            -- gitsigns mapping
            require("nap").operator("h", require("nap").gitsigns())
            require("nap").operator("f", false)
        end,
    },

    { --[[ possession ]]
        "jedrzejboczar/possession.nvim",
        event = { "VimEnter" },
        init = function()
            require("telescope").load_extension("possession")
            local wk = require("which-key")
            wk.register({
                ["x"] = {
                    ["name"] = "+possession",
                    ["c"] = { ":PossessionClose<CR>", "close" },
                    ["d"] = { ":PossessionDelete<Space>", "delete" },
                    ["l"] = { ":PossessionLoad<Space>", "load" },
                    ["m"] = { ":PossessionMigrate<Space>", "migrate" },
                    ["o"] = { ":Telescope possession list<CR>", "search" },
                    ["p"] = { ":PossessionShow<Space>", "show" },
                    ["r"] = { ":PossessionRename<Space>", "rename" },
                    ["s"] = { ":PossessionSave<Space>", "save" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
        opts = {
            silent = true,
            autosave = {
                current = true, -- or fun(name): boolean
                on_load = true,
                on_quit = true,
            },
        },
        -- enabled = false,
    },

    { --[[ auto-session ]]
        "rmagatti/auto-session",
        event = { "VimEnter" },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = {
                    ["d"] = {
                        ":Autosession delete<CR>",
                        "delete-session-telescope",
                    },
                    ["D"] = { ":SessionDelete<CR>", "delete-current-session" },
                    ["l"] = { ":Autosession search<CR>", "search-sessions" },
                    ["s"] = { ":SessionSave<CR>", "save-session" },
                    ["S"] = { ":SessionRestore<CR>", "restore-session" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
        config = function()
            local function save_tabby_tab_names()
                local cmds = {}
                for _, t in pairs(vim.api.nvim_list_tabpages()) do
                    local tabname = require("tabby.feature.tab_name").get_raw(t)
                    if tabname ~= "" then
                        table.insert(
                            cmds,
                            'pcall(require("tabby.feature.tab_name").set, '
                                .. t
                                .. ', "'
                                .. tabname:gsub('"', '\\"')
                                .. '")'
                        )
                    end
                end

                if #cmds == 0 then
                    return ""
                end

                return "lua " .. table.concat(cmds, ";")
            end
            require("auto-session").setup({
                auto_save_enabled = true,
                auto_restore_enabled = true,
                auto_session_use_git_branch = true,
                save_extra_cmds = {
                    -- tabby: tabs name
                    save_tabby_tab_names,
                },
            })
        end,
        enabled = false,
    },

    { --[[ toggleterm ]]
        "akinsho/toggleterm.nvim",
        event = "VeryLazy",
        opts = {
            open_mapping = [[<C-\>]],
            shade_filetypes = {},
            direction = "float",
            autochdir = true,
            persist_mode = true,
            insert_mappings = false,
            start_in_insert = true,
            winbar = { enabled = lk.ui.winbar.enable },
            float_opts = {
                border = lk.style.border.rounded,
                winblend = 3,
                width = 220,
                height = 45,
            },
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
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

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
            })

            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                hidden = true,
                direction = "float",
                on_open = float_handler,
            })

            local bottom = Terminal:new({
                cmd = "btm",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                size = function()
                    return math.floor(vim.o.columns * 0.95)
                end,
            })

            lk.command("LazyDocker", function()
                lazydocker:toggle()
            end, {})
            lk.command("LazyGit", function()
                lazygit:toggle()
            end, {})
            lk.command("Bottom", function()
                bottom:toggle()
            end, {})
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
        ft = { "org" },
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                config = true,
            },
        },
        config = function()
            local orgmode = require("orgmode")
            orgmode.setup({
                org_agenda_files = { "~/org" },
                org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
            })
            orgmode.setup_ts_grammar()
        end,
    },

    { --[[ neorg ]]
        "nvim-neorg/neorg",
        cmd = { "Neorg" },
        ft = "norg",
        build = ":Neorg sync-parsers",
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.clipboard"] = {},
                ["core.clipboard.code-blocks"] = {},
                ["core.concealer"] = {},
                ["core.keybinds"] = {},
                ["core.integrations.telescope"] = {},
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/Desktop/Github/notes",
                            ["work-notes"] = "~/Documents/notes",
                        },
                    },
                },
            },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-neorg/neorg-telescope" },
        },
    },

    { --[[ mind ]]
        "phaazon/mind.nvim",
        cmd = {
            "MindOpenMain",
            "MindOpenProject",
            "MindOpenSmartProject",
        },
        config = function()
            require("mind").setup({
                ui = { width = 40 },
                keymaps = {
                    normal = {
                        T = function(args)
                            require("mind.ui").with_cursor(function(line)
                                local tree = args.get_tree()
                                local node = require("mind.node").get_node_by_line(tree, line)

                                if node.icon == nil or node.icon == " " then
                                    node.icon = " "
                                elseif node.icon == " " then
                                    node.icon = " "
                                end

                                args.save_tree()
                                require("mind.ui").rerender(tree, args.opts)
                            end)
                        end,
                    },
                },
            })
        end,

        init = function()
            -- create a new entry in Journal if it doesn't exist otherwise edit it
            lk.command("MindJournal", function()
                require("mind").wrap_main_tree_fn(function(args)
                    local tree = args.get_tree()
                    local path = vim.fn.strftime("/Journal/%Y/%b/%d")
                    local _, node = require("mind.node").get_node_by_path(tree, path, true)
                    if node == nil then
                        vim.notify("cannot open journal 🙁", vim.log.levels.WARN)
                        return
                    end
                    require("mind.commands").open_data(tree, node, args.data_dir, args.save_tree, args.opts)
                    args.save_tree()
                end)
            end, {})

            lk.command("MindOpenFromMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
                end)
            end, {})

            lk.command("MindOpenFromSmart", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
                end)
            end, {})

            lk.command("MindCopyFromMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
                end)
            end, {})

            lk.command("MindCopyFromMain", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
                end)
            end, {})

            lk.command("MindCreateInSmart", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").create_node_index(
                        args.get_tree(),
                        require("mind.node").MoveDir.INSIDE_END,
                        args.save_tree,
                        args.opts
                    )
                end)
            end, {})

            lk.command("MindCreateInMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").create_node_index(
                        args.get_tree(),
                        require("mind.node").MoveDir.INSIDE_END,
                        args.save_tree,
                        args.opts
                    )
                end)
            end, {})

            lk.command("MindInitializeProject", function()
                vim.notify("initializing project tree")
                require("mind").wrap_smart_project_tree_fn(function(args)
                    local tree = args.get_tree()
                    local mind_node = require("mind.node")

                    local _, tasks = mind_node.get_node_by_path(tree, "/Tasks", true)
                    tasks.icon = "陼"

                    local _, backlog = mind_node.get_node_by_path(tree, "/Tasks/Backlog", true)
                    backlog.icon = " "

                    local _, on_going = mind_node.get_node_by_path(tree, "/Tasks/On-going", true)
                    on_going.icon = " "

                    local _, done = mind_node.get_node_by_path(tree, "/Tasks/Done", true)
                    done.icon = " "

                    local _, cancelled = mind_node.get_node_by_path(tree, "/Tasks/Cancelled", true)
                    cancelled.icon = " "

                    local _, notes = mind_node.get_node_by_path(tree, "/Notes", true)
                    notes.icon = " "

                    args.save_tree()
                end)
            end, {})
        end,
    },

    { --[[ project ]]
        "ahmedkhalf/project.nvim",
        keys = { "<leader>pp" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        init = function()
            require("telescope").load_extension("projects")
        end,
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
        end,
        enabled = false,
    },

    { --[[ conduct ]]
        "aaditeynair/conduct.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = {
            "ConductNewProject",
            "ConductLoadProject",
            "ConductLoadLastProject",
            "ConductLoadProjectConfig",
            "ConductReloadProjectConfig",
            "ConductDeleteProject",
            "ConductRenameProject",
            "ConductProjectNewSession",
            "ConductProjectLoadSession",
            "ConductProjectDeleteSession",
            "ConductProjectRenameSession",
        },
        enabled = false,
    },

    { --[[ monorepo ]]
        "imNel/monorepo.nvim",
        keys = {
            "<leader>pm",
            "<leader>pn",
            "<leader>pp",
            "<leader>pt",
        },
        config = true,
        init = function()
            local monorepo = require("monorepo")
            local wk = require("which-key")

            wk.register({
            -- stylua: ignore
            ["p"] = {
                ["m"] = { ":Telescope monorepo<cr>", "monorepo" },
                ["a"] = { function() monorepo.add_project() end, "add-project" },
                ["n"] = { function() monorepo.next_project() end, "next-project" },
                ["P"] = { function() monorepo.previous_project() end, "previous-project" },
                ["r"] = { function() monorepo.remove_project() end, "remove-project" },
                ["t"] = { function() monorepo.toggle_project() end, "toggle-project" },
            },
            }, { mode = "n", prefix = "<leader>" })
        end,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
    },

    { --[[ scretch ]]
        "Sonicfury/scretch.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = {
            "Scretch",
            "ScretchNamed",
            "ScretchLast",
            "ScretchSearch",
            "ScretchGrep",
            "ScretchExplore",
        },
        config = function()
            local scretch = require("scretch")
            scretch.setup({
                scretch_dir = vim.fn.stdpath("data") .. "/scretch/",
            })

            lk.command("Scretch", function()
                scretch.new()
            end, {})
            lk.command("ScretchNamed", function()
                scretch.new_named()
            end, {})
            lk.command("ScretchLast", function()
                scretch.last()
            end, {})
            lk.command("ScretchSearch", function()
                scretch.search()
            end, {})
            lk.command("ScretchGrep", function()
                scretch.grep()
            end, {})
            lk.command("ScretchExplore", function()
                scretch.explore()
            end, {})
        end,
    },

    { --[[ firenvim ]]
        "glacambre/firenvim",
        lazy = false,
        cond = not not vim.g.started_by_firenvim,
        build = function()
            require("lazy").load({ plugins = "firenvim", wait = true })
            vim.fn["firenvim#install"](0)
        end,
        config = function()
            vim.api.nvim_create_autocmd({ "UIEnter" }, {
                callback = function()
                    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
                    if client ~= nil and client.name == "Firenvim" then
                        vim.o.laststatus = 0
                        vim.o.showtabline = 0
                        vim.o.number = false
                    end
                end,
            })
        end,
        enabled = false,
    },

    { --[[ fzf-lua ]]
        "ibhagwan/fzf-lua",
        lazy = false,
        opts = {
            winopts = {
                width = 0.95,
                height = 0.95,
                preview = {
                    title_align = "center",
                    scrollbar = "border",
                },
            },
            fzf_opts = {},
            grep = {
                rg_glob = true,
                rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
            },
            file_ignore_patterns = { "node_modules", ".git" },
        },
    },

    { --[[ navigator ]]
        "numToStr/Navigator.nvim",
        event = { "VeryLazy" },
        opts = {
            auto_save = "all",
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["w"] = {
                    ["h"] = { ":NavigatorLeft<CR>", "window-left" },
                    ["j"] = { ":NavigatorDown<CR>", "window-down" },
                    ["k"] = { ":NavigatorUp<CR>", "window-up" },
                    ["l"] = { ":NavigatorRight<CR>", "window-right" },
                    ["p"] = { ":NavigatorPrevious<CR>", "window-previous" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },

    { --[[ harpoon ]]
        "ThePrimeagen/harpoon",
        cmd = {
            "HarpoonAddFile",
            "HarpoonGotoFile",
            "HarpoonGotoTerm",
            "HarpoonGotoTmux",
            "HarpoonNextMark",
            "HarpoonPrevMark",
            "HarpoonRemoveFile",
            "HarpoonSendCmdToTerm",
            "HarpoonSendCmdToTmux",
            "ToggleHarpoonCmdMenu",
            "ToggleHarpoonMenu",
        },
        config = function()
            local command = lk.command

            require("harpoon").setup({
                global_settings = {
                    menu = {
                        width = vim.api.nvim_win_get_width(0) - 100,
                        height = vim.api.nvim_win_get_height(0) - 25,
                    },
                    enter_on_sendcmd = true,
                    mark_branch = true,
                    save_on_toggle = true,
                    tmux_autoclose_windows = true,
                },
            })

            ----------------------------------------------------------------------
            -- NOTE: load telescope extension {{{
            ----------------------------------------------------------------------
            require("telescope").load_extension("harpoon")
            -- }}}
            ----------------------------------------------------------------------

            ----------------------------------------------------------------------
            -- NOTE: harpoon commands {{{
            ----------------------------------------------------------------------
            --------------------------------------------------------------------------------
            --  NOTE: file navigations {{{
            --------------------------------------------------------------------------------
            command("HarpoonAddFile", function()
                require("harpoon.mark").add_file()
            end, {})

            command("HarpoonGotoFile", function(args)
                local number = tonumber(args["args"])
                require("harpoon.ui").nav_file(number)
            end, {
                nargs = 1,
            })

            command("HarpoonRemoveFile", function()
                require("harpoon.mark").rm_file()
            end, {})
            -- }}}
            --------------------------------------------------------------------------------

            --------------------------------------------------------------------------------
            --  NOTE: terminal {{{
            --------------------------------------------------------------------------------
            command("HarpoonGotoTerm", function(args)
                local number = tonumber(args["args"])
                require("harpoon.term").gotoTerminal(number)
            end, {
                nargs = 1,
            })

            command("HarpoonSendCmdToTerm", function(args)
                local argsString = args["args"]
                local numberAndCmd = vim.split(argsString, " ")
                local number = tonumber(numberAndCmd[1])
                local cmd = numberAndCmd[2]
                require("harpoon.term").sendCommand(number, cmd)
            end, {
                nargs = 1,
            })
            -- }}}
            --------------------------------------------------------------------------------

            --------------------------------------------------------------------------------
            --  NOTE: tmux {{{
            --------------------------------------------------------------------------------
            command("HarpoonGotoTmux", function(args)
                local number = tonumber(args["args"])
                require("harpoon.tmux").gotoTerminal(number)
            end, {
                nargs = 1,
            })

            command("HarpoonSendCmdToTmux", function(args)
                local argsString = args["args"]
                local numberAndCmd = vim.split(argsString, " ")
                local number = tonumber(numberAndCmd[1])
                local cmd = numberAndCmd[2]
                require("harpoon.tmux").sendCommand(number, cmd)
            end, {
                nargs = 1,
            })
            -- }}}
            --------------------------------------------------------------------------------

            --------------------------------------------------------------------------------
            --  NOTE: marks navigation {{{
            --------------------------------------------------------------------------------
            command("HarpoonNextMark", function()
                require("harpoon.ui").nav_next()
            end, {})

            command("HarpoonPrevMark", function()
                require("harpoon.ui").nav_prev()
            end, {})
            -- }}}
            --------------------------------------------------------------------------------

            command("ToggleHarpoonMenu", function()
                require("harpoon.ui").toggle_quick_menu()
            end, {})

            command("ToggleHarpoonCmdMenu", function()
                require("harpoon.cmd-ui").toggle_quick_menu()
            end, {})

            -- }}}
            ----------------------------------------------------------------------
        end,
    },

    { --[[ browse ]]
        "lalitmee/browse.nvim",
        dev = true,
        lazy = false,
        config = function()
            local bookmarks = {
                ["docs"] = {
                    ["name"] = "docs for everything",
                    ["cargo"] = "https://doc.rust-lang.org/cargo/index.html?search=%s",
                    ["devdocs.io"] = "https://devdocs.io/search?q=%s",
                    ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
                    ["mdn"] = "https://developer.mozilla.org/search?q=%s",
                    ["rust:core"] = "https://doc.rust-lang.org/core/?search=%s",
                    ["rust:std"] = "https://doc.rust-lang.org/std/?search=%s",
                },
                ["work"] = {
                    ["name"] = "work related",
                    ["github_pulls"] = "https://github.com/pulls",
                    ["mui"] = "https://mui.com/",
                    ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
                    ["v4-mui"] = "https://v4.mui.com/",
                    ["npm_search"] = "https://npmjs.com/search?q=%s",
                },
                ["lalitmee"] = {
                    ["name"] = "personal repositories",
                    ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
                    ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
                    ["dNotes"] = "https://github.com/lalitmee/dNotes",
                    ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
                },
                ["neovim"] = {
                    ["name"] = "most visited repositories for neovim",
                    ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
                    ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
                    ["neovim"] = "https://github.com/neovim/neovim",
                    ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
                    ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
                },
                ["configs"] = {
                    ["name"] = "dotfiles repositories of my favourites",
                    ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
                    ["akinsho"] = "https://github.com/akinsho/dotfiles",
                    ["tjdevries"] = "https://github.com/tjdevries/config_manager",
                    ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
                },
                ["github"] = {
                    ["name"] = "search github from neovim",
                    ["code_search"] = "https://github.com/search?q=%s&type=code",
                    ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
                    ["issues_search"] = "https://github.com/search?q=%s&type=issues",
                    ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
                },
                ["reddit"] = {
                    ["name"] = "reddit search",
                    ["query"] = "https://www.reddit.com/search?q=%s",
                    ["sr_query"] = "https://www.reddit.com/search?q=%s&type=sr",
                    ["neovim"] = "https://www.reddit.com/r/neovim",
                    ["workspaces"] = "https://www.reddit.com/r/workspaces",
                    ["vim_porn"] = "https://www.reddit.com/r/vimporn",
                },
            }
            require("browse").setup({
                provider = "duckduckgo", -- google or bing
                bookmarks = bookmarks,
            })
        end,
        init = function()
            local wk = require("which-key")
            wk.register({
                ["s"] = {
                    ["b"] = {
                        function()
                            require("browse").browse()
                        end,
                        "browse",
                    },
                    ["c"] = {
                        function()
                            require("utils.cht").cht()
                        end,
                        "cheatsheet",
                    },
                    ["d"] = {
                        function()
                            require("browse").devdocs.search()
                        end,
                        "devdocs-search",
                    },
                    ["f"] = {
                        function()
                            require("browse").devdocs.search_with_filetype()
                        end,
                        "devdocs-filetype-search",
                    },
                    ["i"] = {
                        function()
                            require("browse").input_search()
                        end,
                        "input-search",
                    },
                    ["l"] = {
                        function()
                            require("browse").open_bookmarks()
                        end,
                        "bookmarks",
                    },
                    ["m"] = {
                        function()
                            require("browse").mdn.search()
                        end,
                        "mdn-search",
                    },
                    ["s"] = {
                        function()
                            require("utils.cht").stack_overflow()
                        end,
                        "stackoverflow",
                    },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },

    { --[[ mini.ai ]]
        "echasnovski/mini.ai",
        keys = {
            { "[f", desc = "Prev function" },
            { "]f", desc = "Next function" },
        },
        opts = function()
            -- add treesitter jumping
            ---@param capture string
            ---@param start boolean
            ---@param down boolean
            local function jump(capture, start, down)
                local rhs = function()
                    local parser = vim.treesitter.get_parser()
                    if not parser then
                        return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
                    end

                    local query = vim.treesitter.query.get(vim.bo.filetype, "textobjects")
                    if not query then
                        return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
                    end

                    local cursor = vim.api.nvim_win_get_cursor(0)

                    ---@type {[1]:number, [2]:number}[]
                    local locs = {}
                    for _, tree in ipairs(parser:trees()) do
                        for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
                            if query.captures[capture_id] == capture then
                                local range = { node:range() } ---@type number[]
                                local row = (start and range[1] or range[3]) + 1
                                local col = (start and range[2] or range[4]) + 1
                                if down and row > cursor[1] or (not down) and row < cursor[1] then
                                    table.insert(locs, { row, col })
                                end
                            end
                        end
                    end
                    return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
                end

                local c = capture:sub(1, 1):lower()
                local lhs = (down and "]" or "[") .. (start and c or c:upper())
                local desc = (down and "Next " or "Prev ")
                    .. (start and "start" or "end")
                    .. " of "
                    .. capture:gsub("%..*", "")
                vim.keymap.set("n", lhs, rhs, { desc = desc })
            end

            for _, capture in ipairs({ "function.outer", "class.outer" }) do
                for _, start in ipairs({ true, false }) do
                    for _, down in ipairs({ true, false }) do
                        jump(capture, start, down)
                    end
                end
            end
        end,
    },

    { --[[ mini.basics ]]
        "echasnovski/mini.basics",
        version = "*",
        event = "VeryLazy",
        opts = {
            options = {
                win_borders = "rounded",
            },
        },
    },
}
