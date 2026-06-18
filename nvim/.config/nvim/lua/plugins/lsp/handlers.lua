local lsp = vim.lsp

lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
    if err then
        vim.notify("[LSP] definition error: " .. tostring(err), vim.log.levels.ERROR)
        return
    end
    if not result or vim.tbl_isempty(result) then
        vim.notify("[LSP] Could not find definition", 2, { title = "[LSP] definition" })
        return
    end

    local location = vim.tbl_islist(result) and result[1] or result
    lsp.util.show_document(location, "utf-8", { focus = true })
end

lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    vim.notify(result.message, lvl, {
        title = "LSP | " .. (client and client.name or ""),
        timeout = 8000,
        keep = function()
            return lvl == "ERROR" or lvl == "WARN"
        end,
    })
end

lsp.handlers["textDocument/implementation"] = function(err, result, ctx, config)
    if err then
        vim.notify("[LSP] implementation error: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    if not result or vim.tbl_isempty(result) then
        vim.notify("[LSP] Could not find implementation", vim.log.levels.INFO, {
            title = "[LSP] implementation",
        })
        return
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = ctx and ctx.bufnr or 0 })
    if ft == "go" and vim.tbl_islist(result) then
        local filtered = vim.tbl_filter(function(v)
            return not string.find(v.uri, "mock_")
        end, result)

        if #filtered > 0 then
            result = filtered
        end
    end

    local location = vim.tbl_islist(result) and result[1] or result
    lsp.util.show_document(location, "utf-8", { focus = true })

    vim.cmd([[normal! zz]])
end
