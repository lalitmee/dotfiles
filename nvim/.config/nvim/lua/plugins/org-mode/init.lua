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
            org_default_notes_file = "~/Projects/Personal/Github/second-brain/brain/notes/inbox.org",

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
                            target = "~/Projects/Work/Github/second-brain/sandbox/ideas/inbox.org",
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
                            target = "~/Projects/Work/Github/second-brain/daily/agenda/todos.org",
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
                            target = "~/Projects/Personal/Github/second-brain/brain/notes/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* %^{Title} :NOTE:WORK:\n  %U\n\n%?",
                            target = "~/Projects/Work/Github/second-brain/brain/notes/inbox.org",
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
                            datetree = { tree_type = "day" },
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            target = "~/Projects/Work/Github/second-brain/daily/journal/inbox.org",
                            template = "* [%<%I:%M %p>] %? :WORK:",
                            datetree = { tree_type = "day" },
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
                            target = "~/Projects/Work/Github/second-brain/daily/agenda/habits.org",
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
            { "<localleader>na", desc = "Alias" },
            { "<localleader>nb", desc = "Toggle fixed roam buffer" },
            { "<localleader>nc", desc = "Capture" },
            { "<localleader>nf", desc = "Find node" },
            { "<localleader>ni", desc = "Insert node" },
            { "<localleader>nl", desc = "Toggle roam buffer" },
            { "<localleader>nm", desc = "Insert node (immediate)" },
            { "<localleader>nn", desc = "Next node" },
            { "<localleader>np", desc = "Previous node" },
            { "<localleader>nq", desc = "Quickfix backlinks" },
            { "<localleader>n.", desc = "Complete at point" },
            {
                "<localleader>nW",
                function()
                    local roam = require("org-roam")
                    local saved = {
                        directory = roam.config.directory,
                        database = roam.config.database,
                    }
                    roam.setup({
                        directory = vim.fn.expand("~/Projects/Work/Github/second-brain/brain/notes"),
                        database = { path = vim.fn.expand("~/Projects/Work/Github/second-brain/.org-roam.db") },
                    })
                    roam.api.find_node():next(function()
                        roam.setup(saved)
                    end)
                end,
                desc = "Org-roam find (work)",
            },
            -- ponytail: lazy-loading stubs for dailies
            { "<localleader>ndn", desc = "dailies goto today" },
            { "<localleader>ndN", desc = "dailies capture today" },
            { "<localleader>ndy", desc = "dailies goto yesterday" },
            { "<localleader>ndY", desc = "dailies capture yesterday" },
            { "<localleader>ndt", desc = "dailies goto tomorrow" },
            { "<localleader>ndT", desc = "dailies capture tomorrow" },
            { "<localleader>ndd", desc = "dailies goto date" },
            { "<localleader>ndD", desc = "dailies capture date" },
            { "<localleader>ndb", desc = "dailies prev note" },
            { "<localleader>ndf", desc = "dailies next note" },
            { "<localleader>nd.", desc = "dailies find directory" },
            { "<localleader>ndWn", desc = "work dailies goto today" },
            { "<localleader>ndWN", desc = "work dailies capture today" },
            { "<localleader>ndWy", desc = "work dailies goto yesterday" },
            { "<localleader>ndWd", desc = "work dailies goto date" },
        },
        opts = {
            directory = "~/Projects/Personal/Github/second-brain/brain/notes",
            bindings = {
                prefix = "<localleader>n",
            },
            templates = {
                capture = {
                    {
                        description = "default",
                        template = "#+title: %[title]\n%?",
                        target = "%[slug].org",
                    },
                },
                immediate = {
                    description = "default",
                    template = "#+title: %[title]\n%?",
                    target = "%[slug].org",
                },
            },
            extensions = {
                dailies = {
                    directory = "daily/",
                    bindings = false,
                    templates = {
                        d = {
                            description = "default",
                            template = "* %<%H:%M> %?",
                            target = "%<%Y-%m-%d>.org",
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require("org-roam").setup(opts)

            local personal_dir = "~/Projects/Personal/Github/second-brain/brain/notes"
            local personal_db  = "~/Projects/Personal/Github/second-brain/.org-roam.db"
            local work_dir     = "~/Projects/Work/Github/second-brain/brain/notes"
            local work_db      = "~/Projects/Work/Github/second-brain/.org-roam.db"

            local function resolve_brain()
                local cwd = vim.fn.expand("%:p")
                if cwd:find("Projects/Work/") then
                    return "work"
                end
                return "personal"
            end

            local function with_brain(target, fn)
                local roam = require("org-roam")
                local saved = {
                    directory = roam.config.directory,
                    database = roam.config.database,
                }
                local dir, db = target == "work" and work_dir or personal_dir,
                                target == "work" and work_db or personal_db
                roam.setup({
                    directory = dir,
                    database = { path = db },
                })
                fn():next(function()
                    roam.setup(saved)
                end)
            end

            local dailies = require("org-roam.extensions.dailies")

            vim.keymap.set("n", "<localleader>ndn", function()
                with_brain(resolve_brain(), dailies.goto_today)
            end, { desc = "dailies goto today" })
            vim.keymap.set("n", "<localleader>ndN", function()
                with_brain(resolve_brain(), dailies.capture_today)
            end, { desc = "dailies capture today" })
            vim.keymap.set("n", "<localleader>ndy", function()
                with_brain(resolve_brain(), dailies.goto_yesterday)
            end, { desc = "dailies goto yesterday" })
            vim.keymap.set("n", "<localleader>ndY", function()
                with_brain(resolve_brain(), dailies.capture_yesterday)
            end, { desc = "dailies capture yesterday" })
            vim.keymap.set("n", "<localleader>ndt", function()
                with_brain(resolve_brain(), dailies.goto_tomorrow)
            end, { desc = "dailies goto tomorrow" })
            vim.keymap.set("n", "<localleader>ndT", function()
                with_brain(resolve_brain(), dailies.capture_tomorrow)
            end, { desc = "dailies capture tomorrow" })
            vim.keymap.set("n", "<localleader>ndd", function()
                with_brain(resolve_brain(), dailies.goto_date)
            end, { desc = "dailies goto date" })
            vim.keymap.set("n", "<localleader>ndD", function()
                with_brain(resolve_brain(), dailies.capture_date)
            end, { desc = "dailies capture date" })
            vim.keymap.set("n", "<localleader>ndb", function()
                with_brain(resolve_brain(), dailies.goto_prev_date)
            end, { desc = "dailies prev note" })
            vim.keymap.set("n", "<localleader>ndf", function()
                with_brain(resolve_brain(), dailies.goto_next_date)
            end, { desc = "dailies next note" })
            vim.keymap.set("n", "<localleader>nd.", function()
                with_brain(resolve_brain(), dailies.find_directory)
            end, { desc = "dailies find directory" })

            vim.keymap.set("n", "<localleader>ndWn", function()
                with_brain("work", dailies.goto_today)
            end, { desc = "work dailies goto today" })
            vim.keymap.set("n", "<localleader>ndWN", function()
                with_brain("work", dailies.capture_today)
            end, { desc = "work dailies capture today" })
            vim.keymap.set("n", "<localleader>ndWy", function()
                with_brain("work", dailies.goto_yesterday)
            end, { desc = "work dailies goto yesterday" })
            vim.keymap.set("n", "<localleader>ndWd", function()
                with_brain("work", dailies.goto_date)
            end, { desc = "work dailies goto date" })
        end,
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
