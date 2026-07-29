local general_keys = require("plugins.snacks.keys_general")
local picker_keys = require("plugins.snacks.picker.keys")

local keys = {}
for _, k in ipairs(general_keys) do
    table.insert(keys, k)
end
for _, k in ipairs(picker_keys) do
    table.insert(keys, k)
end

require("plugins.snacks.picker.sources")

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = keys,
    opts = require("plugins.snacks.opts"),
    init = function()
        require("plugins.snacks.setup")
    end,
}