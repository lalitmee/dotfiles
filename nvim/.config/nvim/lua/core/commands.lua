local command = lk.command
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: snacks commands {{{
----------------------------------------------------------------------
command("ReloadConfigSnacks", function()
    require("utils/reload").reload()
end)

command("ReloadModule", function(args)
    require("utils/reload").reload_module(args)
end)

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: config commands {{{
----------------------------------------------------------------------
command("ReloadConfig", function()
    require("utils/reload").reload_config()
end)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: neovim utility commands {{{
----------------------------------------------------------------------
command("ToggleBackground", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
end)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: auto resize splits {{{
----------------------------------------------------------------------
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

local auto_resize = function()
    local auto_resize_on = false
    return function(args)
        if not auto_resize_on then
            local factor = args and tonumber(args) or 70
            local fraction = factor / 10
            -- NOTE: mutating &winheight/&winwidth are key to how
            -- this functionality works, the API fn equivalents do
            -- not work the same way
            vim.cmd(fmt("let &winheight=&lines * %d / 10 ", fraction))
            vim.cmd(fmt("let &winwidth=&columns * %d / 10 ", fraction))
            auto_resize_on = true
            vim.notify("Auto resize ON")
        else
            vim.cmd("let &winheight=30")
            vim.cmd("let &winwidth=30")
            vim.cmd("wincmd =")
            auto_resize_on = false
            vim.notify("Auto resize OFF")
        end
    end
end
command("AutoResize", auto_resize(), { nargs = "?" })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: open help in new tab {{{
----------------------------------------------------------------------
command("HelpTab", function()
    vim.cmd([[tab help]])
end, { nargs = "?", complete = "help" })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: compile {{{
----------------------------------------------------------------------
command("CompileAndRun", function()
    require("utils/compiler").compile_and_run()
end)

-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: git jump {{{
--------------------------------------------------------------------------------
vim.cmd([[
command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))
]])
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: BufOnly {{{
--------------------------------------------------------------------------------
command("BufOnly", function()
    local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false
    local cur = vim.api.nvim_get_current_buf()
    local deleted, modified = 0, 0
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
        -- If the iter buffer is modified one, then don't do anything
        if vim.api.nvim_get_option_value("modified", { buf = n }) then
            -- iter is not equal to current buffer
            -- iter is modifiable or del_non_modifiable == true
            -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
            modified = modified + 1
        elseif n ~= cur and (vim.api.nvim_get_option_value("modifiable", { buf = n }) or del_non_modifiable) then
            vim.api.nvim_buf_delete(n, {})
            deleted = deleted + 1
        end
    end
    vim.notify(fmt("%s deleted buffer(s), %s modified buffer(s)", deleted, modified), 2, {
        title = " BufOnly",
    })
end)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: get current working directory {{{
--------------------------------------------------------------------------------
command("WorkingDirectory", function()
    vim.notify(vim.fn.getcwd(), 2, { title = " Current Working Directory" })
end)
-- }}}
--------------------------------------------------------------------------------

--------------
-- Difftool --
--------------
vim.api.nvim_create_user_command("DirDiff", function(opts)
    if vim.tbl_count(opts.fargs) ~= 2 then
        vim.notify("DirDiff requires exactly two directory arguments", vim.log.levels.ERROR)
        return
    end

    vim.cmd("tabnew")
    vim.cmd.packadd("nvim.difftool")
    require("difftool").open(opts.fargs[1], opts.fargs[2], {
        rename = {
            detect = false,
        },
        ignore = { ".git" },
    })
end, { complete = "dir", nargs = "*" })

--------------------------------------------------------------------------------
-- NOTE: Flutter project creation {{{
--------------------------------------------------------------------------------
local function create_flutter_project(opts)
    if vim.fn.executable("flutter") ~= 1 then
        vim.notify("Flutter binary not found in PATH", vim.log.levels.ERROR, { title = "Flutter" })
        return
    end

    local default_name = (opts.args and opts.args ~= "") and opts.args or nil
    local templates = {
        { id = "app", label = "app (Standard Flutter Application)" },
        { id = "skeleton", label = "skeleton (List view / Details view skeleton)" },
        { id = "package", label = "package (Shareable Flutter module/library)" },
        { id = "plugin", label = "plugin (Platform-specific native code plugin)" },
        { id = "module", label = "module (Flutter module for existing iOS/Android app)" },
    }

    vim.ui.select(templates, {
        prompt = "Select Flutter Template:",
        format_item = function(item)
            return item.label
        end,
    }, function(choice)
        if not choice then
            return
        end

        local template = choice.id

        local function prompt_project_name()
            vim.ui.input({
                prompt = "Project Name: ",
                default = default_name or "",
            }, function(name)
                if not name or name:match("^%s*$") then
                    vim.notify("Flutter project creation canceled (name required)", vim.log.levels.WARN, { title = "Flutter" })
                    return
                end

                name = vim.trim(name)
                -- Validate Dart identifier
                if not name:match("^[a-z][a-z0-9_]*$") then
                    vim.notify(
                        string.format("Invalid project name '%s'. Must be lowercase with underscores (e.g., my_flutter_app)", name),
                        vim.log.levels.ERROR,
                        { title = "Flutter" }
                    )
                    return
                end

                local default_dir = vim.fn.getcwd()
                vim.ui.input({
                    prompt = "Parent Directory: ",
                    default = default_dir,
                    completion = "dir",
                }, function(target_dir)
                    if not target_dir or target_dir:match("^%s*$") then
                        return
                    end

                    local expanded_dir = vim.fs.normalize(vim.fn.expand(vim.trim(target_dir)))
                    local project_path = vim.fs.normalize(expanded_dir .. "/" .. name)

                    vim.notify(
                        string.format("Creating '%s' using template '%s'...", name, template),
                        vim.log.levels.INFO,
                        { title = "Flutter" }
                    )

                    vim.system(
                        { "flutter", "create", "--template", template, "--project-name", name, project_path },
                        { text = true },
                        function(obj)
                            vim.schedule(function()
                                if obj.code == 0 then
                                    vim.notify(
                                        string.format("Flutter project '%s' created successfully!", name),
                                        vim.log.levels.INFO,
                                        { title = "Flutter" }
                                    )
                                    vim.cmd.cd(project_path)

                                    local main_file = project_path .. "/lib/main.dart"
                                    local pubspec_file = project_path .. "/pubspec.yaml"
                                    if vim.fn.filereadable(main_file) == 1 then
                                        vim.cmd.edit(vim.fn.fnameescape(main_file))
                                    elseif vim.fn.filereadable(pubspec_file) == 1 then
                                        vim.cmd.edit(vim.fn.fnameescape(pubspec_file))
                                    end
                                else
                                    vim.notify(
                                        string.format("Failed to create Flutter project:\n%s", obj.stderr or obj.stdout or ""),
                                        vim.log.levels.ERROR,
                                        { title = "Flutter" }
                                    )
                                end
                            end)
                        end
                    )
                end)
            end)
        end

        prompt_project_name()
    end)
end

command("FlutterCreate", create_flutter_project, {
    nargs = "?",
    desc = "Interactively create a new Flutter project from anywhere",
})
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
