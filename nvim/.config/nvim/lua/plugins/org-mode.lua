return {
    { --[[ orgmode ]]
        "nvim-orgmode/orgmode",
        event = "BufReadPre",
        keys = {
            { "<leader>oa", "<cmd>Org agenda<cr>", desc = "Org Agenda" },
            { "<leader>oc", "<cmd>Org capture<cr>", desc = "Org Capture" },
        },
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                config = true,
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
                -- CHANGED: Key is now 'A' (Shift+a) to avoid conflict with default 'a'
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
                "BACKLOG",
                "TODO",
                -- 2. ACTIVE DEVELOPMENT STAGES
                "IN-PROGRESS",
                "IN-REVIEW",
                "TESTING",
                -- 3. WAITING / PAUSED STAGES
                "BLOCKED",
                "WAITING",
                "ON-HOLD",
                -- SEPARATOR
                "|",
                -- 5. TERMINAL STAGES
                "DONE",
                "CANCELLED",
                "REJECTED",
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
                -- Use a dim grey to make these keywords recede into the background
                SCHEDULED = ":foreground #8a8a8a",
                DEADLINE = ":foreground #8a8a8a",
                CLOSED = ":foreground #8a8a8a",
            },

            org_capture_templates = {
                i = {
                    description = "Idea",
                    subtemplates = {
                        p = {
                            description = "Project",
                            template = "* %? :IDEA:PROJECT:",
                            target = "~/Desktop/Github/second-brain/ideas/project.org",
                        },
                        a = {
                            description = "Application",
                            template = "* %? :IDEA:APPLICATION:",
                            target = "~/Desktop/Github/second-brain/ideas/application.org",
                        },
                        n = {
                            description = "Neovim",
                            template = "* %? :IDEA:NEOVIM:",
                            target = "~/Desktop/Github/second-brain/ideas/neovim.org",
                        },
                        w = {
                            description = "Work",
                            template = "* %? :IDEA:",
                            target = "~/Desktop/Work/second-brain/ideas/inbox.org",
                        },
                    },
                },
                t = {
                    description = "Task",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* TODO %? :TASK:\n  SCHEDULED: %U\n  DEADLINE: %t",
                            target = "~/Desktop/Github/second-brain/agenda/todos.org",
                        },
                        n = {
                            description = "Neovim",
                            template = "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U\n  DEADLINE: %t",
                            target = "~/Desktop/Github/second-brain/agenda/todos.org",
                        },
                        w = {
                            description = "Work",
                            template = "* TODO %? :TASK:\n  SCHEDULED: %U\n  DEADLINE: %t",
                            target = "~/Desktop/Work/second-brain/agenda/todos.org",
                        },
                    },
                },
                n = {
                    description = "Note",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* %T %? :NOTE:\n\n%i",
                            target = "~/Desktop/Github/second-brain/notes/inbox.org",
                        },
                        w = {
                            description = "Work",
                            template = "* %T %? :NOTE:\n\n%i",
                            target = "~/Desktop/Work/second-brain/notes/inbox.org",
                        },
                    },
                },
                j = {
                    description = "Journal",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "\n** %U :JOURNAL:\n\n%?",
                            target = "file+datetree ~/Desktop/Github/second-brain/journal/inbox.org",
                        },
                        w = {
                            description = "Work",
                            template = "\n** %U :JOURNAL:\n\n%?",
                            target = "file+datetree ~/Desktop/Work/second-brain/journal/inbox.org",
                        },
                    },
                },
                m = {
                    description = "Meeting",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* MEETING with %? :MEETING:\n  SCHEDULED: %U",
                            target = "~/Desktop/Github/second-brain/agenda/calls.org",
                        },
                        w = {
                            description = "Work",
                            template = "* MEETING with %? :MEETING:\n  SCHEDULED: %U",
                            target = "~/Desktop/Work/second-brain/agenda/calls.org",
                        },
                    },
                },
                p = {
                    description = "Phone Call",
                    subtemplates = {
                        p = {
                            description = "Personal",
                            template = "* CALL with %? :PHONE:\n  SCHEDULED: %U",
                            target = "~/Desktop/Github/second-brain/agenda/calls.org",
                        },
                        w = {
                            description = "Work",
                            template = "* CALL with %? :PHONE:\n  SCHEDULED: %U",
                            target = "~/Desktop/Work/second-brain/agenda/calls.org",
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
                        },
                        w = {
                            description = "Work",
                            template = "* NEXT %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
                            target = "~/Desktop/Work/second-brain/agenda/habits.org",
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
    },
}
