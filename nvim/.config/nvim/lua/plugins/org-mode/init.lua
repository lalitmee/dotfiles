return {
    { --[[ orgmode ]]
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>o", group = "org-mode" },
                { "<leader>ob", group = "org tangle" },
                { "<leader>od", group = "org dates" },
                { "<leader>oi", group = "org insert" },
                { "<leader>ol", group = "org links" },
                { "<leader>on", group = "org notes" },
                { "<leader>os", group = "org toggle" },
                { "<leader>ox", group = "org clock" },
                { "<localleader>n", group = "org roam" },
                { "<localleader>na", group = "alias" },
                { "<localleader>no", group = "origin" },
                { "<localleader>nd", group = "dailies" },
            })
        end,
        keys = {
            { "<leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
            { "<leader>oc", "<cmd>Org capture<cr>", desc = "org capture" },
            { "<leader>ow", "<cmd>Org agenda w<cr>", desc = "org work agenda" },
            { "<leader>op", "<cmd>Org agenda p<cr>", desc = "org personal agenda" },
            { "<leader>oTa", "<cmd>EasyAlign|<cr>", desc = "org table align", mode = "v" },
            { "<leader>oTl", "<cmd>lua align_org_table()<cr>", desc = "org table align (lua)", mode = "v" },
        },
        dependencies = {
            { --[[ org-bullets.nvim ]]
                "akinsho/org-bullets.nvim",
                opts = {
                    concealcursor = true,
                    symbols = {
                        checkboxes = {
                            half = { "", "@org.checkbox.halfchecked" },
                            done = { "✓", "@org.checkbox.checked" },
                            todo = { " ", "@org.checkbox" },
                        },
                    },
                },
            },

            { --[[ org-modern.nvim ]]
                "danilshvalov/org-modern.nvim",
            },

            { --[[ org-list.nvim ]]
                "hamidi-dev/org-list.nvim",
                dependencies = {
                    "tpope/vim-repeat",
                },
                opts = {
                    mapping = {
                        key = "<leader>osl",
                        desc = "org list toggle",
                    },

                    checkbox_toggle = {
                        enabled = true,
                        key = "<leader>osc",
                        desc = "org list checkbox toggle",
                    },
                },
            },
        },
        opts = {
            org_agenda_files = {
                "~/Projects/Work/Github/second-brain/**/*", -- work todo
                "~/Projects/Personal/Github/second-brain/**/*", -- personal todo
            },
            org_default_notes_file = "~/Projects/Personal/Github/second-brain/notes/inbox.org",

            org_archive_location = "~/Projects/Personal/Github/second-brain/archive/inbox.org::",

            -- Indentation and View
            org_startup_indented = true,
            org_hide_emphasis_markers = true,

            -- Set the agenda to show a 14-day span
            org_agenda_span = 14,

            -- Set the agenda week to start on Monday
            org_agenda_start_on_weekday = 1,

            org_agenda_custom_commands = {
                A = {
                    description = "📅 Agenda & All Tasks (Global)",
                    types = {
                        { type = "agenda" },
                        { type = "tags_todo" },
                    },
                },
                w = {
                    description = "💼 Work Focus",
                    types = {
                        {
                            type = "agenda",
                            org_agenda_files = { "~/Projects/Work/Github/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Projects/Work/Github/second-brain/**/*" },
                        },
                    },
                },
                p = {
                    description = "🏠 Personal Focus",
                    types = {
                        {
                            type = "agenda",
                            org_agenda_files = { "~/Projects/Personal/Github/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Projects/Personal/Github/second-brain/**/*" },
                        },
                    },
                },
                T = {
                    description = "📋 Triage / Planning",
                    types = {
                        { type = "tags_todo", match = "BACKLOG" },
                    },
                },
            },

            org_todo_keywords = {
                "BACKLOG(b)",
                "TODO(t)",
                "IN-PROGRESS(p)",
                "|",
                "DONE(d)",
                "CANCELLED(c)",
            },

            org_todo_keyword_faces = {
                BACKLOG = ":foreground #a8a8a8",
                TODO = ":foreground #0088ff :weight bold",
                ["IN-PROGRESS"] = ":foreground #ffd700 :weight bold",
                DONE = ":foreground #5fff5f :weight bold",
                CANCELLED = ":foreground #585858 :weight bold",
            },

            org_tag_faces = {
                -- By type
                IDEA = ":foreground #ffc600 :weight bold",
                RAW = ":foreground #af87ff :slant italic",
                PROJECT = ":foreground #ffc600",
                APPLICATION = ":foreground #ffc600",
                TASK = ":foreground #0088ff",
                NOTE = ":foreground #9effff :slant italic",
                HABIT = ":foreground #ff9d00",
                -- By context
                WORK = ":foreground #a5ff90",
                NEOVIM = ":foreground #a5ff90 :weight bold",
            },

            org_capture_templates = {
                i = {
                    description = "💡 Idea",
                    subtemplates = {
                        i = {
                            description = "💡 Raw Idea",
                            template = "* %? :IDEA:RAW:",
                            target = "~/Projects/Personal/Github/second-brain/sandbox/ideas/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        p = {
                            description = "🚀 Project",
                            template = "* %? :IDEA:PROJECT:",
                            target = "~/Projects/Personal/Github/second-brain/sandbox/ideas/project.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        a = {
                            description = "💻 Application",
                            template = "* %? :IDEA:APPLICATION:",
                            target = "~/Projects/Personal/Github/second-brain/sandbox/ideas/application.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        n = {
                            description = "💤 Neovim",
                            template = "* %? :IDEA:NEOVIM:",
                            target = "~/Projects/Personal/Github/second-brain/sandbox/ideas/neovim.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* %? :IDEA:WORK:",
                            target = "~/Projects/Work/Github/second-brain/ideas/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                t = {
                    description = "📋 Task",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            template = "* TODO %? :TASK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Projects/Personal/Github/second-brain/daily/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        n = {
                            description = "💤 Neovim",
                            template = "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Projects/Personal/Github/second-brain/daily/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* TODO %? :TASK:WORK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Projects/Work/Github/second-brain/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                n = {
                    description = "📓 Note",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            template = "* %^{Title} :NOTE:\n  %U\n\n%?",
                            target = "~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* %^{Title} :NOTE:WORK:\n  %U\n\n%?",
                            target = "~/Projects/Work/Github/second-brain/notes/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                j = {
                    description = "📝 Journal",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            target = "~/Projects/Personal/Github/second-brain/daily/journal/inbox.org",
                            template = "* [%<%I:%M %p>] %?",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            target = "~/Projects/Work/Github/second-brain/journal/inbox.org",
                            template = "* [%<%I:%M %p>] %? :WORK:",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                h = {
                    description = "⚡ Habit",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            template = "* TODO %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:",
                            target = "~/Projects/Personal/Github/second-brain/daily/agenda/habits.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* TODO %? :HABIT:WORK:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:",
                            target = "~/Projects/Work/Github/second-brain/agenda/habits.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            local Menu = require("org-modern.menu")

            opts.ui = opts.ui or {}
            opts.ui.menu = {
                handler = function(data)
                    Menu:new({
                        window = {
                            margin = { 1, 0, 1, 0 },
                            padding = { 0, 1, 0, 1 },
                            title_pos = "center",
                            border = "single",
                            zindex = 1000,
                        },
                        icons = {
                            separator = "➜",
                        },
                    }):open(data)
                end,
            }

            --------------------------------------------------------------------------------
            -- -- NOTE: Just a little bit of code that uses Treesitter to handle different {{{
            --          org action when the "Enter" key is pressed (toggle TODO, toggle
            --          checkbox, open dates and links)
            --          https://gist.github.com/andreadev-it/413e6ed62eefa7e2f85e7a611e962f60
            --------------------------------------------------------------------------------

            require("orgmode").setup(opts)
            require("plugins.org-mode.fix-ts-predicates")
            require("blink.cmp").setup({
                sources = {
                    per_filetype = {
                        org = { "orgmode" },
                    },
                    providers = {
                        orgmode = {
                            name = "Orgmode",
                            module = "orgmode.org.autocompletion.blink",
                            fallbacks = { "buffer" },
                        },
                    },
                },
            })

            --------------------------------------------------------------------------------
            -- -- NOTE: Just a little bit of code that uses Treesitter to handle different {{{
            --          org action when the "Enter" key is pressed (toggle TODO, toggle
            --          checkbox, open dates and links)
            --          https://gist.github.com/andreadev-it/413e6ed62eefa7e2f85e7a611e962f60
            --------------------------------------------------------------------------------

            local org_mappings = require("orgmode.org.mappings")

            -- This function will be used instead of treesitter to find links
            local find_link = function()
                return org_mappings._get_link_under_cursor()
            end

            -- You can find the type (the key in this table) by using the plugin Treesitter Playground
            -- For the value, you can open an org file and type ":map" to show all keybindings. The values
            -- should match what you find as the parameter for the "require('orgmode').action()" function.
            -- If treesitter does not support a specific type of object, you can still include it in this
            -- list by creating a function and using it as a key of this table. The function should return
            -- something when it finds what it's looking for, while it should return `nil` if it didn't find
            -- anything.
            local type_to_action = {
                [find_link] = "org_mappings.open_at_point",
                timestamp = "org_mappings.change_date",
                headline = "org_mappings.todo_next_state",
                listitem = "org_mappings.toggle_checkbox",
                list = "org_mappings.toggle_checkbox",
                _default = "org_mappings.open_at_point",
            }

            local function get_action_from_type()
                local ts_utils = require("nvim-treesitter.ts_utils")
                local cur_node = ts_utils.get_node_at_cursor()
                local cur_row = cur_node ~= nil and cur_node:range()

                while cur_node ~= nil do
                    local nodetype = cur_node:type()

                    for identifier, action in pairs(type_to_action) do
                        if type(identifier) == "function" then
                            if identifier() ~= nil then
                                return action
                            end
                        elseif nodetype == identifier and identifier ~= "_default" then
                            return action
                        end
                    end

                    cur_node = cur_node:parent()
                    if cur_node == nil then
                        break
                    elseif cur_node:range() ~= cur_row then
                        break
                    end
                end

                return type_to_action._default
            end

            local function toggle_org_item()
                local org = require("orgmode")

                local action = get_action_from_type()

                if action ~= nil then
                    org.action(action)
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "org",
                callback = function()
                    vim.api.nvim_buf_set_keymap(0, "n", "<cr>", "", {
                        callback = function()
                            toggle_org_item()
                        end,
                        noremap = true,
                    })
                end,
            })

            --------------------------------------------------------------------------------
            -- }}}
            --------------------------------------------------------------------------------
        end,
    },

    {
        "chipsenkbeil/org-roam.nvim",
        dependencies = {
            {
                "nvim-orgmode/orgmode",
            },
        },
        keys = {
            { "<localleader>na" },
            { "<localleader>nb" },
            { "<localleader>nc" },
            { "<localleader>nf" },
            { "<localleader>ni" },
            { "<localleader>nl" },
            { "<localleader>nm" },
            { "<localleader>nn" },
            { "<localleader>np" },
            { "<localleader>nq" },
            { "<localleader>n." },
        },
        opts = {
            directory = "~/Projects/Personal/Github/notes",
            bindings = {
                prefix = "<localleader>n",
            },
        },
    },

    { --[[ org-super-agenda.nvim ]]
        "hamidi-dev/org-super-agenda.nvim",
        dependencies = {
            "nvim-orgmode/orgmode",
        },
        cmd = "OrgSuperAgenda",
        keys = {
            { "<leader>o.", "<cmd>OrgSuperAgenda<cr>", desc = "org super agenda" },
        },
        opts = {
            org_directories = {
                "~/Projects/Work/Github/second-brain",
                "~/Projects/Personal/Github/second-brain",
            },
        },
    },
}
