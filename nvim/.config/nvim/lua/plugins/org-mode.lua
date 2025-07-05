return {
    { --[[ orgmode ]]
        "nvim-orgmode/orgmode",
        ft = "org",
        keys = {
            { "<leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
            { "<leader>oc", "<cmd>Org capture<cr>", desc = "org capture" },
            { "<leader>ow", "<cmd>Org agenda w<cr>", desc = "org work agenda" },
            { "<leader>op", "<cmd>Org agenda p<cr>", desc = "org personal agenda" },
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

            {
                "chipsenkbeil/org-roam.nvim",
                tag = "0.1.1",
                dependencies = {
                    {
                        "nvim-orgmode/orgmode",
                        tag = "0.3.7",
                    },
                },
                opts = {
                    directory = "~/Desktop/Github/notes",
                },
            },
        },
        opts = {
            org_agenda_files = {
                "~/Desktop/Work/second-brain/**/*", -- work todo
                "~/Desktop/Github/second-brain/**/*", -- personal todo
            },
            org_default_notes_file = "~/Desktop/Github/second-brain/notes/inbox.org",

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
                            org_agenda_files = { "~/Desktop/Work/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Desktop/Work/second-brain/**/*" },
                        },
                    },
                },
                p = {
                    description = "🏠 Personal Focus",
                    types = {
                        {
                            type = "agenda",
                            org_agenda_files = { "~/Desktop/Github/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Desktop/Github/second-brain/**/*" },
                        },
                    },
                },
                -- CHANGED: Key is now 'T' (Shift+t) to avoid conflict with default 't'
                T = {
                    description = "📋 Triage / Planning",
                    types = {
                        { type = "tags_todo", match = "BACKLOG" },
                    },
                },
                i = {
                    description = "🚀 In Progress View",
                    types = {
                        { type = "tags_todo", match = "IN-PROGRESS/IN-REVIEW/TESTING" },
                    },
                },
                b = {
                    description = "❗ Blocked / Waiting",
                    types = {
                        { type = "tags_todo", match = "BLOCKED/WAITING" },
                    },
                },
            },

            org_todo_keywords = {
                -- 1. PLANNING & TRIAGE STAGES
                "BACKLOG(b)",
                "TODO(t)",

                -- 2. ACTIVE DEVELOPMENT STAGES
                "IN-PROGRESS(p)", -- "p" for "progress"
                "IN-REVIEW(r)", -- "r" for "review"
                "TESTING(e)", -- "e" from "t**e**sting"

                -- 3. WAITING / PAUSED STAGES
                "BLOCKED(l)", -- "l" from "b**l**ocked"
                "WAITING(w)",
                "ON-HOLD(h)",

                -- SEPARATOR
                "|",

                -- 5. TERMINAL STAGES
                "DONE(d)",
                "CANCELLED(c)",
                "REJECTED(j)", -- "j" from "re**j**ected"
            },

            org_todo_keyword_faces = {
                -- Planning Faces
                BACKLOG = ":foreground #a8a8a8",
                TODO = ":foreground #0088ff :weight bold",
                -- Active Dev Faces
                ["IN-PROGRESS"] = ":foreground #ffd700 :weight bold",
                ["IN-REVIEW"] = ":foreground #00d7d7 :weight bold",
                TESTING = ":foreground #87ceff :weight bold",
                -- Waiting/Paused Faces
                BLOCKED = ":foreground #ff2020 :background #5c0000 :weight bold",
                WAITING = ":foreground #ff5faf :weight bold",
                ["ON-HOLD"] = ":foreground #d7aaff :weight bold",
                -- Terminal Faces
                DONE = ":foreground #5fff5f :weight bold",
                CANCELLED = ":foreground #585858 :weight bold",
                REJECTED = ":foreground #d75f00 :weight bold",
            },

            org_tag_faces = {
                -------------------------------------------------------------------------
                -- === BY TYPE (What kind of thing is this?) ===
                -------------------------------------------------------------------------
                -- Use the vibrant Cobalt2 yellow for creative/new items
                IDEA = ":foreground #ffc600 :weight bold",
                RAW = ":foreground #af87ff :slant italic",
                PROJECT = ":foreground #ffc600",
                APPLICATION = ":foreground #ffc600",

                -- Use the action-oriented Cobalt2 orange for recurring tasks
                HABIT = ":foreground #ff9d00",

                -- Use a calm, italic light blue for reflective entries
                NOTE = ":foreground #9effff :slant italic",
                JOURNAL = ":foreground #9effff :slant italic",

                -- Use a simple, non-intrusive blue for utility tags
                LINK = ":foreground #0088ff",

                -------------------------------------------------------------------------
                -- === BY CONTEXT (Where does this belong?) ===
                -------------------------------------------------------------------------
                -- Use the pleasant Cobalt2 green for your main work context
                WORK = ":foreground #a5ff90",

                -- A distinct, friendly blue for personal context
                PERSONAL = ":foreground #0088ff",

                -- A bold, thematic green for Neovim-specific items
                NEOVIM = ":foreground #a5ff90 :weight bold",

                -------------------------------------------------------------------------
                -- === BY EVENT (What kind of appointment is this?) ===
                -------------------------------------------------------------------------
                -- A consistent green for meetings and calls
                MEETING = ":foreground #5fffaf",
                PHONE = ":foreground #5fffaf",

                -------------------------------------------------------------------------
                -- === MANUAL DEV TAGS (For you to type manually) ===
                -------------------------------------------------------------------------
                -- High-alert Cobalt2 pink for critical issues
                BUG = ":foreground #ff628c :weight bold",

                -- Cobalt2 yellow for new development work
                FEATURE = ":foreground #ffc600",

                -- Cobalt2 light blue for code maintenance
                REFACTOR = ":foreground #9effff",
                DOCS = ":foreground #9effff",
                TESTS = ":foreground #9effff",

                -------------------------------------------------------------------------
                -- === MANUAL PRIORITY TAGS (For you to type manually) ===
                -------------------------------------------------------------------------
                CRITICAL = ":foreground #ff628c :weight bold",
                HIGH = ":foreground #ff9d00 :weight bold",
                LOW = ":foreground #a8a8a8 :slant italic",
            },

            org_special_keyword_faces = {
                SCHEDULED = ":foreground #8a8a8a",
                DEADLINE = ":foreground #8a8a8a",
                CLOSED = ":foreground #8a8a8a",
            },

            org_capture_templates = {
                i = {
                    description = "Idea",
                    subtemplates = {
                        i = {
                            description = "Raw Idea",
                            template = "* %? :IDEA:RAW:",
                            target = "~/Desktop/Github/second-brain/ideas/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        p = {
                            description = "Project",
                            template = "* %? :IDEA:PROJECT:",
                            target = "~/Desktop/Github/second-brain/ideas/project.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        a = {
                            description = "Application",
                            template = "* %? :IDEA:APPLICATION:",
                            target = "~/Desktop/Github/second-brain/ideas/application.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        n = {
                            description = "Neovim",
                            template = "* %? :IDEA:NEOVIM:",
                            target = "~/Desktop/Github/second-brain/ideas/neovim.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* %? :IDEA:WORK:",
                            target = "~/Desktop/Work/second-brain/ideas/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                t = {
                    description = "Task",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* TODO %? :TASK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Desktop/Github/second-brain/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        n = {
                            description = "Neovim",
                            template = "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Desktop/Github/second-brain/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* TODO %? :TASK:WORK:\n  SCHEDULED: %U DEADLINE: %t",
                            target = "~/Desktop/Work/second-brain/agenda/todos.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                n = {
                    description = "Note",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* %^{Title} :NOTE:\n  %U\n\n%?",
                            target = "~/Desktop/Github/second-brain/notes/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* %^{Title} :NOTE:WORK:\n  %U\n\n%?",
                            target = "~/Desktop/Work/second-brain/notes/inbox.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                j = {
                    description = "Journal",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            target = "~/Desktop/Github/second-brain/journal/inbox.org",
                            template = "**** [%<%I:%M %p>] %?",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            target = "~/Desktop/Github/second-brain/journal/inbox.org",
                            template = "**** [%<%I:%M %p>] %? :WORK:",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                m = {
                    description = "Meeting",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* MEETING with %? :MEETING:\n  SCHEDULED: %t",
                            target = "~/Desktop/Github/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* MEETING with %? :MEETING:WORK:\n  SCHEDULED: %t",
                            target = "~/Desktop/Work/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                p = {
                    description = "Phone Call",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* CALL with %? :PHONE:\n  SCHEDULED: %t",
                            target = "~/Desktop/Github/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* CALL with %? :PHONE:WORK:\n  SCHEDULED: %t",
                            target = "~/Desktop/Work/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                h = {
                    description = "Habit",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* NEXT %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
                            target = "~/Desktop/Github/second-brain/agenda/habits.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "Work",
                            template = "* NEXT %? :HABIT:WORK:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
                            target = "~/Desktop/Work/second-brain/agenda/habits.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },

                l = {
                    description = "Link",
                    subtemplates = {
                        r = {
                            description = "Useful resource links",
                            template = "  - [[%^{Link||}][%^{Description}]] :LINK:",
                            headline = "Useful resource links",
                            target = "~/Desktop/Github/second-brain/vocabulary/links.org",
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

            require("orgmode").setup(opts)
            require("org-bullets").setup({
                concealcursor = true,
                symbols = {
                    checkboxes = {
                        half = { "", "@org.checkbox.halfchecked" },
                        done = { "✓", "@org.checkbox.checked" },
                        todo = { " ", "@org.checkbox" },
                    },
                },
            })

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
        end,
    },
}
