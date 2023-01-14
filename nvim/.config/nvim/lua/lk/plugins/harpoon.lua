local M = {
    "ThePrimeagen/harpoon",
    cmd = {
        "HarpoonAddFile",
        "HarpoonGotoFile",
        "HarpoonGotoTerm",
        "HarpoonGotoTmux",
        "HarpoonNextMark",
        "HarpoonPrevMark",
        "HarpoonRemoveFile",
        "HarpoonSendCmdToTerm",
        "HarpoonSendCmdToTmux",
        "ToggleHarpoonCmdMenu",
        "ToggleHarpoonMenu",
    },
}

function M.config()
    local ok, harpoon = lk.require("harpoon")
    if not ok then
        return
    end

    local command = lk.command

    harpoon.setup({
        menu = {
            width = vim.api.nvim_win_get_width(0) - 150,
            height = vim.api.nvim_win_get_height(0) - 30,
        },
        enter_on_sendcmd = true,
        mark_branch = true,
        save_on_toggle = true,
        tmux_autoclose_windows = true,
    })

    ----------------------------------------------------------------------
    -- NOTE: load telescope extension {{{
    ----------------------------------------------------------------------
    require("telescope").load_extension("harpoon")
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: harpoon commands {{{
    ----------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --  NOTE: file navigations {{{
    --------------------------------------------------------------------------------
    command("HarpoonAddFile", function()
        require("harpoon.mark").add_file()
    end, {})

    command("HarpoonGotoFile", function(args)
        local number = tonumber(args["args"])
        require("harpoon.ui").nav_file(number)
    end, {
        nargs = 1,
    })

    command("HarpoonRemoveFile", function()
        require("harpoon.mark").rm_file()
    end, {})
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: terminal {{{
    --------------------------------------------------------------------------------
    command("HarpoonGotoTerm", function(args)
        local number = tonumber(args["args"])
        require("harpoon.term").gotoTerminal(number)
    end, {
        nargs = 1,
    })

    command("HarpoonSendCmdToTerm", function(args)
        local argsString = args["args"]
        local numberAndCmd = vim.split(argsString, " ")
        local number = tonumber(numberAndCmd[1])
        local cmd = numberAndCmd[2]
        require("harpoon.term").sendCommand(number, cmd)
    end, {
        nargs = 1,
    })
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: tmux {{{
    --------------------------------------------------------------------------------
    command("HarpoonGotoTmux", function(args)
        local number = tonumber(args["args"])
        require("harpoon.tmux").gotoTerminal(number)
    end, {
        nargs = 1,
    })

    command("HarpoonSendCmdToTmux", function(args)
        local argsString = args["args"]
        local numberAndCmd = vim.split(argsString, " ")
        local number = tonumber(numberAndCmd[1])
        local cmd = numberAndCmd[2]
        require("harpoon.tmux").sendCommand(number, cmd)
    end, {
        nargs = 1,
    })
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: marks navigation {{{
    --------------------------------------------------------------------------------
    command("HarpoonNextMark", function()
        require("harpoon.ui").nav_next()
    end, {})

    command("HarpoonPrevMark", function()
        require("harpoon.ui").nav_prev()
    end, {})
    -- }}}
    --------------------------------------------------------------------------------

    command("ToggleHarpoonMenu", function()
        require("harpoon.ui").toggle_quick_menu()
    end, {})

    command("ToggleHarpoonCmdMenu", function()
        require("harpoon.cmd-ui").toggle_quick_menu()
    end, {})

    -- }}}
    ----------------------------------------------------------------------
end

return M

-- vim:foldmethod=marker:foldlevel=0
