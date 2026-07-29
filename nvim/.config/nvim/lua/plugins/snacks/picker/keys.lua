local is_inside_work_tree = {}

return {
    -- search / file
    { "<leader>:", function() Snacks.picker.commands() end, desc = "Commands", silent = true },
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find", silent = true },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Search Project", silent = true },
    { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers", silent = true },
    { "<leader>bl", function() Snacks.picker.lines() end, desc = "Buffer Lines", silent = true },
    { "<leader>el", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics", silent = true },
    { "<leader>fc", function() Snacks.picker.files({ layout = "dropdown" }) end, desc = "With Dropdown", silent = true },
    { "<leader>fd", function() Snacks.picker.files({ cwd = "~/dotfiles" }) end, desc = "Dotfiles", silent = true },
    {
        "<leader>ff",
        function()
            local cwd = vim.fn.getcwd()
            if is_inside_work_tree[cwd] == nil then
                vim.fn.system("git rev-parse --is-inside-work-tree")
                is_inside_work_tree[cwd] = vim.v.shell_error == 0
            end
            if is_inside_work_tree[cwd] then
                Snacks.picker.git_files()
            else
                Snacks.picker.files()
            end
        end,
        desc = "Files",
        silent = true,
    },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files", silent = true },
    { "<leader>fi", function() Snacks.picker.files({ layout = "ivy" }) end, desc = "Ivy Theme Files", silent = true },
    { "<leader>fo", function() Snacks.picker.recent() end, desc = "Recent Files", silent = true },
    { "<leader>ft", function() Snacks.picker.filetypes() end, desc = "File Types", silent = true },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Checkout Branch", silent = true },
    { "<leader>gcc", function() Snacks.picker.git_log() end, desc = "Git Commits", silent = true },
    { "<leader>gcb", function() Snacks.picker.git_log_file() end, desc = "Git Buffer Commits", silent = true },
    { "<leader>gz", function() Snacks.picker.git_stash() end, desc = "Git Stash", silent = true },
    { "<leader>is", function() Snacks.picker.spelling() end, desc = "Spell Suggestions", silent = true },
    { "<leader>l/", function() Snacks.picker.tags() end, desc = "Project Tags", silent = true },
    { "<leader>lT", function() Snacks.picker.treesitter() end, desc = "Treesitter Symbols", silent = true },
    { "<leader>ne", function() Snacks.picker.files({ cwd = "~/.config/nvim" }) end, desc = "Edit Neovim Config", silent = true },
    {
        "<leader>nt",
        function()
            local function get_module_name(s)
                local name = s:gsub("%.lua", ""):gsub("%/", "."):gsub("%.init", "")
                return name
            end

            Snacks.picker.files({
                prompt_title = "~ neovim modules ~",
                cwd = "~/.config/nvim/lua",
                file_ignore_patterns = { "after/", "lazy-lock.json", "stylua.toml" },
                actions = {
                    ["ctrl-r"] = {
                        name = "reload",
                        action = function(picker, item)
                            local name = get_module_name(item.file:match("[^/]+$"))
                            R(name)
                            vim.notify(name, vim.log.levels.INFO, { title = "RELOADED" })
                        end,
                    },
                },
            })
        end,
        desc = "Reload Modules",
        silent = true,
    },
    { "<leader>nx", function() Snacks.picker.reloader() end, desc = "Reloaders", silent = true },
    { "<leader>q/", function() Snacks.picker.quickfix() end, desc = "Quickfix", silent = true },
    { "<leader>sa", function() Snacks.picker.grep_word() end, desc = "Grep Word", silent = true },
    { "<leader>sG", function() Snacks.picker.grep({ cwd = "~/Projects/Work/Github/second-brain/brain/notes" }) end, desc = "Work Notes Grep", silent = true },
    { "<leader>sN", function() Snacks.picker.files({ cwd = "~/Projects/Work/Github/second-brain/brain/notes" }) end, desc = "Work Notes Files", silent = true },
    { "<leader>sg", function() Snacks.picker.grep({ cwd = "~/Projects/Personal/Github/second-brain/brain/notes" }) end, desc = "Personal Notes Grep", silent = true },
    { "<leader>sn", function() Snacks.picker.files({ cwd = "~/Projects/Personal/Github/second-brain/brain/notes" }) end, desc = "Personal Notes Files", silent = true },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume", silent = true },

    -- vim
    { "<leader>v/", function() Snacks.picker.search_history() end, desc = "Search History", silent = true },
    { "<leader>v:", function() Snacks.picker.commands() end, desc = "Commands", silent = true },
    { "<leader>va", function() Snacks.picker.autocommands() end, desc = "Autocommands", silent = true },
    { "<leader>vc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", silent = true },
    { "<leader>vC", function() Snacks.picker.command_history() end, desc = "Command History", silent = true },
    { "<leader>vf", function() Snacks.picker.filetypes() end, desc = "Filetypes", silent = true },
    { "<leader>vg", function() Snacks.picker.helpgrep() end, desc = "Help Grep", silent = true },
    { "<leader>vh", function() Snacks.picker.help() end, desc = "Help Tags", silent = true },
    { "<leader>vH", function() Snacks.picker.highlights() end, desc = "Highlights", silent = true },
    { "<leader>vj", function() Snacks.picker.jumplist() end, desc = "Jumplist", silent = true },
    { "<leader>vk", function() Snacks.picker.keymaps() end, desc = "Keymaps", silent = true },
    { "<leader>vl", function() Snacks.picker.loclist() end, desc = "Loclist", silent = true },
    { "<leader>vm", function() Snacks.picker.marks() end, desc = "Marks", silent = true },
    { "<leader>vM", function() Snacks.picker.man_pages() end, desc = "Man Pages", silent = true },
    { "<leader>vr", function() Snacks.picker.registers() end, desc = "Registers", silent = true },
    { "<leader>vt", function() Snacks.picker.tagstack() end, desc = "Tag Stack", silent = true },
    { "<leader>vv", function() Snacks.picker.vim_options() end, desc = "Vim Options", silent = true },

    -- project
    { "<leader>pf", function() Snacks.picker.files() end, desc = "Find Files", silent = true },
    { "<leader>pg", function() Snacks.picker.git_files() end, desc = "Git Files", silent = true },
    { "<leader>ps", function() Snacks.picker.grep() end, desc = "Live Grep", silent = true },
    { "<leader>pw", function() Snacks.picker.grep_word() end, desc = "Grep String", silent = true, mode = { "n", "v" } },
    { "<leader>pm", function() require("plugins.snacks.picker.sources").multi_ripgrep() end, desc = "Multi Ripgrep", silent = true },

    -- neovim
    { "<leader>nf", function() Snacks.picker.files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, desc = "Plugin Files", silent = true },
    { "<leader>na", function() Snacks.picker.lazy() end, desc = "Lazy Plugins", silent = true },

    -- zoxide
    { "<leader>al", function() Snacks.picker.zoxide() end, desc = "Zoxide", silent = true },

    -- grep
    { "<leader>p/", function() Snacks.picker.grep() end, desc = "Live Grep Args", silent = true },

    -- snippets / import
    { "<leader>ia", function() Snacks.picker.luasnip() end, desc = "Snippets", silent = true },
    { "<leader>pi", function() Snacks.picker.import() end, desc = "Import", silent = true },

    -- projects
    { "<leader>pp", function() Snacks.picker.projects() end, desc = "Projects", silent = true },

    -- git hunks
    { "<leader>ghh", function() require("plugins.snacks.picker.sources").git_hunks() end, desc = "Git Hunks", silent = true },
    { "<leader>ghb", function() require("plugins.snacks.picker.sources").git_buffer_hunks() end, desc = "Git Buffer Hunks", silent = true },
}