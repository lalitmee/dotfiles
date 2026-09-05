local M = {}

local config = {
    notification_id = "agy_commit_msg",
    notification_title = "Antigravity CLI",
    spinner_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
}

local state = {
    job_id = nil,
    spinner_running = false,
    spinner_timer = nil,
    spinner_index = 1,
    target_bufnr = nil,
}

local function notify(message, level, opts)
    opts = opts or {}
    opts.id = config.notification_id
    opts.title = opts.title or config.notification_title
    vim.notify(message, level, opts)
end

local function spinner_update()
    notify("Generating commit message...", vim.log.levels.INFO, {
        title = config.spinner_chars[state.spinner_index] .. " " .. config.notification_title,
        timeout = false,
    })
    state.spinner_index = state.spinner_index % #config.spinner_chars + 1
end

local function spinner_start()
    if not state.spinner_running then
        state.spinner_running = true
        notify("Generating commit message...", vim.log.levels.INFO, {
            title = config.spinner_chars[1] .. " " .. config.notification_title,
            timeout = false,
        })
        state.spinner_timer = vim.loop.new_timer()
        if state.spinner_timer then
            state.spinner_timer:start(0, 100, vim.schedule_wrap(spinner_update))
        end
    end
end

local function spinner_stop()
    if state.spinner_running then
        if state.spinner_timer then
            state.spinner_timer:stop()
            state.spinner_timer:close()
            state.spinner_timer = nil
        end
        state.spinner_running = false
    end
end

--- Retrieves the git diff from staged changes, falling back to HEAD~1
--- @return string|nil diff content or nil if not found
function M.get_git_diff()
    local diff = vim.fn.system("git diff --cached --no-ext-diff")
    if vim.v.shell_error == 0 and diff:gsub("%s+", "") ~= "" then
        return diff
    end
    -- Fallback for amending previous commit
    local amend_diff = vim.fn.system("git diff HEAD~1 --no-ext-diff")
    if vim.v.shell_error == 0 and amend_diff:gsub("%s+", "") ~= "" then
        return amend_diff
    end
    return nil
end

--- Strips markdown code fences, headers, or metadata blocks from model output
--- @param raw string Raw LLM text
--- @return string Cleaned commit message
function M.clean_commit_output(raw)
    local text = raw or ""
    -- Discard any trailing summary or metadata block separated by "---"
    local separator_idx = text:find("\n%s*---%s*\n") or text:find("\n%s*---%s*$")
    if separator_idx then
        text = text:sub(1, separator_idx - 1)
    end
    -- Strip markdown code fences if present
    text = text:gsub("^%s*```[%w_-]*\r?\n", "")
    text = text:gsub("\r?\n```%s*$", "")
    -- Trim leading and trailing whitespace
    text = text:gsub("^%s*(.-)%s*$", "%1")
    return text
end

--- Builds prompt containing conventional commit instructions and the git diff
--- @param diff string
--- @return string
function M.build_prompt(diff)
    return table.concat({
        "Generate a conventional commit message following these rules:",
        "1. Use conventional commit format type(scope): description",
        "2. A body containing at least one bullet point is MANDATORY. Hard-wrap all lines in the commit message body to be strictly under 72 characters per line (break long lines with newlines). Do not generate a single-line commit message; always provide both the header and a bulleted list describing the changes.",
        "3. Keep title under 50 chars and use ONLY lowercase letters/characters in the title (no uppercase letters at all in the first line)",
        "4. Use imperative mood",
        "5. Respond with ONLY the commit message (no introductory or concluding text, no markdown backticks/fences, no explanations).",
        "6. In the body of the commit message, use only lowercase letters for general text, but capitalize proper nouns, code (from diff) and acronyms.",
        "",
        "Git diff:",
        "```diff",
        diff,
        "```",
    }, "\n")
end

--- Cancels any in-flight commit generation job
function M.cancel()
    if state.job_id then
        pcall(vim.fn.jobstop, state.job_id)
        state.job_id = nil
    end
    spinner_stop()
end

--- Checks if the given buffer is a valid commit edit buffer
--- @param bufnr number|nil
--- @return boolean
function M.is_commit_buffer(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    return (
        bufname:match("COMMIT_EDITMSG")
        or bufname:match("MERGE_MSG")
        or bufname:match("SQUASH_MSG")
        or bufname:match("TAG_EDITMSG")
        or bufname:match("NeogitCommitMessage")
    ) ~= nil
end

--- Generates a commit message and inserts it into the specified buffer
--- @param bufnr number|nil Buffer number (defaults to current buffer)
--- @param opts table|nil Optional options table
function M.generate(bufnr, opts)
    opts = opts or {}
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        notify("Invalid buffer for commit generation", vim.log.levels.ERROR)
        return
    end

    -- Cancel any currently running job
    M.cancel()

    local diff = M.get_git_diff()
    if not diff then
        notify("No staged git changes found to generate commit message", vim.log.levels.WARN, { timeout = 3000 })
        return
    end

    state.target_bufnr = bufnr
    spinner_start()

    local prompt = M.build_prompt(diff)
    local cmd = {
        "agy",
        "-p",
        prompt,
        "--disable-slash-commands",
    }

    local stdout_chunks = {}
    local stderr_chunks = {}

    state.job_id = vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    table.insert(stdout_chunks, line)
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    table.insert(stderr_chunks, line)
                end
            end
        end,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                spinner_stop()
                state.job_id = nil

                if exit_code ~= 0 then
                    local stderr_text = table.concat(stderr_chunks, "\n"):gsub("^%s*(.-)%s*$", "%1")
                    notify("Antigravity CLI failed (exit " .. exit_code .. "): " .. stderr_text, vim.log.levels.ERROR)
                    return
                end

                local raw_output = table.concat(stdout_chunks, "\n")
                local commit_message = M.clean_commit_output(raw_output)

                if commit_message == "" then
                    notify("Antigravity CLI returned empty commit message.", vim.log.levels.WARN, { timeout = 4000 })
                    return
                end

                if vim.api.nvim_buf_is_valid(state.target_bufnr) then
                    local lines = vim.split(commit_message, "\n")
                    vim.api.nvim_buf_set_lines(state.target_bufnr, 0, 0, false, lines)
                    notify("✨ Commit message generated and inserted into buffer!", vim.log.levels.INFO, { timeout = 2000 })
                else
                    notify("Gitcommit buffer closed. Antigravity response discarded.", vim.log.levels.WARN, { timeout = 5000 })
                end
            end)
        end,
    })
end

--- Auto-generate commit message when opening a commit buffer (if buffer matches)
--- @param bufnr number|nil
function M.auto_generate(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    if not M.is_commit_buffer(bufnr) then
        return
    end
    M.generate(bufnr)
end

return M
