local M = {}

----------------------------------------------------------------------
-- NOTE: reload using snacks picker {{{
----------------------------------------------------------------------
M.reload = function()
    local function get_module_name(s)
        local name = s:gsub("%.lua", ""):gsub("%/", "."):gsub("%.init", "")
        return name
    end

            Snacks.picker.files({
                prompt_title = "~ neovim modules ~",
                cwd = "~/.config/nvim/lua",
                file_ignore_patterns = { "after/", "lazy-lock.json", "stylua.toml" },
                actions = {
                    ["ctrl-r"] = {
                        name = "reload",
                        action = function(picker, item)
                            local relative = item.file:match("lua/(.+)$") or item.file
                            local name = get_module_name(relative)
                    R(name)
                    vim.notify(name, vim.log.levels.INFO, { title = "RELOADED" })
                end,
            },
        },
    })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
--- NOTE: reload using namesapce {{{
----------------------------------------------------------------------
-- M.reload_config = function()
--   for name, _ in pairs(package.loaded) do
--     if name:match("^lk") then
--       package.loaded[name] = nil
--     end
--   end
--
--   dofile(vim.env.MYVIMRC)
--   vim.notify("Config Reloaded", 2, { title = "[config] reload" })
-- end

M.reload_config = function()
    -- Handle impatient.nvim automatically.
    local luacache = (_G.__luacache or {}).cache

    for name, _ in pairs(package.loaded) do
        if name:match("") then
            package.loaded[name] = nil

            if luacache then
                luacache[name] = nil
            end
        end
    end

    dofile(vim.env.MYVIMRC)
    vim.notify("Config Reloaded", 2, { title = "[config] reload" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: reload module {{{
----------------------------------------------------------------------
M.reload_module = function(module_name)
    local matcher = function(pack)
        return string.find(pack, module_name, 1, true)
    end

    -- Handle impatient.nvim automatically.
    local luacache = (_G.__luacache or {}).cache

    for pack, _ in pairs(package.loaded) do
        if matcher(pack) then
            package.loaded[pack] = nil

            if luacache then
                luacache[pack] = nil
            end
        end
    end
end
-- }}}
----------------------------------------------------------------------

return M

-- vim:foldmethod=marker
