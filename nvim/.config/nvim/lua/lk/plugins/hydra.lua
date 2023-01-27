local M = {
    "anuvyklack/hydra.nvim",
    event = { "VeryLazy" },
}

M.config = function()
    local Hydra = require("hydra")
    local border = lk.style.border.rounded

    local hint_opts = {
        position = "bottom",
        border = border,
        type = "window",
    }

    Hydra({
        name = "Folds",
        mode = "n",
        body = "<leader>z",
        color = "teal",
        config = {
            invoke_on_body = true,
            hint = hint_opts,
            -- on_enter = function()
            --     vim.cmd("BeaconOff")
            -- end,
            -- on_exit = function()
            --     vim.cmd("BeaconOn")
            -- end,
        },
        heads = {
            { "j", "zj", { desc = "next fold" } },
            { "k", "zk", { desc = "previous fold" } },
            { "l", require("fold-cycle").open_all, { desc = "open folds underneath" } },
            { "h", require("fold-cycle").close_all, { desc = "close folds underneath" } },
            { "<Esc>", nil, { exit = true, desc = "Quit" } },
        },
    })

    Hydra({
        name = "Side scroll",
        mode = "n",
        body = "z",
        config = {
            hint = hint_opts,
        },
        heads = {
            { "h", "5zh" },
            { "l", "5zl", { desc = "←/→" } },
            { "H", "zH" },
            { "L", "zL", { desc = "half screen ←/→" } },
        },
    })

    Hydra({
        name = "Window management",
        config = {
            invoke_on_body = false,
            hint = hint_opts,
        },
        mode = "n",
        body = "<C-w>",
        heads = {
            -- Split
            { "s", "<C-w>s", { desc = "split horizontally" } },
            { "v", "<C-w>v", { desc = "split vertically" } },
            { "q", "<C-w>c", { desc = "close window" } },
            -- Size
            { "j", "2<C-w>+", { desc = "increase height" } },
            { "k", "2<C-w>-", { desc = "decrease height" } },
            { "h", "5<C-w>>", { desc = "increase width" } },
            { "l", "5<C-w><", { desc = "decrease width" } },
            { "=", "<C-w>=", { desc = "equalize" } },
            --
            { "<Esc>", nil, { exit = true } },
        },
    })

    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

        -- Hydra({
        --     name = "Git Mode",
        --     hint = hint,
        --     config = {
        --         color = "pink",
        --         invoke_on_body = true,
        --         hint = hint_opts,
        --         on_enter = function()
        --             gitsigns.toggle_linehl(true)
        --             gitsigns.toggle_deleted(true)
        --         end,
        --         on_exit = function()
        --             gitsigns.toggle_linehl(false)
        --             gitsigns.toggle_deleted(false)
        --         end,
        --     },
        --     mode = { "n", "x" },
        --     body = "<localleader>g",
        --     heads = {
        --         {
        --             "J",
        --             function()
        --                 if vim.wo.diff then
        --                     return "]c"
        --                 end
        --                 vim.schedule(function()
        --                     gitsigns.next_hunk()
        --                 end)
        --                 return "<Ignore>"
        --             end,
        --             { expr = true },
        --         },
        --         {
        --             "K",
        --             function()
        --                 if vim.wo.diff then
        --                     return "[c"
        --                 end
        --                 vim.schedule(function()
        --                     gitsigns.prev_hunk()
        --                 end)
        --                 return "<Ignore>"
        --             end,
        --             { expr = true },
        --         },
        --         { "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
        --         { "u", gitsigns.undo_stage_hunk },
        --         { "S", gitsigns.stage_buffer },
        --         { "p", gitsigns.preview_hunk },
        --         { "d", gitsigns.toggle_deleted, { nowait = true } },
        --         { "b", gitsigns.blame_line },
        --         {
        --             "B",
        --             function()
        --                 gitsigns.blame_line({ full = true })
        --             end,
        --         },
        --         { "/", gitsigns.show, { exit = true } }, -- show the base of the file
        --         { "<Enter>", "<cmd>Neogit<CR>", { exit = true } },
        --         { "q", nil, { exit = true, nowait = true } },
        --     },
        -- })
        local bufnr = vim.api.nvim_get_current_buf()
        Hydra({
            name = "Git",
            hint = hint,
            config = {
                buffer = bufnr,
                color = "red",
                invoke_on_body = true,
                hint = {
                    border = "rounded",
                },
                on_key = function()
                    vim.wait(50)
                end,
                on_enter = function()
                    vim.cmd("mkview")
                    vim.cmd("silent! %foldopen!")
                    gitsigns.toggle_signs(true)
                    gitsigns.toggle_linehl(true)
                end,
                on_exit = function()
                    local cursor_pos = vim.api.nvim_win_get_cursor(0)
                    vim.cmd("loadview")
                    vim.api.nvim_win_set_cursor(0, cursor_pos)
                    vim.cmd("normal zv")
                    gitsigns.toggle_signs(false)
                    gitsigns.toggle_linehl(false)
                    gitsigns.toggle_deleted(false)
                end,
            },
            mode = { "n", "x" },
            body = "<localleader>g",
            heads = {
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
                    { expr = true, desc = "next hunk" },
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
                    { expr = true, desc = "prev hunk" },
                },
                {
                    "s",
                    function()
                        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
                        if mode == "V" then -- visual-line mode
                            local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
                            vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
                            vim.cmd("'<,'>Gitsigns stage_hunk")
                        else
                            vim.cmd("Gitsigns stage_hunk")
                        end
                    end,
                    { desc = "stage hunk" },
                },
                { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
                { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
                { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
                { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
                { "b", gitsigns.blame_line, { desc = "blame" } },
                {
                    "B",
                    function()
                        gitsigns.blame_line({ full = true })
                    end,
                    { desc = "blame show full" },
                },
                { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
                {
                    "<Enter>",
                    function()
                        vim.cmd("Neogit")
                    end,
                    { exit = true, desc = "Neogit" },
                },
                { "q", nil, { exit = true, nowait = true, desc = "exit" } },
            },
        })
    end

    local function run(method, args)
        return function()
            local dap = require("dap")
            if dap[method] then
                dap[method](args)
            end
        end
    end

    local hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             ^ ^                 ^ ^
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]

    Hydra({
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = hint_opts,
        },
        name = "dap",
        mode = { "n", "x" },
        body = "<leader>dh",
        heads = {
            { "n", run("step_over"), { silent = true } },
            { "i", run("step_into"), { silent = true } },
            { "o", run("step_out"), { silent = true } },
            { "c", run("run_to_cursor"), { silent = true } },
            { "s", run("continue"), { silent = true } },
            { "x", run("disconnect", { terminateDebuggee = false }), { exit = true, silent = true } },
            { "X", run("close"), { silent = true } },
            {
                "C",
                ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>",
                { silent = true },
            },
            { "b", run("toggle_breakpoint"), { silent = true } },
            { "K", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
            { "q", nil, { exit = true, nowait = true } },
        },
    })
end

return M
