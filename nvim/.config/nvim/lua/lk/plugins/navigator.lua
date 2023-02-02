local M = {
    "numToStr/Navigator.nvim",
    cmd = {
        "NavigateDown",
        "NavigateLeft",
        "NavigatePrevious",
        "NavigateRight",
        "NavigateUp",
    },
}

 M.config = function()
    local navigator = require("Navigator")

    navigator.setup()

    ----------------------------------------------------------------------
    -- NOTE: commands {{{
    ----------------------------------------------------------------------
    local command = lk.command

    command("NavigateLeft", function()
        navigator.left()
    end, {})

    command("NavigateDown", function()
        navigator.down()
    end, {})

    command("NavigateUp", function()
        navigator.up()
    end, {})

    command("NavigateRight", function()
        navigator.right()
    end, {})

    command("NavigatePrevious", function()
        navigator.previous()
    end, {})

    -- }}}
    ----------------------------------------------------------------------
end

return M
