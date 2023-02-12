local M = { -- treat terminal windows as buffers so that :bd! can work
    "boltlessengineer/bufterm.nvim",
    event = { "VeryLazy" },
}

M.enabled = false

M.config = function()
    require("bufterm").setup()

    -- this will add Terminal to the list (not starting job yet)
    local term = require("bufterm.terminal")
    local Terminal = term.Terminal
    local ui = require("bufterm.ui")

    local lazygit = Terminal:new({
        cmd = "lazygit",
        buflisted = false,
        termlisted = false, -- set this option to false if you treat this terminal as single independent terminal
    })
    vim.keymap.set("n", "<leader>tgl", function()
        -- spawn terminal (terminal won't be spawned if self.jobid is valid)
        lazygit:spawn()
        -- open floating window
        ui.toggle_float(lazygit.bufnr)
    end, {
        desc = "Open lazygit in floating window",
    })
end

return M
