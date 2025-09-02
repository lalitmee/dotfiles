local M = {}

function M.start_spinner()
    local ok = pcall(require, "snacks")
    if not ok then
        return
    end

    vim.notify("Thinking...", "info", {
        id = "codecompanion_progress",
        title = "CodeCompanion",
        timeout = false,
        dismiss = false,
        opts = function(notif)
            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] .. " "
        end,
    })
end

function M.stop_spinner()
    local ok = pcall(require, "snacks")
    if not ok then
        return
    end

    vim.notify("Done!", "info", {
        id = "codecompanion_progress",
        title = "CodeCompanion",
        icon = " ",
        timeout = 2000,
    })
end

function M.setup()
    local group = vim.api.nvim_create_augroup("CodeCompanionSnacksHooks", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
        group = group,
        callback = function(args)
            if args.match == "CodeCompanionRequestStarted" then
                M.start_spinner()
            elseif args.match == "CodeCompanionRequestFinished" then
                M.stop_spinner()
            end
        end,
    })
end

return M
