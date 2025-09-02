local M = {}

function M.start_fidget()
    local has_fidget, fidget = pcall(require, "fidget")
    if not has_fidget then
        return
    end

    if M.fidget_progress_handle then
        M.fidget_progress_handle.message = "Abort."
        M.fidget_progress_handle:cancel()
        M.fidget_progress_handle = nil
    end

    M.fidget_progress_handle = fidget.progress.handle.create({
        title = "",
        message = "Thinking...",
        lsp_client = { name = "CodeCompanion" },
    })
end

function M.stop_fidget()
    local has_fidget, _ = pcall(require, "fidget")
    if not has_fidget then
        return
    end

    if M.fidget_progress_handle then
        M.fidget_progress_handle.message = "Done."
        M.fidget_progress_handle:finish()
        M.fidget_progress_handle = nil
    end
end

function M.setup()
    local has_fidget, _ = pcall(require, "fidget")
    if has_fidget then
        -- New AU group:
        local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

        -- Attach:
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequest*",
            group = group,
            callback = function(request)
                if request.match == "CodeCompanionRequestStarted" then
                    M.start_fidget()
                elseif request.match == "CodeCompanionRequestFinished" then
                    M.stop_fidget()
                end
            end,
        })
    end
end

return M
