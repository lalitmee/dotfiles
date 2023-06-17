local command = lk.command

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local config = require("telescope.config")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")

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
end)

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

command("GitHunks", function()
    pickers
        .new({
            finder = finders.new_oneshot_job({ "git-jump", "diff" }, {
                entry_maker = function(line)
                    local filename, lnum_string = line:match("([^:]+):(%d+).*")

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
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            previewer = config.values.grep_previewer({}),
            results_title = "Git hunks",
            prompt_title = "Git hunks",
            layout_strategy = "flex",
        }, {})
        :find()
end)

--------------------------------------------------------------------------------
--  NOTE: wallpaper selector
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

local set_wallpaper = image_selector("< Wallpapers > ", "~/Desktop/Github/wallpapers/")

command("SetWallpaper", function()
    set_wallpaper()
end)
