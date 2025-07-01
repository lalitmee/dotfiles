local tnoremap = lk.tnoremap
local augroup = lk.augroup

local opts = { silent = false, buffer = 0 }

augroup("yank_au", {
    {
        -- don't execute silently in case of errors
        event = { "TextYankPost" },
        command = function()
            vim.highlight.on_yank({
                timeout = 40,
                on_visual = false,
                higroup = "IncSearch",
            })
        end,
    },
})

augroup("ginit_au", {
    {
        event = { "BufWritePost" },
        pattern = { "ginit.vim" },
        command = function()
            vim.cmd([[so %]])
        end,
    },
})

augroup("insert_au", {
    {
        event = { "WinLeave" },
        pattern = { "TelescopePrompt", "DressingInput" },
        command = function()
            if vim.fn.mode() == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    },
    {
        event = { "WinEnter" },
        pattern = { "*" },
        command = function()
            if vim.fn.mode() == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    },
})

augroup("quit_q_au", {
    {
        event = { "FileType" },
        pattern = {
            "OverseerForm",
            "OverseerList",
            "checkhealth",
            "floggraph",
            "fugitive",
            "git",
            "gitcommit",
            "help",
            "log",
            "lspinfo",
            "man",
            "man",
            "neotest-output",
            "neotest-summary",
            "oil",
            "qf",
            "query",
            "redir_output",
            "spectre_panel",
            "startuptime",
            "toggleterm",
            "tsplayground",
            "vim",
        },
        command = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>q<cr>", {
                buffer = event.buf,
                silent = true,
            })
        end,
    },
    {
        event = { "BufEnter" },
        pattern = { "*.scriptease-verbose" },
        command = function(args)
            vim.keymap.set("n", "q", "<cmd>bd<cr>", {
                buffer = args.buf,
                silent = true,
            })
        end,
    },
})

augroup("terminal_au", {
    {
        event = { "TermOpen" },
        pattern = { "term://*" },
        command = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "BufTerm" then
                tnoremap("<esc>", [[<C-\><C-n>]], opts)
                tnoremap("jk", [[<C-\><C-n>]], opts)
                tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
                tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
                tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
                tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
                tnoremap("<BS>", [[<BS>]], opts)
            end
            --  NOTE: this was putting cursor after overseer commands in insert
            --  mode
            -- vim.cmd([[startinsert]])
            vim.opt_local.signcolumn = "no"
        end,
    },
    --  NOTE: this was putting cursor after overseer commands in insert
    --  mode
    -- {
    --     event = { "TermEnter" },
    --     pattern = { "term://*" },
    --     command = function()
    --         vim.cmd([[startinsert]])
    --     end,
    -- },
    {
        event = { "TermLeave", "TermClose" },
        pattern = { "term://*" },
        command = function()
            vim.cmd([[stopinsert]])
        end,
    },
    {
        event = { "FileType" },
        pattern = { "fzf" },
        command = function()
            vim.cmd([[tunmap <buffer> <ESC>]])
            tnoremap("<C-j>", "<Down>", opts)
            tnoremap("<C-k>", "<Up>", opts)
        end,
    },
})

augroup("kitty_au", {
    {
        event = { "BufWritePost" },
        pattern = { "kitty.conf" },
        command = function()
            vim.cmd([[:silent !kill -SIGUSR1 $(pgrep kitty)]])
        end,
    },
})

augroup("filetype_options_au", {
    {
        event = { "BufWinEnter" },
        pattern = { "*" },
        command = function()
            vim.cmd("set formatoptions-=o")
        end,
    },
    {
        event = { "FileType" },
        pattern = { "checkhealth" },
        command = function()
            vim.o.spell = false
        end,
    },
})

--------------------------------------------------------------------------------
--  NOTE: clear commandline {{{
--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
--------------------------------------------------------------------------------

---@return function
local function clear_commandline()
    --- Track the timer object and stop any previous timers before setting
    --- a new one so that each change waits for 10secs and that 10secs is
    --- deferred each time
    local timer
    return function()
        if timer then
            timer:stop()
        end
        timer = vim.defer_fn(function()
            if vim.fn.mode() == "n" then
                vim.cmd([[echon '']])
            end
        end, 10000)
    end
end

augroup("commandline_au", {
    {
        event = { "CmdlineLeave", "CmdlineChanged" },
        pattern = { ":" },
        command = clear_commandline(),
    },
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: cursorline {{{
--------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup("cursor_line_au", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: lastplace {{{
-- adapted from https://github.com/ethanholz/nvim-lastplace/blob/main/lua/nvim-lastplace/init.lua
--------------------------------------------------------------------------------
local ignore_buftype = { "quickfix", "nofile", "help" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

local function run()
    if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
        return
    end

    if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
        -- reset cursor to first line
        vim.cmd.normal({ "gg", bang = true })
        return
    end

    -- If a line has already been specified on the command line, we are done
    --   nvim file +num
    if vim.fn.line(".") > 1 then
        return
    end

    local last_line = vim.fn.line([['"]])
    local buff_last_line = vim.fn.line("$")

    -- If the last line is set and the less than the last line in the buffer
    if last_line > 0 and last_line <= buff_last_line then
        local win_last_line = vim.fn.line("w$")
        local win_first_line = vim.fn.line("w0")
        -- Check if the last line of the buffer is the same as the win
        if win_last_line == buff_last_line then
            -- Set line to last line edited
            vim.cmd.normal({ [[g`"]], bang = true })
        -- Try to center
        elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
            vim.cmd.normal({ [[g`"zz]], bang = true })
        else
            vim.cmd.normal({ [[G'"<c-e>]], bang = true })
        end
    end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    group = vim.api.nvim_create_augroup("nvim-lastplace", {}),
    callback = run,
})
-- }}}
--------------------------------------------------------------------------------
