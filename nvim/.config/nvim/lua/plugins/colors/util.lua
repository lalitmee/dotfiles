local function rgb_to_hex(rgb)
    if rgb then
        return string.format("#%06x", rgb)
    end
    return nil
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

        if normal and normal.bg and normal.fg then
            local bg = rgb_to_hex(normal.bg)
            local fg = rgb_to_hex(normal.fg)

            -- Send to Tmux update script
            local cmd = string.format("update-tmux-colors %s %s", bg, fg)
            os.execute(cmd)
        else
            print("[TMUX SYNC] Could not detect Normal highlight group.")
        end
    end,
})
