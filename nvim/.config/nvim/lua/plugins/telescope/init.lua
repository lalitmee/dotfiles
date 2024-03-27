return {
    { --[[ telescope.nvim ]]
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        keys = {

            -- project
            { "<leader>pf", ":Telescope find_files<cr>", desc = "find-files", silent = true },
            { "<leader>pg", ":Telescope git_files<CR>", desc = "find-git-files", silent = true },
            { "<leader>ps", ":Telescope live_grep<CR>", desc = "project-search", silent = true },
            { "<leader>pw", ":Telescope grep_string<CR>", desc = "string-search", silent = true, mode = { "n", "v" } },
        },
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        config = function()
            local telescope = require("telescope")

            local should_reload = true
            local reloader = function()
                if should_reload then
                    RELOAD("plenary")
                    RELOAD("telescope")
                end
            end
            reloader()

            local actions = require("telescope.actions")
            local action_utils = require("telescope.actions.utils")
            local action_layout = require("telescope.actions.layout")
            local previewers = require("telescope.previewers")
            local themes = require("telescope.themes")

            local lga_actions = require("telescope-live-grep-args.actions")
            local trouble = require("trouble.providers.telescope")

            local function get_border(opts)
                return vim.tbl_deep_extend("force", opts or {}, {
                    borderchars = {
                        { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                        preview = {
                            "─",
                            "│",
                            "─",
                            "│",
                            "╭",
                            "╮",
                            "╯",
                            "╰",
                        },
                    },
                })
            end

            ---@param opts table
            ---@return table
            local function dropdown(opts)
                return themes.get_dropdown(get_border(opts))
            end

            --------------------------------------------------------------------------------
            --  NOTE: action to open entried in the results
            --------------------------------------------------------------------------------
            local open_entries = function(prompt_bufnr)
                local bufs = vim.tbl_map(function(b)
                    return vim.api.nvim_buf_get_name(b)
                end, vim.api.nvim_list_bufs())
                local entries = {}
                action_utils.map_entries(prompt_bufnr, function(entry)
                    table.insert(entries, entry)
                end)
                -- we have to close telescope picker beforehand
                -- otherwise window config of previewer subsumed
                actions.close(prompt_bufnr)
                for _, e in ipairs(entries) do
                    if
                        vim.tbl_isempty(vim.tbl_filter(function(b)
                            return b == e[1]
                        end, bufs))
                    then
                        vim.cmd(string.format("e %s", e[1]))
                    end
                end
            end

            --------------------------------------------------------------------------------
            --  NOTE: maker for buffers list
            --------------------------------------------------------------------------------
            local Job = require("plenary.job")
            local new_maker = function(filepath, bufnr, opts)
                filepath = vim.fn.expand(filepath)
                Job:new({
                    command = "file",
                    args = { "--mime-type", "-b", filepath },
                    on_exit = function(j)
                        local mime_class = vim.split(j:result()[1], "/")[1]
                        local mime_type = j:result()[1]
                        if
                            mime_class == "text"
                            or (mime_class == "application" and mime_type ~= "application/x-pie-executable")
                        then
                            previewers.buffer_previewer_maker(filepath, bufnr, opts)
                        else
                            -- maybe we want to write something to the buffer here
                            vim.schedule(function()
                                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                            end)
                        end
                    end,
                }):sync()
            end
            -- }}}
            --------------------------------------------------------------------------------

            ----------------------------------------------------------------------
            -- NOTE: setup
            ----------------------------------------------------------------------
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--hidden",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--trim",
                    },
                    winblend = 0,
                    prompt_prefix = "   ", --   
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    scroll_strategy = "cycle",
                    color_devicons = true,
                    dynamic_preview_title = true,
                    buffer_previewer_maker = new_maker,
                    set_env = {
                        ["COLORTERM"] = "truecolor",
                    },
                    mappings = {
                        i = {
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,
                            ["<C-a>"] = actions.cycle_previewers_prev,
                            ["<C-b>"] = open_entries,
                            ["<C-e>"] = actions.move_to_bottom,
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-n>"] = actions.move_selection_next,
                            ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<C-s>"] = actions.cycle_previewers_next,
                            ["<C-y>"] = actions.move_to_top,
                            ["<M-o>"] = action_layout.toggle_prompt_position,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-v>"] = action_layout.toggle_mirror,
                            ["<c-t>"] = trouble.open_with_trouble,
                            ["<esc>"] = actions.close,
                        },
                        n = {
                            ["<Down>"] = actions.cycle_history_next,
                            ["<Up>"] = actions.cycle_history_prev,
                            ["<c-t>"] = trouble.open_with_trouble,
                            ["<esc>"] = actions.close,
                            ["e"] = actions.move_to_bottom,
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["o"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["p"] = action_layout.toggle_preview,
                            ["y"] = actions.move_to_top,
                        },
                    },
                    file_ignore_patterns = {
                        "%.otf",
                        "%.ttf",
                        "%.DS_Store",
                        "%.git",
                        "build",
                        "node_modules",
                    },

                    layout_strategy = "flex",
                    layout_config = {
                        width = 0.95,
                        height = 0.95,
                        prompt_position = "top",
                        horizontal = {
                            preview_width = function(_, cols, _)
                                if cols > 200 then
                                    return math.floor(cols * 0.6)
                                else
                                    return math.floor(cols * 0.5)
                                end
                            end,
                        },

                        vertical = {
                            width = 0.9,
                            height = 0.95,
                            preview_height = 0.5,
                        },

                        flex = {
                            horizontal = {
                                preview_width = 0.9,
                            },
                        },
                    },
                    file_previewer = previewers.vim_buffer_cat.new,
                    grep_previewer = previewers.vim_buffer_vimgrep.new,
                    qflist_previewer = previewers.vim_buffer_qflist.new,
                },
                pickers = {
                    buffers = {
                        path_display = { "absolute" },
                        previewer = true,
                        sort_mru = true,
                        sort_lastused = true,
                        show_all_buffers = true,
                        ignore_current_buffer = true,
                        mappings = {
                            i = { ["<c-d>"] = "delete_buffer" },
                            n = { ["d"] = "delete_buffer" },
                        },
                    },
                    live_grep = {
                        -- find_command = { "rg", "--vimgrep", "--strip-cwd-prefix" },
                        path_display = { "absolute", "truncate" },
                        file_ignore_patterns = { ".git/" },
                        mappings = {
                            i = {
                                ["<c-f>"] = require("telescope.actions").to_fuzzy_refine,
                            },
                        },
                    },
                    colorscheme = {
                        -- enable_preview = true,
                    },
                    find_files = {
                        path_display = { "absolute", "truncate" },
                        hidden = true,
                    },
                    git_bcommits = {
                        layout_config = {
                            horizontal = {
                                preview_width = 0.55,
                            },
                        },
                    },
                    git_commits = {
                        layout_config = {
                            horizontal = {
                                preview_width = 0.55,
                            },
                        },
                    },
                    reloader = dropdown({}),

                    --------------------------------------------------------------------------------
                    --  NOTE: lsp pickers {{{
                    --------------------------------------------------------------------------------
                    lsp_references = {
                        path_display = { "smart" },
                    },
                    -- }}}
                    --------------------------------------------------------------------------------
                },
                extensions = {
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                    frecency = {
                        workspaces = {
                            ["dots"] = "~/dotfiles",
                            ["work"] = "~/Desktop/work",
                            ["git"] = "~/Desktop/Github",
                        },
                    },
                    smart_open = {
                        show_scores = false,
                        ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
                        match_algorithm = "fzy",
                        disable_devicons = false,
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                    project = {
                        base_dirs = {
                            { "~/", max_depth = 7 },
                        },
                        hidden_files = true,
                        order_by = "recent",
                    },
                    lazy = {},
                    import = {
                        insert_at_top = false,
                    },
                    helpgrep = {
                        ignore_paths = {
                            vim.fn.stdpath("state") .. "/lazy/readme",
                        },
                    },
                },
            })

            -- loading extensions
            require("telescope").load_extension("messages")
            require("telescope").load_extension("dotfiles")

            require("plugins.telescope.autocmds")
            require("plugins.telescope.commands")
            require("plugins.telescope.mappings")
        end,
    },

    { --[[ telescope-frecency ]]
        "nvim-telescope/telescope-frecency.nvim",
        keys = {
            { "<leader>pr", ":Telescope frecency<CR>", desc = "frecency", silent = true },
        },
        config = function()
            require("telescope").load_extension("frecency")
        end,
    },

    { --[[ smart-open.nvim ]]
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        keys = {
            { "<leader>pl", ":Telescope smart_open<CR>", desc = "smart-open", silent = true },
        },
        config = function()
            require("telescope").load_extension("smart_open")
        end,
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
    },

    { --[[ telescope-lazy ]]
        "tsakirist/telescope-lazy.nvim",
        keys = {
            { "<leader>na", ":Telescope lazy<CR>", desc = "telescope-lazy", silent = true },
        },
        config = function()
            require("telescope").load_extension("lazy")
        end,
    },

    { --[[ telescope-zoxide ]]
        "jvgrootveld/telescope-zoxide",
        keys = {
            { "<leader>al", ":Telescope zoxide list<CR>", desc = "zoxide-list", silent = true },
        },
        config = function()
            require("telescope").load_extension("zoxide")
        end,
    },

    { --[[ telescope-live-grep-args ]]
        "nvim-telescope/telescope-live-grep-args.nvim",
        keys = {
            { "<leader>p/", ":Telescope live_grep_args<CR>", desc = "live-grep-args", silent = true },
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end,
    },

    { --[[ telescope-luasnip ]]
        "benfowler/telescope-luasnip.nvim",
        keys = {
            { "<leader>ia", ":Telescope luasnip<CR>", desc = "luasnip-snippets", silent = true },
        },
        config = function()
            require("telescope").load_extension("luasnip")
        end,
    },

    { --[[ telescope-import ]]
        "piersolenski/telescope-import.nvim",
        keys = {
            { "<leader>pi", ":Telescope import<CR>", desc = "telescope-import", silent = true },
        },
        config = function()
            require("telescope").load_extension("import")
        end,
    },

    { --[[ telescope-helpgrep ]]
        "catgoose/telescope-helpgrep.nvim",
        keys = {
            { "<leader>a/", ":Telescope helpgrep<CR>", desc = "helpgrep", silent = true },
        },
        config = function()
            require("telescope").load_extension("helpgrep")
        end,
    },

    { --[[ toggleterm-manager ]]
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/toggleterm.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>at", ":Telescope toggleterm_manager<CR>", desc = "toggleterm-manager", silent = true },
        },
        config = true,
    },

    { --[[ telescope-http ]]
        "barrett-ruth/telescope-http.nvim",
        keys = {
            { "<leader>sh", ":Telescope http list<CR>", desc = "http-codes", silent = true },
        },
        config = function()
            require("telescope").load_extension("http")
        end,
    },
}
