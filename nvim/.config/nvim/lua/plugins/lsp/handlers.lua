local lsp = vim.lsp
-- local methods = vim.lsp.protocol.Methods

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
        title = "LSP | " .. (client and client.name or ""),
        timeout = 8000,
        keep = function()
            return lvl == "ERROR" or lvl == "WARN"
        end,
    })
end

lsp.handlers["textDocument/implementation"] = function()
    local params = lsp.util.make_position_params(nil, "utf-8")

    lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
        local ft = vim.api.nvim_get_option_value("filetype")
        if ft == "go" then
            local new_result = vim.tbl_filter(function(v)
                return not string.find(v.uri, "mock_")
            end, result)

            if #new_result > 0 then
                result = new_result
            end
        end

        lsp.handlers["textDocument/implementation"]()
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

local md_namespace = vim.api.nvim_create_namespace("lalitmee/lsp_float")

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
local function enhanced_float_handler(handler)
    return function(err, result, ctx, config)
        local buf, win = handler(
            err,
            result,
            ctx,
            vim.tbl_deep_extend("force", config or {}, {
                border = "rounded",
                max_height = math.floor(vim.o.lines * 0.5),
                max_width = math.floor(vim.o.columns * 0.4),
            })
        )

        if not buf or not win then
            return
        end

        -- Conceal everything.
        vim.wo[win].concealcursor = "n"

        -- Extra highlights.
        for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            for pattern, hl_group in pairs({
                ["|%S-|"] = "@text.reference",
                ["@%S+"] = "@parameter",
                ["^%s*(Parameters:)"] = "@text.title",
                ["^%s*(Return:)"] = "@text.title",
                ["^%s*(See also:)"] = "@text.title",
                ["{%S-}"] = "@parameter",
            }) do
                local from = 1 ---@type integer?
                while from do
                    local to
                    from, to = line:find(pattern, from)
                    if from then
                        vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
                            end_col = to,
                            hl_group = hl_group,
                        })
                    end
                    from = to and to + 1 or nil
                end
            end
        end

        -- Add keymaps for opening links.
        if not vim.b[buf].markdown_keys then
            vim.keymap.set("n", "K", function()
                -- Vim help links.
                local url = (vim.fn.expand("<cWORD>") --[[@as string]]):match("|(%S-)|")
                if url then
                    return vim.cmd.help(url)
                end

                -- Markdown links.
                local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                local from, to
                from, to, url = vim.api.nvim_get_current_line():find("%[.-%]%((%S-)%)")
                if from and col >= from and col <= to then
                    vim.system({ "open", url }, nil, function(res)
                        if res.code ~= 0 then
                            vim.notify("Failed to open URL" .. url, vim.log.levels.ERROR)
                        end
                    end)
                end
            end, { buffer = buf, silent = true })
            vim.b[buf].markdown_keys = true
        end
    end
end

-- vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover)
-- vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help)
