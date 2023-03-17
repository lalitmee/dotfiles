local M = {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
        size = 30,
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
        direction = "split",
        float_opts = { border = "curved" },
    },
}

M.config = function(_, opts)
    require("toggleterm").setup(opts)

    local float_handler = function(term)
        vim.wo.sidescrolloff = 0
        if not lk.empty(vim.fn.mapcheck("jk", "t")) then
            vim.keymap.del("t", "jk", { buffer = term.bufnr })
            vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
        end
    end

    local float_opts = {
        border = "rounded",
        height = vim.api.nvim_win_get_height(0) + 100,
        width = vim.api.nvim_win_get_width(0) + 100,
    }

    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        on_open = float_handler,
        float_opts = float_opts,
    })

    local btop = Terminal:new({
        cmd = "btop",
        hidden = true,
        direction = "float",
        on_open = float_handler,
        highlights = {
            FloatBorder = { guibg = "Black", guifg = "DarkGray" },
            NormalFloat = { guibg = "Black" },
        },
        float_opts = float_opts,
    })

    local gh_dash = Terminal:new({
        cmd = "gh dash",
        hidden = true,
        direction = "float",
        on_open = float_handler,
        float_opts = float_opts,
    })

    lk.command("GhDashToggle", function()
        gh_dash:toggle()
    end, {})
    lk.command("Lazygit", function()
        lazygit:toggle()
    end, {})
    lk.command("Btop", function()
        btop:toggle()
    end, {})
end

return M
