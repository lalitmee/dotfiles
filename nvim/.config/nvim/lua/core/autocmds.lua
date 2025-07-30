local tnoremap = lk.tnoremap
local augroup = lk.augroup

local opts = { silent = false, buffer = 0 }

-- Highlight on yank: briefly highlights yanked text for visual feedback.
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

-- Auto-source ginit.vim after saving it.
augroup("ginit_au", {
    {
        event = { "BufWritePost" },
        pattern = { "ginit.vim" },
        command = function()
            vim.cmd([[so %]])
        end,
    },
})

-- Set up 'q' to quit for special buffers and unlist them from buffer list.
-- For *.scriptease-verbose, 'q' closes the buffer.
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

-- Terminal keymaps and settings: custom mappings for terminal buffers,
-- disables signcolumn, and handles terminal mode transitions.
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

-- Reload kitty.conf and send signal to kitty terminal after saving.
augroup("kitty_au", {
    {
        event = { "BufWritePost" },
        pattern = { "kitty.conf" },
        command = function()
            vim.cmd([[:silent !kill -SIGUSR1 $(pgrep kitty)]])
        end,
    },
})

-- Filetype-specific options: disables 'o' in formatoptions for all buffers,
-- disables spell checking in checkhealth.
augroup("filetype_options_au", {
    {
        event = { "BufWinEnter" },
        pattern = { "*" },
        command = function()
            vim.opt_local.formatoptions:remove("o")
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

-- Automatically clear commandline messages after a delay.
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
local ignore_buftype = { "quickfix", "nofile", "help", "terminal", "toggleterm" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", "TelescopePrompt", "oil" }

local function restore_cursor_position()
    vim.schedule(function()
        -- Skip if in terminal mode
        if vim.fn.mode():match("t") then
            return
        end

        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype

        if vim.tbl_contains(ignore_buftype, buftype) or vim.tbl_contains(ignore_filetype, filetype) then
            return
        end

        -- Don't interfere if the cursor has already moved
        if vim.api.nvim_win_get_cursor(0)[1] > 1 then
            return
        end

        local last_line = vim.fn.line([['"]])
        local buffer_last_line = vim.fn.line("$")

        if last_line > 0 and last_line <= buffer_last_line then
            local win_last_line = vim.fn.line("w$")
            local win_first_line = vim.fn.line("w0")

            if win_last_line == buffer_last_line then
                vim.cmd.normal({ [[g`"]], bang = true })
            elseif buffer_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
                vim.cmd.normal({ [[g`"zz]], bang = true })
            else
                vim.cmd.normal({ [[G'"<c-e>]], bang = true })
            end
        end
    end)
end

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("nvim-lastplace", { clear = true }),
    callback = restore_cursor_position,
})
--------------------------------------------------------------------------------
-- }}}
--------------------------------------------------------------------------------

-- vim:fdm=marker
