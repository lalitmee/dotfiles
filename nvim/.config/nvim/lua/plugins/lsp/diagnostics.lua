local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local command = lk.command

vim.diagnostic.config({
    underline = true,
    virtual_text = {
        severity = nil,
        source = "if_many",
        -- format = function(d)
        --     return d.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        -- end,
        format = nil,
    },
    -- virtual_text = false,
    signs = true,

    float = {
        -- show_header = true,
        header = "",
        border = "rounded",
        source = "if_many",
        format = function(diag)
            if not diag.code and not diag.user_data then
                return diag.message
            end

            local t = vim.deepcopy(diag)
            local code = diag.code
            if not code then
                if not diag.user_data.lsp then
                    return diag.message
                end

                code = diag.user_data.lsp.code
            end
            if code then
                t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
            end
            return t.message
        end,
    },
    severity_sort = true,
    update_in_insert = false,
})

-- NOTE: show only one sign and diagnostic per line
local ns = api.nvim_create_namespace("severe-diagnostics")

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`
local function max_diagnostic(callback)
    return function(_, bufnr, _, opts)
        -- Get all diagnostics from the whole buffer rather than just the
        -- diagnostics passed to the handler
        local diagnostics = vim.diagnostic.get(bufnr)
        -- Find the "worst" diagnostic per line
        local max_severity_per_line = {}
        for _, d in pairs(diagnostics) do
            local m = max_severity_per_line[d.lnum]
            if not m or d.severity < m.severity then
                max_severity_per_line[d.lnum] = d
            end
        end
        -- Pass the filtered diagnostics (with our custom namespace) to
        -- the original handler
        callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
    end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
    show = max_diagnostic(signs_handler.show),
    hide = function(_, bufnr)
        signs_handler.hide(ns, bufnr)
    end,
})

local virt_text_handler = diagnostic.handlers.virtual_text
diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
    show = max_diagnostic(virt_text_handler.show),
    hide = function(_, bufnr)
        virt_text_handler.hide(ns, bufnr)
    end,
})

-- NOTE: populate qf list with diagnostics and update too
---@param buf integer
---@return boolean
local function is_buffer_valid(buf)
    return buf and api.nvim_buf_is_loaded(buf) and api.nvim_buf_is_valid(buf)
end

do
    ---@type integer?
    local id
    local TITLE = "DIAGNOSTICS"
    -- A helper function to auto-update the quickfix list when new diagnostics come
    -- in and close it once everything is resolved. This functionality only runs whilst
    -- the list is open.
    -- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
    local function smart_quickfix_diagnostics()
        if not is_buffer_valid(api.nvim_get_current_buf()) then
            return
        end

        diagnostic.setqflist({ open = true, title = TITLE })

        if not lk.is_vim_list_open() and id then
            api.nvim_del_autocmd(id)
            id = nil
        end

        id = id
            or api.nvim_create_autocmd("DiagnosticChanged", {
                callback = function()
                    -- skip QF lists that we did not populate
                    if not lk.is_vim_list_open() or fn.getqflist({ title = 0 }).title ~= TITLE then
                        return
                    end
                    diagnostic.setqflist({ open = true, title = TITLE })
                    if #fn.getqflist() == 0 then
                        lk.toggle_qf_list()
                    end
                end,
            })
    end
    command("LspDiagnostics", smart_quickfix_diagnostics)
end
