-- Check if the script has already been loaded for this buffer
if vim.b.gitcommit_loaded then
    return
end
vim.b.gitcommit_loaded = true

local bufname = vim.api.nvim_buf_get_name(0)

-- Explicitly disable spell check for guh buffers
if bufname:match("^guh://") then
    vim.opt_local.spell = false
end

-- Only run for actual commit edit buffers, not for guh.nvim or other read-only/view buffers
if not (bufname:match("COMMIT_EDITMSG") or bufname:match("MERGE_MSG") or bufname:match("SQUASH_MSG")) then
    return
end

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
    notification_id = "agy_commit_msg",
    notification_title = "Antigravity CLI",
    spinner_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    prompt = "Generate a conventional commit message following these rules: 1. Use conventional commit format type(scope): description 2. A body containing at least one bullet point is MANDATORY. Hard-wrap all lines in the commit message body to be strictly under 72 characters per line (break long lines with newlines). Do not generate a single-line commit message; always provide both the header and a bulleted list describing the changes. 3. Keep title under 50 chars and use ONLY lowercase letters/characters in the title (no uppercase letters at all in the first line) 4. Use imperative mood 5. Respond with ONLY the commit message 6. In the body of the commit message, use only lowercase letters for general text, but capitalize proper nouns, code (from diff) and acronyms",
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
local command = string.format([[git diff --cached | agy -p "%s"]], config.prompt)

vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
        spinner.stop()
        if data and #data > 0 then
            if vim.api.nvim_buf_is_valid(state.original_bufnr) and vim.api.nvim_get_current_buf() == state.original_bufnr then
                local output = table.concat(data, "\n")
                -- Discard any trailing summary or metadata block separated by "---"
                local separator_idx = output:find("\n%s*---%s*\n") or output:find("\n%s*---%s*$")
                local clean_output = separator_idx and output:sub(1, separator_idx - 1) or output
                local commit_message = clean_output:gsub("^%s*(.-)%s*$", "%1")
                vim.api.nvim_buf_set_lines(state.original_bufnr, 0, 0, false, vim.split(commit_message, "\n"))
                notify("✨ Commit message generated and inserted into buffer!", vim.log.levels.INFO, { timeout = 2000 })
            else
                notify("Gitcommit buffer closed. Antigravity response discarded.", vim.log.levels.WARN, { timeout = 5000 })
            end
        end
    end,
    on_stderr = function(_, data)
        local stderr = table.concat(data, "\n")
        -- Only stop the spinner and notify if a real error is detected.
        if not stderr:find("mcp") and stderr:find("Error:") then
            spinner.stop()
            notify("Antigravity CLI error: " .. stderr, vim.log.levels.ERROR)
        end
    end,
    on_exit = function()
        -- Ensure the spinner is always stopped when the job exits.
        spinner.stop()
    end,
})
