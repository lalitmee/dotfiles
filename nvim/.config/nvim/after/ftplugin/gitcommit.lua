-- Check if the script has already been loaded for this buffer
if vim.b.gitcommit_loaded then
    return
end
vim.b.gitcommit_loaded = true

local opt = vim.opt_local

opt.colorcolumn = { "50", "72" }
opt.expandtab = true
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.list = false
opt.number = false
opt.relativenumber = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.spell = true

-- Configuration for the script
local config = {
    notification_id = "gemini_commit_msg",
    notification_title = "Gemini CLI",
    spinner_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    prompt = "Generate a conventional commit message following these rules: 1. Use conventional commit format type(scope): description 2. Include at least one bullet point (not more than 72 chars long) 3. Keep title under 50 chars 4. Use imperative mood 5. Respond with ONLY the commit message 6. Use only lowercase letters for general text, but capitalize proper nouns, code (from diff) and acronyms",
}

-- State management for the script
local state = {
    spinner_running = false,
    spinner_timer = nil,
    spinner_index = 1,
    original_bufnr = vim.api.nvim_get_current_buf(),
}

-- Helper function for sending notifications
local function notify(message, level, opts)
    opts = opts or {}
    opts.id = config.notification_id
    opts.title = opts.title or config.notification_title
    vim.notify(message, level, opts)
end

local spinner = {}

function spinner.update()
    notify("Generating commit message...", vim.log.levels.INFO, {
        title = config.spinner_chars[state.spinner_index] .. " " .. config.notification_title,
        timeout = false,
    })
    state.spinner_index = state.spinner_index % #config.spinner_chars + 1
end

function spinner.start()
    if not state.spinner_running then
        state.spinner_running = true
        notify("Generating commit message...", vim.log.levels.INFO, {
            title = config.spinner_chars[1] .. " " .. config.notification_title,
            timeout = false,
        })
        state.spinner_timer = vim.loop.new_timer()
        if state.spinner_timer then
            state.spinner_timer:start(0, 100, vim.schedule_wrap(spinner.update))
        end
    end
end

function spinner.stop()
    if state.spinner_running then
        if state.spinner_timer then
            state.spinner_timer:stop()
            state.spinner_timer:close()
        end
        state.spinner_running = false
    end
end

-- Start the spinner
spinner.start()

-- Construct the command
local command = string.format("git diff --cached | gemini --prompt '%s'", config.prompt)

vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
        spinner.stop()
        if data and #data > 0 then
            if vim.api.nvim_buf_is_valid(state.original_bufnr) and vim.api.nvim_get_current_buf() == state.original_bufnr then
                local output = table.concat(data, "\n")
                local commit_message = output:gsub("^%s*(.-)%s*$", "%1")
                vim.api.nvim_buf_set_lines(state.original_bufnr, 0, 0, false, vim.split(commit_message, "\n"))
                notify("✨ Commit message generated and inserted into buffer!", vim.log.levels.INFO, { timeout = 2000 })
            else
                notify("Gitcommit buffer closed. Gemini response discarded.", vim.log.levels.WARN, { timeout = 5000 })
            end
        end
    end,
    on_stderr = function(_, data)
        local stderr = table.concat(data, "\n")
        -- Only stop the spinner and notify if a real error is detected.
        if not stderr:find("mcp") and stderr:find("Error:") then
            spinner.stop()
            notify("Gemini CLI error: " .. stderr, vim.log.levels.ERROR)
        end
    end,
    on_exit = function()
        -- Ensure the spinner is always stopped when the job exits.
        spinner.stop()
    end,
})
