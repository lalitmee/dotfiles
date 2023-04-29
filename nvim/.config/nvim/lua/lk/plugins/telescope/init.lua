local M = {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
        {
            "nvim-telescope/telescope-frecency.nvim",
            dependencies = { "kkharji/sqlite.lua" },
            init = function()
                require("telescope").load_extension("frecency")
            end,
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            init = function()
                require("telescope").load_extension("fzf")
            end,
        },
        {
            "nvim-telescope/telescope-ui-select.nvim",
            init = function()
                require("telescope").load_extension("ui-select")
            end,
        },
        {
            "zane-/howdoi.nvim",
            init = function()
                require("telescope").load_extension("howdoi")
            end,
        },
        {
            "nvim-telescope/telescope-github.nvim",
            init = function()
                require("telescope").load_extension("gh")
            end,
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            init = function()
                require("telescope").load_extension("live_grep_args")
            end,
        },
        {
            "debugloop/telescope-undo.nvim",
            init = function()
                require("telescope").load_extension("undo")
            end,
        },
        {
            "danielvolchek/tailiscope.nvim",
            ft = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
            },
            init = function()
                require("telescope").load_extension("tailiscope")
            end,
        },
        {
            "danielfalk/smart-open.nvim",
            init = function()
                require("telescope").load_extension("smart_open")
            end,
            dependencies = { "kkharji/sqlite.lua" },
        },
        {
            "tsakirist/telescope-lazy.nvim",
            init = function()
                require("telescope").load_extension("lazy")
            end,
        },
        {
            "prochri/telescope-all-recent.nvim",
            dependencies = { "kkharji/sqlite.lua" },
        },
        {
            "LukasPietzschmann/telescope-tabs",
            init = function()
                require("telescope-tabs").setup()
            end,
        },
    },
    init = function()
        require("telescope").load_extension("messages")
        require("telescope").load_extension("dotfiles")
    end,
}

M.config = function()
    local telescope = require("telescope")

    local should_reload = true
    local reloader = function()
        if should_reload then
            RELOAD("plenary")
            RELOAD("telescope")
        end
    end
    reloader()

    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_utils = require("telescope.actions.utils")
    local action_layout = require("telescope.actions.layout")
    local previewers = require("telescope.previewers")
    local themes = require("telescope.themes")

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
    --  NOTE: action to open entried in the results {{{
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
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: maker for buffers list {{{
    --------------------------------------------------------------------------------
    local Job = require("plenary.job")
    local new_maker = function(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job
            :new({
                command = "file",
                args = { "--mime-type", "-b", filepath },
                on_exit = function(j)
                    local mime_class = vim.split(j:result()[1], "/")[1]
                    local mime_type = j:result()[1]
                    if
                        mime_class == "text"
                        or (
                            mime_class == "application"
                            and mime_type ~= "application/x-pie-executable"
                        )
                    then
                        previewers.buffer_previewer_maker(filepath, bufnr, opts)
                    else
                        -- maybe we want to write something to the buffer here
                        vim.schedule(function()
                            vim.api.nvim_buf_set_lines(
                                bufnr,
                                0,
                                -1,
                                false,
                                { "BINARY" }
                            )
                        end)
                    end
                end,
            })
            :sync()
    end
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: setup {{{
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
                    ["<C-b>"] = open_entries,
                    ["<C-e>"] = actions.move_to_bottom,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-o>"] = actions.send_selected_to_qflist
                        + actions.open_qflist,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-y>"] = actions.move_to_top,
                    ["<M-o>"] = action_layout.toggle_prompt_position,
                    ["<M-p>"] = action_layout.toggle_preview,
                    ["<M-v>"] = action_layout.toggle_mirror,
                    ["<esc>"] = actions.close,
                },
                n = {
                    ["<Down>"] = actions.cycle_history_next,
                    ["<Up>"] = actions.cycle_history_prev,
                    ["<esc>"] = actions.close,
                    ["e"] = actions.move_to_bottom,
                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,
                    ["o"] = actions.send_selected_to_qflist
                        + actions.open_qflist,
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

            layout_strategy = "horizontal",
            layout_config = {
                width = 0.95,
                height = 0.95,
                prompt_position = "top",
                horizontal = {
                    preview_width = function(_, cols, _)
                        if cols > 200 then
                            return math.floor(cols * 0.5)
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
            -- layout_config = {
            --     width = 0.90,
            --     height = 0.90,
            --     prompt_position = "top",
            --     horizontal = {
            --         width_padding = 0.11,
            --         height_padding = 0.13,
            --         preview_width = 0.56,
            --     },
            --     vertical = {
            --         width_padding = 0.4,
            --         height_padding = 0.8,
            --         preview_height = 0.5,
            --     },
            --     flex = {
            --         horizontal = {
            --             preview_width = 0.8,
            --         },
            --     },
            -- },
            file_previewer = previewers.vim_buffer_cat.new,
            grep_previewer = previewers.vim_buffer_vimgrep.new,
            qflist_previewer = previewers.vim_buffer_qflist.new,
        },
        pickers = {
            buffers = dropdown({
                path_display = { "smart" },
                previewer = false,
                sort_mru = true,
                sort_lastused = true,
                show_all_buffers = true,
                ignore_current_buffer = true,
                mappings = {
                    i = { ["<c-d>"] = "delete_buffer" },
                    n = { ["d"] = "delete_buffer" },
                },
            }),
            live_grep = {
                file_ignore_patterns = { ".git/" },
                mappings = {
                    i = {
                        ["<c-f>"] = require("telescope.actions").to_fuzzy_refine,
                    },
                },
            },
            -- current_buffer_fuzzy_find = dropdown({
            --     previewer = false,
            -- }),
            lsp_code_actions = {
                theme = "cursor",
            },
            colorscheme = {
                -- enable_preview = true,
            },
            find_files = {
                -- find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
        },
        extensions = {
            howdoi = {
                num_answers = 3,
                explain_answer = true,
            },
            ["ui-select"] = {
                require("telescope.themes").get_dropdown({}),
            },
            frecency = {
                default_workspace = "CWD",
                show_unindexed = false, -- Show all files or only those that have been indexed
                ignore_patterns = {
                    "*.git/*",
                    "*/tmp/*",
                    "*node_modules/*",
                    "*vendor/*",
                },
                workspaces = {
                    ["nvim"] = "/home/lalitmee/.config/nvim/plugged",
                    ["dotf"] = "/home/lalitmee/dotfiles",
                    ["git"] = "/home/lalitmee/Desktop/Github",
                    ["conf"] = "/home/lalitmee/.config",
                    ["data"] = "/home/lalitmee/.local/share",
                },
            },
            project = {
                base_dirs = {
                    { "~/", max_depth = 7 },
                },
                hidden_files = true,
                order_by = "recent",
            },
            lazy = {},
        },
    })
    -- NOTE: this requires to be loaded after telescope
    require("telescope-all-recent").setup({})
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: load extensions {{{
    ----------------------------------------------------------------------
    -- projects extension
    require("telescope").load_extension("projects")

    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: custom commands {{{
    ----------------------------------------------------------------------
    local command = lk.command

    command("TelescopeEditNeovim", function()
        builtin.find_files({
            prompt_title = "~ neovim ~",
            cwd = "~/.config/nvim",

            layout_strategy = "horizontal",
            layout_defaults = {
                horizontal = {
                    width_padding = 0.11,
                    height_padding = 0.13,
                    preview_width = 0.56,
                },
                vertical = {
                    width_padding = 0.4,
                    height_padding = 0.8,
                    preview_height = 0.5,
                },
            },
        })
    end, {})

    command("TelescopeEditDotfiles", function()
        builtin.find_files({
            prompt_title = "~ dotfiles ~",
            hidden = true,
            cwd = "~/dotfiles",

            layout_strategy = "horizontal",
            layout_defaults = {
                horizontal = {
                    width_padding = 0.11,
                    height_padding = 0.13,
                    preview_width = 0.56,
                },
                vertical = {
                    width_padding = 0.4,
                    height_padding = 0.8,
                    preview_height = 0.5,
                },
            },
        })
    end, {})

    command("TelescopeFuzzyLiveGrep", function()
        vim.g.grep_string_mode = true
        vim.ui.input({
            prompt = "Grep string",
            default = vim.fn.expand("<cword>"),
        }, function(value)
            if value ~= nil then
                require("telescope.builtin").grep_string({ search = value })
            end
            vim.g.grep_string_mode = false
        end)
    end, {})

    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: mappings {{{
    ----------------------------------------------------------------------
    lk.cmap(
        "<c-r><c-r>",
        "<Plug>(TelescopeFuzzyCommandSearch)",
        { noremap = false, nowait = true }
    )
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: autocmds {{{
    ----------------------------------------------------------------------
    lk.augroup("telescope_au", {
        {
            event = { "Filetype" },
            pattern = { "TelescopeResults" },
            command = function()
                vim.cmd([[setlocal notfoldenable]])
            end,
        },
        {
            event = { "User" },
            pattern = { "TelescopePreviewerLoaded" },
            command = function()
                vim.cmd([[setlocal wrap]])
            end,
        },
    })
    -- }}}
    ----------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: wallpaper selector {{{
    --------------------------------------------------------------------------------
    local function set_background(content)
        print(content)
        vim.fn.system("feh --bg-scale " .. content)
    end

    local function select_background(prompt_bufnr, map)
        local function set_the_background(close)
            local content =
                require("telescope.actions.state").get_selected_entry(
                    prompt_bufnr
                )
            set_background(content.cwd .. "/" .. content.value)
            if close then
                require("telescope.actions").close(prompt_bufnr)
            end
        end

        map("i", "<C-n>", function()
            actions.move_selection_next(prompt_bufnr)
            set_the_background()
        end)

        map("i", "<C-p>", function()
            actions.move_selection_previous(prompt_bufnr)
            set_the_background()
        end)

        map("i", "<CR>", function()
            set_the_background(true)
        end)
    end

    local function image_selector(prompt, cwd)
        return function()
            require("telescope.builtin").find_files({
                prompt_title = prompt,
                cwd = cwd,

                attach_mappings = function(prompt_bufnr, map)
                    select_background(prompt_bufnr, map)
                    -- Please continue mapping (attaching additional key maps):
                    -- Ctrl+n/p to move up and down the list.
                    return true
                end,
            })
        end
    end

    local set_wallpaper =
        image_selector("< Wallpapers > ", "~/Desktop/Github/wallpapers/")

    lk.command("ChangeSystemBackground", function()
        set_wallpaper()
    end, {})
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: git hunks {{{
    --------------------------------------------------------------------------------
    local git_hunks = function()
        require("telescope.pickers")
            .new({
                finder = require("telescope.finders").new_oneshot_job(
                    { "git-jump", "diff" },
                    {
                        entry_maker = function(line)
                            local filename, lnum_string =
                                line:match("([^:]+):(%d+).*")

                            -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
                            -- return nil if filename is /dev/null because this means the file was deleted.
                            if filename:match("^/dev/null") then
                                return nil
                            end

                            return {
                                value = filename,
                                display = line,
                                ordinal = line,
                                filename = filename,
                                lnum = tonumber(lnum_string),
                            }
                        end,
                    }
                ),
                sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
                previewer = require("telescope.config").values.grep_previewer({}),
                results_title = "Git hunks",
                prompt_title = "Git hunks",
                layout_strategy = "flex",
            }, {})
            :find()
    end

    lk.command("GitHunks", git_hunks, {})
    -- }}}
    --------------------------------------------------------------------------------
end

return M

-- vim:foldmethod=marker
