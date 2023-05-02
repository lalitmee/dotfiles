local M = {
    "Sonicfury/scretch.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = {
        "Scretch",
        "ScretchNamed",
        "ScretchLast",
        "ScretchSearch",
        "ScretchGrep",
        "ScretchExplore",
    },
}

M.config = function()
    local scretch = require("scretch")
    scretch.setup()

    lk.command("Scretch", function()
        scretch.new()
    end, {})
    lk.command("ScretchNamed", function()
        scretch.new_named()
    end, {})
    lk.command("ScretchLast", function()
        scretch.last()
    end, {})
    lk.command("ScretchSearch", function()
        scretch.search()
    end, {})
    lk.command("ScretchGrep", function()
        scretch.grep()
    end, {})
    lk.command("ScretchExplore", function()
        scretch.explore()
    end, {})
end

return M
