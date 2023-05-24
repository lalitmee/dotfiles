local lsp = vim.lsp
local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic

--------------------------------------------------------------------------------
-- NOTE: go to definition {{{
-- Jump directly to the first available definition every time.
--------------------------------------------------------------------------------
lsp.handlers["textDocument/definition"] = function(_, result)
    if not result or vim.tbl_isempty(result) then
        vim.notify(
            "[LSP] Could not find definition",
            2,
            { title = "[LSP] definition" }
        )
        return
    end

    if vim.tbl_islist(result) then
        lsp.util.jump_to_location(result[1], "utf-8", true)
    else
        lsp.util.jump_to_location(result, "utf-8", true)
    end
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: diagnostics {{{
--------------------------------------------------------------------------------
vim.diagnostic.config({
    underline = true,
    virtual_text = {
        severity = nil,
        source = "if_many",
        format = function(d)
            return d.message
                :gsub("\n", " ")
                :gsub("\t", " ")
                :gsub("%s+", " ")
                :gsub("^%s+", "")
        end,
    },
    -- virtual_text = false,
    signs = true,

    float = {
        show_header = true,
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
                t.message =
                    string.format("%s [%s]", t.message, code):gsub("1. ", "")
            end
            return t.message
        end,
    },
    severity_sort = true,
    update_in_insert = false,
})

--------------------------------------------------------------------------------
--  NOTE: show only one sign and diagnostic per line {{{
--------------------------------------------------------------------------------
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
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: populate qf list with diagnostics and update too {{{
--------------------------------------------------------------------------------
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

        diagnostic.setqflist({ open = false, title = TITLE })
        lk.toggle_qf_list()

        if not lk.is_vim_list_open() and id then
            api.nvim_del_autocmd(id)
            id = nil
        end

        id = id
            or api.nvim_create_autocmd("DiagnosticChanged", {
                callback = function()
                    -- skip QF lists that we did not populate
                    if
                        not lk.is_vim_list_open()
                        or fn.getqflist({ title = 0 }).title ~= TITLE
                    then
                        return
                    end
                    diagnostic.setqflist({ open = false, title = TITLE })
                    if #fn.getqflist() == 0 then
                        lk.toggle_qf_list()
                    end
                end,
            })
    end
    lk.command("LspDiagnostics", smart_quickfix_diagnostics, {})
end
-- }}}
--------------------------------------------------------------------------------
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: hover {{{
--------------------------------------------------------------------------------
local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers["textDocument/hover"] = lsp.with(
    lsp.handlers.hover,
    { border = "rounded", max_width = max_width, max_height = max_height }
)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: signature help {{{
--------------------------------------------------------------------------------
lsp.handlers["textDocument/signatureHelp"] =
    lsp.with(lsp.handlers.signature_help, {
        border = "rounded",
        max_width = max_width,
        max_height = max_height,
    })
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: show message handler {{{
--------------------------------------------------------------------------------
lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    vim.notify(result.message, lvl, {
        title = "LSP | " .. client.name,
        timeout = 8000,
        keep = function()
            return lvl == "ERROR" or lvl == "WARN"
        end,
    })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: implementation handler {{{
--------------------------------------------------------------------------------
local implementation = function()
    local params = lsp.util.make_position_params(nil, "utf-8")

    lsp.buf_request(
        0,
        "textDocument/implementation",
        params,
        function(err, result, ctx, config)
            local bufnr = ctx.bufnr
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

            -- In go code, I do not like to see any mocks for impls
            if ft == "go" then
                local new_result = vim.tbl_filter(function(v)
                    return not string.find(v.uri, "mock_")
                end, result)

                if #new_result > 0 then
                    result = new_result
                end
            end

            lsp.handlers["textDocument/implementation"](
                err,
                result,
                ctx,
                config
            )
            vim.cmd([[normal! zz]])
        end
    )
end
lsp.handlers["textDocument/implementation"] = implementation
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: codelens handler {{{
--------------------------------------------------------------------------------
-- lsp.codelens.display = require('gl.codelens').display
-- }}}
--------------------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- -- NOTE: rename handler {{{
-- ----------------------------------------------------------------------
-- local function qf_rename()
--     local position_params = vim.lsp.util.make_position_params(nil, "utf-8")
--     position_params.oldName = vim.fn.expand("<cword>")

--     vim.ui.input(
--         { prompt = "Rename To: ", default = position_params.oldName },
--         function(input)
--             if input == nil then
--                 vim.notify("[LSP] aborted rename", 3, { render = "minimal" })
--                 return
--             end

--             position_params.newName = input
--             vim.lsp.buf_request(
--                 0,
--                 "textDocument/rename",
--                 position_params,
--                 function(err, result, ...)
--                     if not result or not result.changes then
--                         vim.notify(string.format("could not perform rename"), 4, {
--                             title = string.format(
--                                 "[LSP] rename: %s -> %s",
--                                 position_params.oldName,
--                                 position_params.newName
--                             ),
--                             timeout = 500,
--                         })
--                         return
--                     end

--                     vim.lsp.handlers["textDocument/rename"](err, result, ...)

--                     local notification, entries = "", {}
--                     local num_files, num_updates = 0, 0
--                     for uri, edits in pairs(result.changes) do
--                         num_files = num_files + 1
--                         local bufnr = vim.uri_to_bufnr(uri)

--                         for _, edit in ipairs(edits) do
--                             local start_line = edit.range.start.line + 1
--                             local line = vim.api.nvim_buf_get_lines(
--                                 bufnr,
--                                 start_line - 1,
--                                 start_line,
--                                 false
--                             )[1]

--                             num_updates = num_updates + 1
--                             table.insert(entries, {
--                                 bufnr = bufnr,
--                                 lnum = start_line,
--                                 col = edit.range.start.character + 1,
--                                 text = line,
--                             })
--                         end

--                         local short_uri = string.sub(
--                             vim.uri_to_fname(uri),
--                             #vim.fn.getcwd() + 2
--                         )
--                         notification = notification
--                             .. string.format(
--                                 "made %d change(s) in %s",
--                                 #edits,
--                                 short_uri
--                             )
--                     end

--                     vim.notify(notification, 2, {
--                         title = string.format(
--                             "[LSP] rename: %s -> %s",
--                             position_params.oldName,
--                             position_params.newName
--                         ),
--                         timeout = 2500,
--                     })

--                     if num_files > 1 then
--                         lk.qf_populate(entries, "r")
--                     end
--                 end
--             )
--         end
--     )
-- end
-- vim.lsp.buf.rename = qf_rename
-- -- }}}
-- ----------------------------------------------------------------------

-- vim:fdm=marker
