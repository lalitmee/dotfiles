local M = {}

local code_action = vim.lsp.buf.code_action

--- Applies the code action with the given prefix
--- Example: `actions.apply("Wrap in Some")`
--- @param prefix string
M.apply = function(prefix)
    code_action({
        apply = true,
        filter = function(action)
            local title = vim.fn.trim(action.title)
            return vim.startswith(title, prefix)
        end,
    })
end

--- Applies quickfix and can be filtered by providing the preferred action depending on the diagnostic
--- Example: `
---   local options = {
---     ["E0425"] = "Import"
---     ["unused-local"] = "Disable diagnostics on this line"
---   }
---   actions.quickfix(options)
--- `
---@param options table<string, string> | nil
M.quickfix = function(options)
    code_action({
        apply = true,
        context = {
            only = { "quickfix" },
        },
        filter = function(action)
            local found = false
            local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
            for code, fix_message in pairs(options or {}) do
                for _, diagnostic in pairs(diagnostics) do
                    if diagnostic.code == code then
                        found = true
                        local title = vim.fn.trim(action.title)
                        if vim.startswith(title, fix_message) then
                            return true
                        end
                    end
                end
            end
            return not found
        end,
    })
end

--- Tries to fix the next diagnostic
M.quickfix_next = function(options)
    vim.diagnostic.goto_next()
    M.quickfix(options)
end

--- Tries to fix the previous diagnostic
M.quickfix_prev = function(options)
    vim.diagnostic.get_prev()
    M.quickfix(options)
end

--- Quick refactor
M.refactor = function()
    code_action({
        apply = true,
        context = {
            only = { "refactor" },
        },
    })
end

--- Same concept as above
M.source = function()
    code_action({
        apply = true,
        context = {
            only = { "source" },
        },
    })
end

return M
