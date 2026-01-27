local command = lk.command
local fn = vim.fn

local float_dimensions_opts = { width = 200, height = 50 }

return {
    { --[[ toggleterm ]]
        "akinsho/toggleterm.nvim",
        keys = {
            [[<C-\>]],
            { "<leader>a/", ":Serpl<CR>", desc = "search-and-replace", silent = true },
            { "<leader>ab", ":Bottom<CR>", desc = "bottom", silent = true },
            { "<leader>ad", ":LazyDocker<CR>", desc = "lazydocker", silent = true },
            { "<leader>ag", ":LazyGit<CR>", desc = "lazygit", silent = true },
            { "<leader>ah", ":ToggleTerm direction=horizontal<CR>", desc = "horizontal-terminal", silent = true },
            { "<leader>ai", ":ChatGPTSh<CR>", desc = "chatgpt", silent = true },
            { "<leader>af", ":GhDash<CR>", desc = "gh-dash", silent = true },
            { "<leader>av", ":ToggleTerm direction=vertical<CR>", desc = "vertical-terminal", silent = true },
            { "<leader>gt", ":Tig<CR>", desc = "tig", silent = true },
        },
        cmd = { "ToggleTerm" },
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            autochdir = true,
            persist_mode = true,
            insert_mappings = false,
            start_in_insert = true,
            winbar = { enabled = lk.ui.winbar.enable },
            float_opts = vim.tbl_extend("keep", {
                border = lk.style.border.rounded,
                winblend = 3,
            }, float_dimensions_opts),
            shade_terminals = false,
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return math.floor(vim.api.nvim_get_option_value("columns", { scope = "local" }) * 0.5)
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

            local serpl = Terminal:new({
                cmd = "serpl",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local chatgpt = Terminal:new({
                cmd = "chatgpt -i",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local gh_dash = Terminal:new({
                cmd = "gh dash",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local bottom = Terminal:new({
                cmd = "btm",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            local tig = Terminal:new({
                cmd = "tig",
                hidden = true,
                direction = "float",
                on_open = float_handler,
                float_opts = float_dimensions_opts,
            })

            command("Serpl", function()
                serpl:toggle()
            end)
            command("LazyDocker", function()
                lazydocker:toggle()
            end)
            command("LazyGit", function()
                lazygit:toggle()
            end)
            command("Bottom", function()
                bottom:toggle()
            end)
            command("ChatGPTSh", function()
                chatgpt:toggle()
            end)
            command("GhDash", function()
                gh_dash:toggle()
            end)
            command("Tig", function()
                tig:toggle()
            end)
        end,
    },
}
