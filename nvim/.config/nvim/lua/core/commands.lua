local command = lk.command
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: telescope commands {{{
----------------------------------------------------------------------
command("TelescopeNotifyHistory", function()
    require("telescope").extensions.notify.notify()
end)

command("ReloadConfigTelescope", function()
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

-- vim:foldmethod=marker
