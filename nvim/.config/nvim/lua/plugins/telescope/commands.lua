local command = lk.command

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local config = require("telescope.config")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

--------------------------------------------------------------------------------
-- NOTE: project files {{{
--------------------------------------------------------------------------------
-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

command("TelescopeProjectFiles", function()
    local opts = {} -- define here if you want to define something

    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        require("telescope.builtin").git_files(opts)
    else
        require("telescope.builtin").find_files(opts)
    end
end)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: edit neovim config files {{{
--------------------------------------------------------------------------------
command("TelescopeEditNeovim", function()
    builtin.find_files({
        prompt_title = "~ neovim config ~",
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
end)

-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: edit dotfiles {{{
--------------------------------------------------------------------------------
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
end)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: fuzzy live grep {{{
--------------------------------------------------------------------------------
command("TelescopeFuzzyLiveGrep", function()
    vim.g.grep_string_mode = true
    vim.ui.input({
        prompt = "Grep string",
        default = vim.fn.expand("<cword>"),
    }, function(value)
        if value ~= nil then
            builtin.grep_string({ search = value })
        end
        vim.g.grep_string_mode = false
    end)
end)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: wallpaper selector {{{
--------------------------------------------------------------------------------
local function set_background(content)
    vim.notify(string.format('Wallpaper set to "%s', content), vim.log.levels.INFO, { title = "Wallpaper" })
    vim.fn.system("feh --bg-scale " .. content)
end

local function select_background(prompt_bufnr, map)
    local function set_the_background(close)
        local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
        set_background(content.cwd .. "/" .. content.value)
        if close then
            actions.close(prompt_bufnr)
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
        builtin.find_files({
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

local set_wallpaper = image_selector("< Wallpapers > ", "~/Projects/Personal/Github/wallpapers/")

command("SetWallpaper", function()
    set_wallpaper()
end)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: git hunks stage and unstage {{{
--------------------------------------------------------------------------------
local function make_git_hunk_entry(line)
    local filename, lnum_string = line:match("([^:]+):(%d+).*")

    if not filename or filename:match("^/dev/null") then
        return nil
    end

    return {
        value = filename,
        display = line,
        ordinal = line,
        filename = filename,
        lnum = tonumber(lnum_string),
    }
end

local function create_git_hunks_picker(opts)
    pickers
        .new(opts, {
            prompt_title = opts.prompt_title,
            results_title = opts.results_title,
            finder = finders.new_oneshot_job(opts.cmd, {
                entry_maker = make_git_hunk_entry,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            previewer = conf.grep_previewer({}),
            layout_strategy = "flex",
            attach_mappings = function(prompt_bufnr, map)
                local function stage_unstage_hunk(command)
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    if entry and entry.filename and entry.lnum then
                        vim.cmd(string.format("silent !git-jump %s %s:%d", command, entry.filename, entry.lnum))
                    end
                end

                map("i", "<C-s>", function()
                    stage_unstage_hunk("stage")
                end)
                map("n", "<C-s>", function()
                    stage_unstage_hunk("stage")
                end)
                map("i", "<C-u>", function()
                    stage_unstage_hunk("unstage")
                end)
                map("n", "<C-u>", function()
                    stage_unstage_hunk("unstage")
                end)

                return true
            end,
        })
        :find()
end

vim.api.nvim_create_user_command("GitHunks", function()
    create_git_hunks_picker({
        cmd = { "git-jump", "diff" },
        prompt_title = "Git Hunks",
        results_title = "Git Hunks",
    })
end, {})

vim.api.nvim_create_user_command("GitBufferHunks", function()
    local bufname = vim.api.nvim_buf_get_name(0)
    create_git_hunks_picker({
        cmd = { "git-jump", "diff", bufname },
        prompt_title = "Git Buffer Hunks",
        results_title = "Buffer Hunks",
    })
end, {})

local wk = require("which-key")
wk.add({
    { "<leader>gh", group = "git-hunks", desc = "Git Hunks" },
    { "<leader>ghh", ":GitHunks<CR>", desc = "Git Hunks" },
    { "<leader>ghb", ":GitBufferHunks<CR>", desc = "Git Hunks" },
})

-- }}}
--------------------------------------------------------------------------------

-- vim:fdm=marker
