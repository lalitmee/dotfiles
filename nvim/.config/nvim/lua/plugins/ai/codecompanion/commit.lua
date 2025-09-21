local function get_git_diff()
    local diff_staged = vim.fn.system("git diff --no-ext-diff --staged")
    local diff_unstaged = vim.fn.system("git diff")
    local untracked_files = vim.fn.system("git ls-files --others --exclude-standard")

    local diffs = {}
    if diff_staged ~= "" then
        table.insert(diffs, "### Staged\n```diff\n" .. diff_staged .. "\n```")
    end
    if diff_unstaged ~= "" then
        table.insert(diffs, "### Unstaged\n```diff\n" .. diff_unstaged .. "\n```")
    end
    if untracked_files ~= "" then
        local untracked_diffs = {}
        for _, file in ipairs(vim.split(untracked_files, "\n")) do
            if file ~= "" then
                local diff_output = vim.fn.system("git diff --no-index -- /dev/null " .. vim.fn.fnameescape(file))
                table.insert(untracked_diffs, diff_output)
            end
        end
        if #untracked_diffs > 0 then
            table.insert(diffs, "### Untracked\n```diff\n" .. table.concat(untracked_diffs, "\n") .. "\n```")
        end
    end

    if #diffs == 0 then
        return nil
    end

    return table.concat(diffs, "\n\n")
end

local function generate_commit_message()
    local diff_content = get_git_diff()
    if not diff_content then
        vim.notify("No git diff available", vim.log.levels.INFO, { title = "CodeCompanion" })
        return nil
    end

    local content = [[
@cmd_runner
- Task:
  - Write commit message for the diffs with `commitizen convention`.
  - Wrap the whole message in code block with language `gitcommit`
  - After generating commit message, stage diffs and then commit them with `git commit -F- <<EOF`.

### Git Diff
]] .. diff_content

    return content
end

return generate_commit_message