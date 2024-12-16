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
    { "<leader>t", group = "+toggle" },
    {
        "<leader>ts",
        function()
            M.toggle("spell")
        end,
        desc = "toggle-spell",
    },
    {
        "<leader>tw",
        function()
            M.toggle("wrap")
        end,
        desc = "toggle-wrap",
    },
    {
        "<leader>tl",
        function()
            M.toggle("relativenumber", true)
            M.toggle("number")
        end,
        desc = "toggle-relative-number",
    },
    { "<leader>td", M.toggle_diagnostics, desc = "toggle-diagnostics" },
    {
        "<leader>tc",
        function()
            local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
            M.toggle("conceallevel", false, { 0, conceallevel })
        end,
        desc = "toggle-conceal-level",
    },
    { "<leader>tj", ":TSJToggle<CR>", desc = "treesj-toggle" },

    { "<leader>tg", group = "+git" },
    { "<leader>tgb", ":Gitsigns toggle_current_line_blame<CR>", desc = "toggle-blame" },
    { "<leader>tgl", ":Gitsigns toggle_linehl<CR>", desc = "toggle-linehl" },
    { "<leader>tgn", ":Gitsigns toggle_numhl<CR>", desc = "toggle-numhl" },
    { "<leader>tgs", ":Gitsigns toggle_signs<CR>", desc = "toggle-signs" },

    { "<leader>o", group = "+scrolloff" },
    { "<leader>tot", ":set scrolloff=10<CR>", desc = "scrolloff=10" },
    { "<leader>toh", ":set scrolloff=5<CR>", desc = "scrolloff=5" },
    { "<leader>ton", ":set scrolloff=999<CR>", desc = "scrolloff=999" },

    { "<leader>tt", ":TSPlaygroundToggle<CR>", desc = "playground" },
    { "<leader>tu", ":UndotreeToggle<CR>", desc = "undo-tree" },
})

return M
