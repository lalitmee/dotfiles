local command = lk.command
local fn = vim.fn

return {
    { --[[ undotree ]]
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
        keys = {
            { "<leader>au", ":UndotreeToggle<CR>", desc = "undo-tree", silent = true },
        },
    },

    { --[[ genghis ]]
        "chrisgrieser/nvim-genghis",
        keys = {
            { "<leader>fA", ":New<cr>", desc = "create-file", silent = true },
            { "<leader>fD", ":Trash<cr>", desc = "trash-file", silent = true },
            { "<leader>fy", ":CopyFilepath<cr>", desc = "copy-file-path", silent = true },
            { "<leader>fJ", ":Move<cr>", desc = "move-and-rename-file", silent = true },
            { "<leader>fN", ":CopyFilename<cr>", desc = "copy-file-name", silent = true },
            { "<leader>fR", ":Rename<cr>", desc = "rename-file", silent = true },
            { "<leader>fS", ":Duplicate<cr>", desc = "duplicate-file", silent = true },
            { "<leader>fX", ":Chmodx<cr>", desc = "make-executable", silent = true },
            { "<leader>fS", ":NewFromSelection<cr>", desc = "move-selection-to-file", silent = true, mode = "x" },
        },
    },

    { --[[ autolist ]]
        "gaoDean/autolist.nvim",
        ft = {
            "gitcommit",
            "markdown",
            "text",
        },
        init = function()
            local enabled_filetypes = {
                "gitcommit",
                "markdown",
                "text",
            }
            if vim.tbl_contains(enabled_filetypes, vim.bo.filetype) then
                vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
                vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
                vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>")
                vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
                vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
                vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
                vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
                vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

                -- Cycle list types with dot-repeat
                vim.keymap.set("n", "<localleader>ln", require("autolist").cycle_next_dr, { expr = true })
                vim.keymap.set("n", "<localleader>lp", require("autolist").cycle_prev_dr, { expr = true })

                -- Recalculate on edit
                vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
                vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
                vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
                vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
            end
        end,
        config = true,
        -- enabled = false,
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
        enabled = false,
    },

    { --[[ possession ]]
        "jedrzejboczar/possession.nvim",
        event = { "VimEnter" },
        keys = {
            { "<leader>xc", ":PossessionClose<CR>", desc = "close", silent = true },
            { "<leader>xd", ":PossessionDelete<Space>", desc = "delete", silent = true },
            { "<leader>xl", ":PossessionLoad<Space>", desc = "load", silent = true },
            { "<leader>xm", ":PossessionMigrate<Space>", desc = "migrate", silent = true },
            { "<leader>xo", ":Telescope possession list<CR>", desc = "search", silent = true },
            { "<leader>xp", ":PossessionShow<Space>", desc = "show", silent = true },
            { "<leader>xr", ":PossessionRename<Space>", desc = "rename", silent = true },
            { "<leader>xs", ":PossessionSave<Space>", desc = "save", silent = true },
        },
        opts = {
            silent = true,
            autosave = {
                current = true,
                on_load = true,
                on_quit = true,
            },
        },
        enabled = false,
    },

    { --[[ auto-session ]]
        "rmagatti/auto-session",
        event = { "VimEnter" },
        keys = {
            { "<leader>ad", ":Autosession delete<CR>", desc = "delete-session-telescope", silent = true },
            { "<leader>aD", ":SessionDelete<CR>", desc = "delete-current-session", silent = true },
            { "<leader>al", ":Autosession search<CR>", desc = "search-sessions", silent = true },
            { "<leader>as", ":SessionSave<CR>", desc = "save-session", silent = true },
            { "<leader>aS", ":SessionRestore<CR>", desc = "restore-session", silent = true },
        },
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
        keys = {
            [[<C-\>]],
            { "<leader>ab", ":Bottom<CR>", desc = "bottom", silent = true },
            { "<leader>ad", ":LazyDocker<CR>", desc = "lazydocker", silent = true },
            { "<leader>ag", ":LazyGit<CR>", desc = "lazygit", silent = true },
            { "<leader>ah", ":ToggleTerm direction=horizontal<CR>", desc = "horizontal-terminal", silent = true },
            { "<leader>ai", ":ChatGPTSh<CR>", desc = "chatgpt", silent = true },
            { "<leader>af", ":GhDash<CR>", desc = "gh-dash", silent = true },
            { "<leader>av", ":ToggleTerm direction=vertical<CR>", desc = "vertical-terminal", silent = true },
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
            float_opts = {
                border = lk.style.border.rounded,
                winblend = 3,
                width = 240,
                height = 50,
            },
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

            local float_opts = { width = 240, height = 52 }

            local chatgpt = Terminal:new({
                cmd = "chatgpt -i",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local gh_dash = Terminal:new({
                cmd = "gh dash",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

            local bottom = Terminal:new({
                cmd = "btm",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_opts,
            })

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
        enabled = false,
        "nvim-orgmode/orgmode",
        ft = { "org" },
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                config = true,
            },
        },
        init = function()
            require("orgmode").setup_ts_grammar()
        end,
        opts = {
            org_agenda_files = { "~/org" },
            org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
        },
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
            command("MindJournal", function()
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
            end)

            command("MindOpenFromMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
                end)
            end)

            command("MindOpenFromSmart", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
                end)
            end)

            command("MindCopyFromMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
                end)
            end)

            command("MindCopyFromMain", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
                end)
            end)

            command("MindCreateInSmart", function()
                require("mind").wrap_smart_project_tree_fn(function(args)
                    require("mind.commands").create_node_index(
                        args.get_tree(),
                        require("mind.node").MoveDir.INSIDE_END,
                        args.save_tree,
                        args.opts
                    )
                end)
            end)

            command("MindCreateInMain", function()
                require("mind").wrap_main_tree_fn(function(args)
                    require("mind.commands").create_node_index(
                        args.get_tree(),
                        require("mind.node").MoveDir.INSIDE_END,
                        args.save_tree,
                        args.opts
                    )
                end)
            end)

            command("MindInitializeProject", function()
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
            end)
        end,
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
        -- stylua: ignore
        keys = {
            { "<leader>pm", ":Telescope monorepo<cr>", desc = "monorepo", silent = true },
            { "<leader>pa", function() require("monorepo").add_project() end, desc = "add", silent = true },
            { "<leader>pn", function() require("monorepo").next_project() end, desc = "next", silent = true },
            { "<leader>pP", function() require("monorepo").previous_project() end, desc = "previous", silent = true },
            { "<leader>pr", function() require("monorepo").remove_project() end, desc = "remove", silent = true },
            { "<leader>pt", function() require("monorepo").toggle_project() end, desc = "toggle", silent = true },
        },
        config = function()
            require("monorepo").setup()
            require("telescope").load_extension("monorepo")
        end,
        enabled = false,
    },

    { --[[ scretch ]]
        "Sonicfury/scretch.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        -- stylua: ignore
        keys = {
            { "<localleader>sa", function() require("scretch").new() end, desc = "new-scratch" },
            { "<localleader>se", function() require("scretch").explore() end, desc = "scratch-explore" },
            { "<localleader>sf", function() require("scretch").search() end, desc = "search-scratch" },
            { "<localleader>sg", function() require("scretch").grep() end, desc = "scratch-grep" },
            { "<localleader>sl", function() require("scretch").last() end, desc = "last-scratch" },
            { "<localleader>sn", function() require("scretch").new_named() end, desc = "scratch-with-name" },
        },
        opts = {
            scretch_dir = vim.fn.stdpath("data") .. "/scretch/",
        },
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
        cmd = { "FzfLua" },
        keys = {
            "<C-]>",
            "gd",
            {
                "<leader>o/",
                ":FzfLua live_grep<CR>",
                desc = "fzf-live-grep",
                silent = true,
            },
            {
                "<leader>obL",
                ":FzfLua lines<CR>",
                desc = "fzf-lines",
                silent = true,
            },
            {
                "<leader>obb",
                ":FzfLua buffers<CR>",
                desc = "fzf-buffers",
                silent = true,
            },
            {
                "<leader>obl",
                ":FzfLua blines<CR>",
                desc = "fzf-buffer-lines",
                silent = true,
            },
            {
                "<leader>off",
                ":FzfLua files<CR>",
                desc = "fzf-files",
                silent = true,
            },
            {
                "<leader>ole",
                ":FzfLua lsp_document_diagnostics<CR>",
                desc = "fzf-lsp-document-diagnostics",
                silent = true,
            },
            {
                "<leader>olE",
                ":FzfLua lsp_workspace_diagnostics<CR>",
                desc = "fzf-lsp-workspace-diagnostics",
                silent = true,
            },
            {
                "<leader>oll",
                ":FzfLua lsp_finder<CR>",
                desc = "fzf-lsp-finder",
                silent = true,
            },
            {
                "<leader>olr",
                ":FzfLua lsp_references<CR>",
                desc = "fzf-lsp-references",
                silent = true,
            },
            {
                "<leader>olw",
                ":FzfLua lsp_document_symbols<CR>",
                desc = "fzf-lsp-document-symbols",
                silent = true,
            },
            {
                "<leader>olW",
                ":FzfLua lsp_workspace_symbols<CR>",
                desc = "fzf-lsp-workspace-symbols",
                silent = true,
            },
            {
                "<leader>ols",
                ":FzfLua lsp_live_workspace_symbols<CR>",
                desc = "fzf-lsp-live-workspace-symbols",
                silent = true,
            },
            {
                "<leader>osR",
                ":FzfLua live_grep_resume<CR>",
                desc = "fzf-live-grep-resume",
                silent = true,
            },
            {
                "<leader>osr",
                ":FzfLua resume<CR>",
                desc = "fzf-resume",
                silent = true,
            },
            {
                "<leader>osr",
                ":FzfLua resume<CR>",
                desc = "fzf-resume",
                silent = true,
            },
        },
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
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
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
                "<leader>6",
                function()
                    require("harpoon"):list():select(6)
                end,
                desc = "goto-file-6",
                silent = true,
            },
            {
                "<leader>7",
                function()
                    require("harpoon"):list():select(7)
                end,
                desc = "goto-file-7",
                silent = true,
            },
            {
                "<leader>8",
                function()
                    require("harpoon"):list():select(8)
                end,
                desc = "goto-file-8",
                silent = true,
            },
            {
                "<leader>9",
                function()
                    require("harpoon"):list():select(9)
                end,
                desc = "goto-file-9",
                silent = true,
            },

            {
                "<leader>fa",
                function()
                    require("harpoon"):list():append()
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

            harpoon:setup()
        end,
        -- opts = {
        --     global_settings = {
        --         menu = {
        --             width = vim.api.nvim_win_get_width(0) - 100,
        --             height = vim.api.nvim_win_get_height(0) - 25,
        --         },
        --         enter_on_sendcmd = true,
        --         mark_branch = true,
        --         save_on_toggle = true,
        --         tmux_autoclose_windows = true,
        --     },
        -- },
    },

    { --[[ browse ]]
        "lalitmee/browse.nvim",
        dev = true,
        keys = {
            {
                "<leader>sb",
                function()
                    require("browse").browse()
                end,
                desc = "browse",
                mode = { "n", "x" },
            },
            {
                "<leader>sc",
                function()
                    require("utils.cht").cht()
                end,
                desc = "cheatsheet",
            },
            {
                "<leader>sd",
                function()
                    require("browse").devdocs.search()
                end,
                desc = "devdocs-search",
            },
            {
                "<leader>sf",
                function()
                    require("browse").devdocs.search_with_filetype()
                end,
                desc = "devdocs-filetype-search",
            },
            {
                "<leader>si",
                function()
                    require("browse").input_search()
                end,
                desc = "input-search",
                mode = { "n", "x" },
            },
            {
                "<leader>sl",
                function()
                    require("browse").open_bookmarks()
                end,
                desc = "bookmarks",
                mode = { "n", "x" },
            },
            {
                "<leader>sm",
                function()
                    require("browse").mdn.search()
                end,
                desc = "mdn-search",
                mode = { "n", "x" },
            },
            {
                "<leader>ss",
                function()
                    require("utils.cht").stack_overflow()
                end,
                desc = "stackoverflow",
            },
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
            }
            require("browse").setup({
                provider = "duckduckgo", -- google or bing
                bookmarks = bookmarks,
            })
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

    { --[[ hardtime ]]
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        enabled = false,
    },
}
