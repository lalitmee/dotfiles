local M = {
    "ckolkey/ts-node-action",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter" },
}

M.config = function()
    local helpers = require("ts-node-action.helpers")

    require("ts-node-action").setup({
        javascript = {
            ["update_expression"] = function(node)
                local default_increment_operators = {
                    ["++"] = "+=1",
                    ["+=1"] = "++",
                    ["--"] = "-=1",
                    ["-=1"] = "--",
                }
                local replacement = {}
                for child, _ in node:iter_children() do
                    local text = helpers.node_text(child)
                    if default_increment_operators[text] then
                        table.insert(replacement, default_increment_operators[text])
                    else
                        table.insert(replacement, text)
                    end
                end
                return table.concat(replacement, " ")
            end,
            ["augmented_assignment_expression"] = function(node)
                local default_increment_operators = {
                    ["+="] = "++",
                    ["-="] = "--",
                }
                local replacement = {}
                for child, _ in node:iter_children() do
                    local text = helpers.node_text(child)
                    if default_increment_operators[text] then
                        table.insert(replacement, default_increment_operators[text])
                    else
                        table.insert(replacement, text)
                    end
                end
                return table.concat(replacement, " ")
            end,
        },
    })
end

return M
