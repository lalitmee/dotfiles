local fn = vim.fn

return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
        open_mapping = [[<M-\>]],
        shade_filetypes = {},
        direction = "float",
        autochdir = true,
        persist_mode = true,
        insert_mappings = false,
        start_in_insert = true,
        winbar = { enabled = lk.ui.winbar.enable },
        float_opts = {
            border = lk.style.border.rounded,
            winblend = 3,
            width = 220,
            height = 45,
        },
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return math.floor(vim.o.columns * 0.4)
            end
        end,
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        local float_handler = function(term)
            if not lk.falsy(fn.mapcheck("jk", "t")) then
                vim.keymap.del("t", "jk", { buffer = term.bufnr })
                vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
            end
        end

        local Terminal = require("toggleterm.terminal").Terminal

        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            hidden = true,
            direction = "float",
            on_open = float_handler,
        })

        local lazydocker = Terminal:new({
            cmd = "lazydocker",
            hidden = true,
            direction = "float",
            on_open = float_handler,
        })

        local bottom = Terminal:new({
            cmd = "btm",
            hidden = true,
            direction = "float",
            on_open = float_handler,
            size = function()
                return math.floor(vim.o.columns * 0.95)
            end,
        })

        lk.command("LazyDocker", function()
            lazydocker:toggle()
        end, {})
        lk.command("LazyGit", function()
            lazygit:toggle()
        end, {})
        lk.command("Bottom", function()
            bottom:toggle()
        end, {})
    end,
}
