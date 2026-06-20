return function()
    local gitsigns = require("gitsigns")
    local border = lk.style.border.rounded
    local hint_opts = {
        border = border,
        position = "bottom",
    }

    local hint = [[
 _J_: Next hunk   _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk   _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full
 _X_: Reset Hunk  _S_: Stage Buffer      _f_: Select Hunk    _r_: Refresh
 ^ ^              _U_: Reset Buffer      _/_: Show Base File
 ^
 ^ ^              _<Enter>_: Neogit              _q_: Exit
]]

    return {
        name = "gitsigns",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = hint_opts,
            on_enter = function()
                vim.cmd("mkview")
                vim.cmd("silent! %foldopen!")
                vim.bo.modifiable = true
                gitsigns.toggle_signs(true)
                gitsigns.toggle_linehl(true)
            end,
            on_exit = function()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("loadview")
                vim.api.nvim_win_set_cursor(0, cursor_pos)
                vim.cmd("normal zv")
                gitsigns.toggle_signs(true)
                gitsigns.toggle_linehl(false)
            end,
        },
        body = "<leader>gh",
        heads = {
            { "/", gitsigns.show, { exit = true, desc = "Show Base File" } }, -- show the base of the file
            { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
            {
                "B",
                function()
                    gitsigns.blame_line({ full = true })
                end,
                { desc = "Blame Show Full" },
            },
            {
                "J",
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gitsigns.next_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "Next Hunk" },
            },
            {
                "K",
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "Prev Hunk" },
            },
            { "S", gitsigns.stage_buffer, { desc = "Stage Buffer" } },
            { "U", gitsigns.reset_buffer, { desc = "Reset Buffer" } },
            { "X", gitsigns.reset_hunk, { desc = "Reset Hunk" } }, -- show the base of the file
            { "b", gitsigns.blame_line, { desc = "Blame" } },
            {
                "d",
                gitsigns.toggle_deleted,
                { nowait = true, desc = "Toggle Deleted" },
            },
            { "f", gitsigns.select_hunk, { desc = "Select Hunk" } },
            { "p", gitsigns.preview_hunk, { desc = "Preview Hunk" } },
            { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
            { "r", gitsigns.refresh, { desc = "Refresh" } },
            {
                "s",
                ":Gitsigns stage_hunk<CR>",
                { silent = true, desc = "Stage Hunk" },
            },
            { "u", gitsigns.undo_stage_hunk, { desc = "Undo Last Stage" } },
        },
    }
end
