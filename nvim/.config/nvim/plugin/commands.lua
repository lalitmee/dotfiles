local command = lk.command
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: buffer commands {{{
----------------------------------------------------------------------
command("Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]], {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: telescope commands {{{
----------------------------------------------------------------------
command("TelescopeNotifyHistory", function()
    require("telescope").extensions.notify.notify()
end, {})

command("ReloadConfigTelescope", function()
    require("lk/utils/reload").reload()
end, {})

command("ReloadModule", function(args)
    require("lk/utils/reload").reload_module(args)
end, {})

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: config commands {{{
----------------------------------------------------------------------
command("ReloadConfig", function()
    require("lk/utils/reload").reload_config()
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: gh commands {{{
----------------------------------------------------------------------
command("BrowseRepo", function()
    vim.cmd([[silent !gh o]])
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: log variable {{{
----------------------------------------------------------------------
command("LogVariable", function()
    Log_var()
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: neovim utility commands {{{
----------------------------------------------------------------------
command("ToggleBackground", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, {})
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
    require("lk/utils/compiler").compile_and_run()
end, {})

-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: git jump {{{
--------------------------------------------------------------------------------
-- command("Jump", function(args)
--     vim.fn.system("git jump s" .. vim.fn.expand(args))
-- end, { nargs = "*", bar = true })

vim.cmd([[
command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))
]])

-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
