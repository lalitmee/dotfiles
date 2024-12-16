local Util = require("lazy.core.util")

local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
        if vim.opt_local[option]:get() then
            Util.info("Enabled " .. option, { title = "Option" })
        else
            Util.warn("Disabled " .. option, { title = "Option" })
        end
    end
end

local enabled = true
function M.toggle_diagnostics()
    enabled = not enabled
    if enabled then
        vim.diagnostic.enable()
        Util.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        Util.warn("Disabled diagnostics", { title = "Diagnostics" })
    end
end

local wk = require("which-key")
wk.add({
    { "<leader>t", group = "toggle" },
    { "<leader>tj", ":TSJToggle<CR>", desc = "Treesj Toggle" },

    { "<leader>tg", group = "gitsigns" },
    { "<leader>tgb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Current Line Blame" },
    { "<leader>tgl", ":Gitsigns toggle_linehl<CR>", desc = "Toggle Line Highlight" },
    { "<leader>tgn", ":Gitsigns toggle_numhl<CR>", desc = "Toggle Number Highlight" },
    { "<leader>tgs", ":Gitsigns toggle_signs<CR>", desc = "Toggle Signs" },

    { "<leader>to", group = "scrolloff" },
    { "<leader>tot", ":set scrolloff=10<CR>", desc = "Scrolloff=10" },
    { "<leader>toh", ":set scrolloff=5<CR>", desc = "Scrolloff=5" },
    { "<leader>ton", ":set scrolloff=999<CR>", desc = "Scrolloff=999" },

    { "<leader>tt", ":TSPlaygroundToggle<CR>", desc = "Treesitter Playground" },
    { "<leader>tu", ":UndotreeToggle<CR>", desc = "Undotree" },
})

return M
