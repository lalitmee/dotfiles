local M = {}

M.git_hunks = function()
    Snacks.picker.grep({
        prompt = "Git Hunks",
        cmd = { "git-jump", "diff" },
    })
end

M.git_buffer_hunks = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    Snacks.picker.grep({
        prompt = "Git Buffer Hunks",
        cmd = { "git-jump", "diff", bufname },
    })
end

M.set_wallpaper = function()
    Snacks.picker.files({
        prompt = "Wallpapers",
        cwd = "~/Projects/Personal/Github/wallpapers/",
        actions = {
            ["confirm"] = {
                action = function(picker, item)
                    local path = item.file
                    vim.fn.system("feh --bg-scale " .. path)
                    vim.notify('Wallpaper set to ' .. path)
                    picker:close()
                end,
            },
        },
    })
end

M.live_workspace_symbols = function(opts)
    opts = opts or {}
    Snacks.picker.lsp_workspace_symbols(opts)
end

M.messages = function()
    local lines = vim.api.nvim_exec("messages", true)
    local tmp = vim.fn.tempname()
    vim.fn.writefile(vim.split(lines, "\n"), tmp)
    Snacks.picker.grep({
        prompt = "Messages",
        cmd = { "cat", tmp },
    })
end

M.multi_ripgrep = function()
    Snacks.picker.grep({
        prompt = "Multi Ripgrep",
    })
end

return M
