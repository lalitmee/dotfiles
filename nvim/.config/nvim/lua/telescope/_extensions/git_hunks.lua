local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local Job = require("plenary.job")

-- Utility: parse git diff output into structured entries
local function parse_git_diff(callback)
    local results = {}
    local current_file = nil
    local current_hunk = nil
    local hunk_lines = {}

    Job:new({
        command = "git",
        args = { "diff", "--unified=0", "--no-color" },
        env = { GIT_PAGER = "cat" }, -- Ensure no pager
        on_stdout = function(_, line)
            print("Git Diff Line: " .. line) -- Log every line from git diff
            if line:match("^diff --git") then
                -- Insert the previous result before moving to the next file
                if current_file and current_hunk then
                    table.insert(results, {
                        filename = current_file,
                        lnum = current_hunk.lnum,
                        display = string.format("%s:%d", current_file, current_hunk.lnum),
                        hunk = table.concat(hunk_lines, "\n"),
                    })
                end

                -- Extract the file path from the diff line
                local file_a, file_b = line:match("^diff --git a/(.-) b/(.+)")
                if file_b then
                    current_file = file_b -- file_b is the actual file name from the diff
                else
                    current_file = nil
                end

                current_hunk = nil
                hunk_lines = { line }
            elseif line:match("^@@") then
                -- Start a new hunk
                if current_hunk then
                    table.insert(results, {
                        filename = current_file,
                        lnum = current_hunk.lnum,
                        display = string.format("%s:%d", current_file, current_hunk.lnum),
                        hunk = table.concat(hunk_lines, "\n"),
                    })
                    hunk_lines = {}
                end
                local plus_section = line:match("%+%d+,%d+") or line:match("%+%d+")
                local lnum = tonumber((plus_section or "+0"):match("%d+"))
                current_hunk = { lnum = lnum }
                table.insert(hunk_lines, line)
            elseif current_file then
                -- Accumulate lines in the current hunk
                table.insert(hunk_lines, line)
            end
        end,
        on_exit = vim.schedule_wrap(function()
            if current_file and current_hunk then
                table.insert(results, {
                    filename = current_file,
                    lnum = current_hunk.lnum,
                    display = string.format("%s:%d", current_file, current_hunk.lnum),
                    hunk = table.concat(hunk_lines, "\n"),
                })
            end
            print("Parsed Results: " .. vim.inspect(results)) -- Log the parsed results
            callback(results)
        end),
    }):start()
end

-- Custom previewer to show the hunk diff
local hunk_previewer = previewers.new_buffer_previewer({
    define_preview = function(self, entry)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.hunk, "\n"))
        vim.bo[self.state.bufnr].filetype = "diff"
    end,
})

-- Main picker function
local function open_git_hunks_picker()
    parse_git_diff(function(entries)
        pickers
            .new({}, {
                prompt_title = "Git Hunks",
                results_title = "Modified Hunks",
                finder = finders.new_table({
                    results = entries,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry.display,
                            ordinal = entry.display,
                            filename = entry.filename,
                            lnum = entry.lnum,
                            hunk = entry.hunk,
                        }
                    end,
                }),
                sorter = sorters.get_generic_fuzzy_sorter(),
                previewer = hunk_previewer,
                attach_mappings = function(prompt_bufnr, map)
                    local function apply_patch(reverse)
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)

                        if entry and entry.hunk then
                            local patch = entry.hunk
                            Job
                                :new({
                                    command = "sh",
                                    args = {
                                        "-c",
                                        string.format(
                                            "printf '%s' | git apply %s --cached",
                                            patch:gsub("'", "'\\''"),
                                            reverse and "-R" or ""
                                        ),
                                    },
                                })
                                :start()
                        end
                    end

                    map("i", "<C-s>", function()
                        apply_patch(false)
                    end)
                    map("n", "<C-s>", function()
                        apply_patch(false)
                    end)
                    map("i", "<C-u>", function()
                        apply_patch(true)
                    end)
                    map("n", "<C-u>", function()
                        apply_patch(true)
                    end)

                    return true
                end,
            })
            :find()
    end)
end

local function run()
    open_git_hunks_picker()
end

return require("telescope").register_extension({
    exports = {
        -- Default when to argument is given, i.e. :Telescope changes
        git_hunks = run,
    },
})
