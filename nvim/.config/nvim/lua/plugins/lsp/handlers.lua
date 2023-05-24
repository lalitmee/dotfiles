local lsp = vim.lsp

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

lsp.handlers["textDocument/definition"] = function(_, result)
    if not result or vim.tbl_isempty(result) then
        vim.notify("[LSP] Could not find definition", 2, { title = "[LSP] definition" })
        return
    end

    if vim.tbl_islist(result) then
        lsp.util.jump_to_location(result[1], "utf-8", true)
    else
        lsp.util.jump_to_location(result, "utf-8", true)
    end
end

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
    border = "rounded",
    max_width = max_width,
    max_height = max_height,
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
    border = "rounded",
    max_width = max_width,
    max_height = max_height,
})

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

lsp.handlers["textDocument/implementation"] = function()
    local params = lsp.util.make_position_params(nil, "utf-8")

    lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
        local bufnr = ctx.bufnr
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if ft == "go" then
            local new_result = vim.tbl_filter(function(v)
                return not string.find(v.uri, "mock_")
            end, result)

            if #new_result > 0 then
                result = new_result
            end
        end

        lsp.handlers["textDocument/implementation"](err, result, ctx, config)
        vim.cmd([[normal! zz]])
    end)
end

local function qf_rename()
    local position_params = vim.lsp.util.make_position_params(nil, "utf-8")
    position_params.oldName = vim.fn.expand("<cword>")

    vim.ui.input({ prompt = "Rename To: ", default = position_params.oldName }, function(input)
        if input == nil then
            vim.notify("[LSP] aborted rename", 3, { render = "minimal" })
            return
        end

        position_params.newName = input
        vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, result, ...)
            if not result or not result.changes then
                vim.notify(string.format("could not perform rename"), 4, {
                    title = string.format("[LSP] rename: %s -> %s", position_params.oldName, position_params.newName),
                    timeout = 500,
                })
                return
            end

            vim.lsp.handlers["textDocument/rename"](err, result, ...)

            local notification, entries = "", {}
            local num_files, num_updates = 0, 0
            for uri, edits in pairs(result.changes) do
                num_files = num_files + 1
                local bufnr = vim.uri_to_bufnr(uri)

                for _, edit in ipairs(edits) do
                    local start_line = edit.range.start.line + 1
                    local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

                    num_updates = num_updates + 1
                    table.insert(entries, {
                        bufnr = bufnr,
                        lnum = start_line,
                        col = edit.range.start.character + 1,
                        text = line,
                    })
                end

                local short_uri = string.sub(vim.uri_to_fname(uri), #vim.fn.getcwd() + 2)
                notification = notification .. string.format("made %d change(s) in %s", #edits, short_uri)
            end

            vim.notify(notification, 2, {
                title = string.format("[LSP] rename: %s -> %s", position_params.oldName, position_params.newName),
                timeout = 2500,
            })

            if num_files > 1 then
                lk.qf_populate(entries, "r")
            end
        end)
    end)
end
vim.lsp.buf.rename = qf_rename
