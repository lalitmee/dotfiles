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

-- Auto-generate commit message using Gemini CLI when opening gitcommit buffer
local spinner_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local spinner_running = false
local spinner_timer = nil

-- Function to update spinner
local function update_spinner()
    vim.notify("Generating commit message...", vim.log.levels.INFO, {
        id = "gemini_commit_msg",
        title = spinner_chars[spinner_index] .. " Gemini CLI",
        timeout = false, -- Keep it visible
    })
    spinner_index = spinner_index % #spinner_chars + 1
end

-- Start spinner notification (only if not already running)
if not spinner_running then
    spinner_running = true
    vim.notify("Generating commit message...", vim.log.levels.INFO, {
        id = "gemini_commit_msg",
        title = spinner_chars[1] .. " Gemini CLI",
        timeout = false,
    })

    -- Start spinner timer (update every 100ms)
    spinner_timer = vim.loop.new_timer()
    if spinner_timer then
        spinner_timer:start(0, 100, vim.schedule_wrap(update_spinner))
    end
end

-- Run gemini CLI with git diff piped to it
vim.fn.jobstart(
    "git diff --cached | gemini --prompt 'Generate a conventional commit message following these rules: 1. Use conventional commit format type(scope): description 2. Include at least one bullet point 3. Keep title under 50 chars 4. Use imperative mood 5. Respond with ONLY the commit message'",
    {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if spinner_running and data and #data > 0 then
                if spinner_timer then
                    spinner_timer:stop()
                    spinner_timer:close()
                end
                spinner_running = false

                local output = table.concat(data, "\n")
                local commit_message = output:gsub("^%s*(.-)%s*$", "%1")

                vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(commit_message, "\n"))

                vim.notify("✨ Commit message generated and inserted into buffer!", vim.log.levels.INFO, {
                    id = "gemini_commit_msg",
                    title = "Gemini CLI",
                    timeout = 2000,
                })
            end
        end,
        on_stderr = function(_, data)
            local stderr = table.concat(data, "\n")
            if not stderr:find("mcp") and stderr:find("Error:") then
                if spinner_timer then
                    spinner_timer:stop()
                    spinner_timer:close()
                end
                spinner_running = false

                vim.notify("Gemini CLI error: " .. stderr, vim.log.levels.ERROR, {
                    id = "gemini_commit_msg",
                    title = "Gemini CLI",
                })
            end
        end,
    }
)
