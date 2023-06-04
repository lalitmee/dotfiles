local border = lk.style.border.rounded
local hint_opts = {
    border = border,
    position = "bottom",
}

local function gitsigns_menu()
    local gitsigns = require("gitsigns")

    local hint = [[
 _J_: Next hunk   _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk   _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full
 _X_: Reset Hunk  _S_: Stage Buffer      _f_: Select Hunk    _r_: Refresh
 ^ ^              _U_: Reset Buffer      _/_: Show Base File
 ^
 ^ ^              _<Enter>_: Neogit              _q_: Exit
]]

    return {
        name = "Git",
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

local function dap_menu()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_widgets = require("dap.ui.widgets")

    local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _i_: Step Into
 _h_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

    return {
        name = "Debug",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "middle-right",
            },
        },
        mode = "n",
        body = "<A-d>",
        heads = {
            {
                "C",
                function()
                    dap.set_breakpoint(vim.fn.input("[Condition] > "))
                end,
                desc = "Conditional Breakpoint",
            },
            {
                "E",
                function()
                    dapui.eval(vim.fn.input("[Expression] > "))
                end,
                desc = "Evaluate Input",
            },
            {
                "R",
                function()
                    dap.run_to_cursor()
                end,
                desc = "Run to Cursor",
            },
            {
                "S",
                function()
                    dap_widgets.scopes()
                end,
                desc = "Scopes",
            },
            {
                "U",
                function()
                    dapui.toggle()
                end,
                desc = "Toggle UI",
            },
            {
                "X",
                function()
                    dap.close()
                end,
                desc = "Quit",
            },
            {
                "b",
                function()
                    dap.step_back()
                end,
                desc = "Step Back",
            },
            {
                "c",
                function()
                    dap.continue()
                end,
                desc = "Continue",
            },
            {
                "d",
                function()
                    dap.disconnect()
                end,
                desc = "Disconnect",
            },
            {
                "e",
                function()
                    dapui.eval()
                end,
                mode = { "n", "v" },
                desc = "Evaluate",
            },
            {
                "g",
                function()
                    dap.session()
                end,
                desc = "Get Session",
            },
            {
                "h",
                function()
                    dap_widgets.hover()
                end,
                desc = "Hover Variables",
            },
            {
                "i",
                function()
                    dap.step_into()
                end,
                desc = "Step Into",
            },
            {
                "o",
                function()
                    dap.step_over()
                end,
                desc = "Step Over",
            },
            {
                "p",
                function()
                    dap.pause.toggle()
                end,
                desc = "Pause",
            },
            {
                "r",
                function()
                    dap.repl.toggle()
                end,
                desc = "Toggle REPL",
            },
            {
                "s",
                function()
                    dap.continue()
                end,
                desc = "Start",
            },
            {
                "t",
                function()
                    dap.toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "u",
                function()
                    dap.step_out()
                end,
                desc = "Step Out",
            },
            {
                "x",
                function()
                    dap.terminate()
                end,
                desc = "Terminate",
            },
            { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
        },
    }
end

local function lsp_menu()
    return {
        name = "LSP Mode",
        mode = { "n" },
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                type = "window",
                position = "bottom-right",
                border = "rounded",
                show_name = true,
            },
        },
        hint = [[
    LSP
^
Common Actions
- _h_: Show Hover Doc
- _f_: Format Buffer
- _a_: Code Actions
- _s_: Jump to Definition
- _d_: Show Diagnostics
- _w_: Show Workspace Diagnostics
^
Help
- _e_: Show Declarations
- _D_: Show Type Definition
- _j_: Show Sig Help
- _o_: Show Implementation
- _r_: Show References
^
_;_/_q_/_<Esc>_: Exit Hydra
]],
        body = "<A-l>",
        heads = {
            {
                "s",
                vim.lsp.buf.definition,
                { desc = "Jump to Definition", silent = true },
            },
            {
                "h",
                vim.lsp.buf.hover,
                { desc = "Show Hover Doc", silent = true },
            },
            {
                "o",
                vim.lsp.buf.implementation,
                { desc = "Show Implementations", silent = true },
            },
            {
                "j",
                vim.lsp.buf.signature_help,
                { desc = "Show Sig Help", silent = true },
            },
            {
                "r",
                vim.lsp.buf.references,
                { desc = "Show References", silent = true },
            },
            {
                "f",
                function()
                    vim.lsp.buf.format({ async = true })
                end,
                { desc = "Format Buffer", silent = true },
            },
            {
                "a",
                vim.lsp.buf.code_action,
                { desc = "Show Code Actions", silent = true },
            },
            {
                "d",
                vim.diagnostic.open_float,
                { desc = "Show Diagnostics", silent = true },
            },
            {
                "w",
                vim.diagnostic.show,
                { desc = "Show Workspace Diagnostics", silent = true },
            },
            {
                "D",
                vim.lsp.buf.definition,
                { desc = "Show Type Definition", silent = true },
            },
            {
                "e",
                vim.lsp.buf.declaration,
                { desc = "Show Declaration", silent = true },
            },
            { ";", nil, { desc = "quit", exit = true, nowait = true } },
            { "q", nil, { desc = "quit", exit = true, nowait = true } },
            { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
        },
    }
end

local function quick_menu()
    local cmd = require("hydra.keymap-util").cmd
    return {
        name = "Quick Menu",
        mode = { "n" },
        hint = [[
                                        Quick Menu
^
_f_: Show Terminal (float)      _v_: Open Terminal (vertical)       _h_: Open Terminal (horizontal)

_q_: Open Quickfix              _l_: Open Loaction List        ^ ^
^
^ ^                                 _<Esc>_: Exit Hydra
    ]],
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                type = "window",
                position = "bottom",
                border = "rounded",
                show_name = true,
            },
        },
        body = "<A-M>",
        heads = {
            {
                "t",
                cmd("Telescope help_tags"),
                { desc = "Open Help Tags", silent = true },
            },
            {
                "k",
                require("telescope.builtin").keymaps,
                { desc = "Open Neovim Keymaps", silent = true },
            },
            {
                "c",
                cmd("Telescope commands"),
                { desc = "Open Available Telescope Commands", silent = true },
            },
            {
                "m",
                cmd("Telescope man_pages"),
                { desc = "Opens Man Pages", silent = true },
            },

            {
                "q",
                cmd("Telescope quickfix"),
                { desc = "Opens Quickfix", silent = true },
            },
            {
                "l",
                cmd("Telescope loclist"),
                { desc = "Opens Location List", silent = true },
            },

            {
                "f",
                cmd("ToggleTerm direction=float"),
                { desc = "Floating Terminal", silent = true },
            },
            {
                "v",
                cmd("ToggleTerm direction=vertical"),
                { desc = "Vertical Terminal", silent = true },
            },
            {
                "h",
                cmd("ToggleTerm direction=horizontal"),
                { desc = "Horizontal Terminal", silent = true },
            },
            { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
        },
    }
end

local function folds_menu()
    return {
        name = "Folds",
        mode = "n",
        hint = [[
Folds
------

_j_: Next Fold
_k_: Previous Fold
_l_: Open All Folds
_h_: Close All Folds

_q_/_<Esc>_: Exit Hydra

]],
        body = "<A-f>",
        color = "pink",
        config = {
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "middle-right",
            },
        },
        heads = {
            { "j", "zj", { desc = "next fold" } },
            { "k", "zk", { desc = "previous fold" } },
            { "l", "zr", { desc = "open folds underneath" } },
            { "h", "zm", { desc = "close folds underneath" } },
            { "q", nil, { desc = "quit", exit = true, nowait = true } },
            { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
        },
    }
end

local function window_menu()
    return {
        name = "Window management",
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "bottom",
            },
        },
        mode = "n",
        hint = [[
                                      Windows

layout:      _2_: Two Columns
move:        _a_: Far Left         _;_: Far Right        _i_: Far Up        _n_: Far Down
             _t_: Split to Tab
split:       _s_: Horizontally     _v_: Vertically
resize:      _J_: Down             _K_: Up               _H_: Left            _L_: Right
             _e_: Auto Resize      _=_: Equalize         _m_: Maximize        _o_: Only
swap:        _r_: Swap             _u_: Next Window
height:      _j_: Increase         _k_: Decrease
width:       _h_: Increase         _l_: Decrease
^ ^          _d_: Close Window     _<Esc>_: Exit Hydra
    ]],
        body = "<A-w>",
        heads = {
            {
                "2",
                "<C-W>v",
                { desc = "layout-double-columns", nowait = true },
            },
            {
                ";",
                "<C-W>L",
                { desc = "move-window-far-right", nowait = true },
            },
            { "=", "<C-W>=", { desc = "balance-windows", nowait = true } },
            { "a", "<C-W>H", { desc = "move-window-far-left", nowait = true } },
            { "d", "<C-W>c", { desc = "delete-window", nowait = true } },
            { "e", ":AutoResize<CR>", { desc = "auto-resize", nowait = true } },
            { "H", "<C-W>10<", { desc = "expand-window-left", nowait = true } },
            { "i", "<C-W>K", { desc = "move-window-far-top", nowait = true } },
            {
                "J",
                ":resize +10<CR>",
                { desc = "expand-window-below", nowait = true },
            },
            {
                "K",
                ":resize  10<CR>",
                { desc = "expand-window-up", nowait = true },
            },
            {
                "L",
                "<C-W>10>",
                { desc = "expand-window-right", nowait = true },
            },
            {
                "m",
                ":NeoZoomToggle<CR>",
                { desc = "maximize-window", nowait = true },
            },
            { "n", "<C-W>J", { desc = "move-window-far-down", nowait = true } },
            {
                "o",
                ":only<CR>",
                { desc = "close-other-windows-except-this", nowait = true },
            },
            { "r", "<C-W>r", { desc = "window-swap", nowait = true } },
            { "t", "<C-W>T", { desc = "move-split-to-tab", nowait = true } },
            { "u", "<C-W>x", { desc = "swap-window-next", nowait = true } },
            { "v", "<C-W>v", { desc = "split-window-right", nowait = true } },
            -- Split
            { "s", "<C-w>s", { desc = "split horizontally", nowait = true } },
            { "v", "<C-w>v", { desc = "split vertically", nowait = true } },
            -- Size
            { "j", "2<C-w>+", { desc = "increase height", nowait = true } },
            { "k", "2<C-w>-", { desc = "decrease height", nowait = true } },
            { "h", "5<C-w>>", { desc = "increase width", nowait = true } },
            { "l", "5<C-w><", { desc = "decrease width", nowait = true } },
            { "=", "<C-w>=", { desc = "equalize", nowait = true } },
            --
            { "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
        },
    }
end

local M = {
    "anuvyklack/hydra.nvim",
    event = { "VeryLazy" },
    init = function()
        local hydra = require("hydra")

        hydra(dap_menu())
        hydra(folds_menu())
        hydra(gitsigns_menu())
        hydra(lsp_menu())
        hydra(quick_menu())
        hydra(window_menu())
    end,
}

return M
