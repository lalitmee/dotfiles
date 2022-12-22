local M = {
    "narutoxy/silicon.lua",
    cmd = { "Silicon", "SiliconCopy", "SiliconBuf" },
}

function M.config()
    local ok, silicon = lk.require("silicon")
    if not ok then
        return
    end

    silicon.setup({
        font = "JetBrains Mono",
    })

    --------------------------------------------------------------------------------
    --  NOTE: commands {{{
    --------------------------------------------------------------------------------
    local command = lk.command

    command("Silicon", function()
        silicon.visualise_api({})
    end, { range = "%" })

    command("SiliconBuf", function()
        silicon.visualise_api({ show_buf = true })
    end, { range = "%" })

    command("SiliconCopy", function()
        silicon.visualise_api({ to_clip = true })
    end, { range = "%" })

    -- }}}
    --------------------------------------------------------------------------------
end

return M
