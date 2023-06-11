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
wk.register({
    ["u"] = {
        ["name"] = "+toggle",
        ["s"] = {
            function()
                M.toggle("spell")
            end,
            "toggle-spell",
        },
        ["w"] = {
            function()
                M.toggle("wrap")
            end,
            "toggle-wrap",
        },
        ["l"] = {
            function()
                M.toggle("relativenumber", true)
                M.toggle("number")
            end,
            "toggle-relativenumber",
        },
        ["d"] = { M.toggle_diagnostics, "toggle-diagnostics" },
        ["c"] = {
            function()
                local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
                M.toggle("conceallevel", false, { 0, conceallevel })
            end,
            "toggle-conceallevel",
        },
        ["j"] = { ":TSJToggle<CR>", "treesj-toggle" },
        ["g"] = {
            ["name"] = "+git",
            ["b"] = {
                ":Gitsigns toggle_current_line_blame<CR>",
                "toggle-blame",
            },
            ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
            ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
            ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
        },
        ["m"] = { ":Telescope macros<CR>", "neo-composer-macros" },
        ["o"] = {
            ["name"] = "+scrolloff",
            ["t"] = { ":set scrolloff=10<CR>", "scrolloff=10" },
            ["h"] = { ":set scrolloff=5<CR>", "scrolloff=5" },
            ["n"] = { ":set scrolloff=999<CR>", "scrolloff=999" },
        },
        ["t"] = { ":TSPlaygroundToggle<CR>", "playground" },
        ["u"] = { ":UndotreeToggle<CR>", "undo-tree" },
    },
}, { mode = "n", prefix = "<leader>" })

return M
